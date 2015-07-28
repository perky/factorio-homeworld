local soil_richness = {
	["grass"]       = 1.00,
	["grass-medium"]= 0.97,
	["grass-dry"]   = 0.92,
	["dirt"]        = 0.5,
	["dirt-dark"]   = 0.4,
	["hills"]       = 0.5,
	["sand"]        = 0.05,
	["sand-dark"]   = 0.05
}

local farm_stage_entity = {
	{name = "farm", stock = 0},
	{name = "farm_01", stock = 30},
	{name = "farm_02", stock = 200},
	{name = "farm_03", stock = 300},
	{name = "farm_full", stock = 400},
}

ActorClass("Farm", {
	open_gui_on_selected = true,
	production_rate = 1 * GAME_DAY,
	pollution_multiplier = 1,
	max_pollution = 3000,
	radius = 5,
	max_wheat_yield_per_min = 200,
	max_hops_yield_per_min = 100,
	max_veg_yield_per_min = 100,
	max_grapes_yield_per_min = 50,
})

function Farm:Init()
	self.enabled = true
	self.gui = {}
	self.stage = 1

	local pos = self.entity.position
	local surface = self.entity.surface
	local area = SquareArea(pos, self.radius)
	local totalArea = 0
	local totalRichness = 0
	for x, y in iarea(area) do
		local tile = surface.get_tile(x, y)
		local richness = 0
		if soil_richness[tile.name] then
			richness = soil_richness[tile.name]
		end
		totalArea = totalArea + 1
		totalRichness = totalRichness + richness
	end

	self.soil_richness = totalRichness / totalArea
	self:CalculateYield()
	self:StartRoutines()
end

function Farm:OnLoad()
	self.enabled = true
	self:StartRoutines()
end

function Farm:OnDestroy()
	self.enabled = false
	for i, gui in pairs(self.gui) do
		gui.destroy()
	end
	self.gui = {}
	DestroyRoutines(self)
end

function Farm:StartRoutines()
	StartCoroutine(self.FarmRoutine, {delegate = self, validater = self.ValidateRoutine})
	StartCoroutine(self.StageRoutine, {delegate = self, validater = self.ValidateRoutine})
end

function Farm:ValidateRoutine()
	return self.enabled and self.entity and self.entity.valid
end

function Farm:CalculateYield()
	local pollution = world_surface.get_pollution(self.entity.position) * self.pollution_multiplier
	self.air_purity = RemapNumber(pollution, 0, self.max_pollution, 1, 0)
	if self.air_purity < 0 then
		self.air_purity = 0
	end
	self.yield = math.max(self.soil_richness * self.air_purity, 0)
end

function Farm:SetEntityStage( stage )
	local surface = self.entity.surface
	local contents = self.entity.get_inventory(1).get_contents()
	local newFarmEntity = surface.create_entity{
		name = farm_stage_entity[stage].name,
		force = self.entity.force,
		position = self.entity.position
	}
	self.entity.destroy()
	self.entity = newFarmEntity
	local newInventory = newFarmEntity.get_inventory(1)
	for itemName, itemCount in pairs(contents) do
		newInventory.insert{name = itemName, count = itemCount}
	end
end

function Farm:StageRoutine()
	self:SetEntityStage(self.stage)

	while self.enabled do
		WaitForTicks(10 * SECONDS)

		local inventory = self.entity.get_inventory(1)
		local wheatCount = inventory.get_item_count("wheat")
		local hopCount = inventory.get_item_count("hops")
		local totalStock = wheatCount + hopCount

		local currentFarmStageIndex = self.stage
		local currentFarmStage = farm_stage_entity[self.stage]

		for i, farmStage in ipairs(farm_stage_entity) do
			if totalStock >= farmStage.stock then
				currentFarmStage = farmStage
				currentFarmStageIndex = i
			end
		end

		if currentFarmStageIndex ~= self.stage then
			self.stage = currentFarmStageIndex
			self:SetEntityStage(self.stage)
		end

		coroutine.yield()
	end
end

function Farm:FarmRoutine()
	while self.enabled do
		WaitForTicks(self.production_rate)

		self:CalculateYield()
		local inventory = self.entity.get_inventory(1)

		local maxWheatYield = (self.max_wheat_yield_per_min * self.production_rate) / (1*MINUTES)
		local maxHopsYield = (self.max_hops_yield_per_min * self.production_rate) / (1*MINUTES)
		local maxVegYield = (self.max_veg_yield_per_min * self.production_rate) / (1*MINUTES)
		local maxGrapesYield = (self.max_grapes_yield_per_min * self.production_rate) / (1*MINUTES)
		inventory.insert{name = "wheat", count = math.floor(maxWheatYield * self.yield)}
		inventory.insert{name = "hops", count = math.floor(maxHopsYield * self.yield)}
		inventory.insert{name = "vegetables", count = math.floor(maxVegYield * self.yield)}
		inventory.insert{name = "grapes", count = math.floor(maxGrapesYield * self.yield)}
		
		self:UpdateGUIForAllPlayers()

		coroutine.yield()
	end
end

function Farm:OpenGUI( playerIndex )
	GUI.PushLeftSection(playerIndex)
	self.gui[playerIndex] = GUI.PushParent(GUI.Frame("farm_gui", "Farm", GUI.VERTICAL))
	GUI.LabelData("richness", "Soil Richness:", "0%")
	GUI.LabelData("purity", "Air Purity:", "0%")
	GUI.LabelData("yield", "Yield:", "0%")
	GUI.PopAll()
	self:UpdateGUI(playerIndex)
end

function Farm:CloseGUI( playerIndex )
	if self.gui[playerIndex] then
		self.gui[playerIndex].destroy()
		self.gui[playerIndex] = nil
	end
end

function Farm:UpdateGUIForAllPlayers()
	for playerIndex = 1, #game.players do
		self:UpdateGUI(playerIndex)
	end
end

function Farm:UpdateGUI( playerIndex )
	if self.gui[playerIndex] and self.yield then
		local format = "%i%%"
		self.gui[playerIndex].richness.data.caption = string.format(format, math.floor(self.soil_richness * 100))
		self.gui[playerIndex].purity.data.caption = string.format(format, math.floor(self.air_purity * 100))
		self.gui[playerIndex].yield.data.caption = string.format(format, math.floor(self.yield * 100))
	end
end
