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
	base_wheat_yield = 500,
	base_hops_yield = 400,
	base_veg_yield = 400,
	base_grapes_yield = 300
})

function Farm:Init()
	self.enabled = true
	local pos = self.entity.position
	local area = {{pos.x - self.radius, pos.y - self.radius}, {pos.x + self.radius, pos.y + self.radius}}
	local totalArea = 0
	local totalRichness = 0
	for x, y in iarea(area) do
		local tile = game.gettile(x, y)
		local richness = 0
		if soil_richness[tile.name] then
			richness = soil_richness[tile.name]
		end
		game.player.print(tile.name)
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
	local pollution = game.getpollution(self.entity.position) * self.pollution_multiplier
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
		local inventory = self.entity.getinventory(1)
		inventory.insert{name = "wheat", count = math.floor(self.base_wheat_yield * self.yield)}
		inventory.insert{name = "hops", count = math.floor(self.base_hops_yield * self.yield)}
		inventory.insert{name = "vegetables", count = math.floor(self.base_veg_yield * self.yield)}
		inventory.insert{name = "grapes", count = math.floor(self.base_grapes_yield * self.yield)}
		
		self:UpdateGUI()
	end
end

function Farm:OpenGUI()
	GUI.PushLeftSection()
	self.gui = GUI.PushParent(GUI.Frame("farm_gui", "Farm", GUI.VERTICAL))
	GUI.LabelData("richness", "Soil Richness:", "0%")
	GUI.LabelData("purity", "Air Purity:", "0%")
	GUI.LabelData("yield", "Yield:", "0%")
	GUI.PopAll()
	self:UpdateGUI()
end

function Farm:CloseGUI()
	if self.gui then
		self.gui.destroy()
		self.gui = nil
	end
end

function Farm:UpdateGUI()
	if self.gui and self.yield then
		local format = "%i%%"
		self.gui.richness.data.caption = string.format(format, math.floor(self.soil_richness * 100))
		self.gui.purity.data.caption = string.format(format, math.floor(self.air_purity * 100))
		self.gui.yield.data.caption = string.format(format, math.floor(self.yield * 100))
	end
end
