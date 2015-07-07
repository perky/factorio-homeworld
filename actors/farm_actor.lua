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

ActorClass("Farm", {
	open_gui_on_selected = true,
	production_rate = 1 * GAME_DAY,
	pollution_multiplier = 1,
	max_pollution = 1500,
	radius = 5,
	max_wheat_yield_per_min = 200,
	max_hops_yield_per_min = 100,
	max_veg_yield_per_min = 100,
	max_grapes_yield_per_min = 50,
})

function Farm:Init()
	self.enabled = true
	self.gui = {}

	local pos = self.entity.position
	local area = SquareArea(pos, self.radius)
	local totalArea = 0
	local totalRichness = 0
	for x, y in iarea(area) do
		local tile = game.gettile(x, y)
		local richness = 0
		if soil_richness[tile.name] then
			richness = soil_richness[tile.name]
		end
		totalArea = totalArea + 1
		totalRichness = totalRichness + richness
	end

	self.soil_richness = totalRichness / totalArea
	self:CalculateYield()

	StartCoroutine(self.FarmRoutine, self)
end

function Farm:OnLoad()
	self.enabled = true
	StartCoroutine(self.FarmRoutine, self)
end

function Farm:OnDestroy()
	self.enabled = false
	DestroyRoutines(self)
end

function Farm:CalculateYield()
	local pollution = world_surface.get_pollution(self.entity.position) * self.pollution_multiplier
	self.air_purity = RemapNumber(pollution, 0, self.max_pollution, 1, 0)
	if self.air_purity < 0 then
		self.air_purity = 0
	end
	self.yield = math.max(self.soil_richness * self.air_purity, 0)
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
