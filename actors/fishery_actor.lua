ActorClass("Fishery", {
	open_gui_on_selected = true,
	max_yield_per_minute = 360,
	max_pollution = 2000,
	max_fish = 13,
	max_fish_reproduction = 3,
	fish_reproduction_chance = 0.4,
	reproduction_interval = 40 * SECONDS,
	harvest_interval = 20 * SECONDS,
	fishing_radius = 12
})

function Fishery:Init()
	self.enabled = true
	self.gui = {}

	StartCoroutine(self.FisheryRoutine, self)
	StartCoroutine(self.ReproductionRoutine, self)
end

function Fishery:OnLoad()
	self:Init()
end

function Fishery:OnDestroy()
	self.enabled = false
	DestroyRoutines(self)
end

function Fishery:ReproductionRoutine()
	while self.enabled do
		WaitForTicks(self.reproduction_interval)

		local pos = self.entity.position
		local nearbyFish = world_surface.find_entities_filtered{
			area = {{pos.x - self.fishing_radius, pos.y - self.fishing_radius},
					{pos.x + self.fishing_radius, pos.y + self.fishing_radius}},
			name = "fish"
		}
		local fishCount = #nearbyFish

		local r = self.fishing_radius * 2
		local nearbyFishery = game.findentitiesfiltered{
			area = {{pos.x - r, pos.y - r},
					{pos.x + r, pos.y + r}},
			name = "fishery"
		}
		local fisheryCount = #nearbyFishery

		-- Reproduce fish
		local chance = self.fish_reproduction_chance * (1/fisheryCount)
		local reproduce = (math.random() <= chance)
		if reproduce and fishCount >= 1 and fishCount < self.max_fish then
			local reproduction_amount = math.floor(self.yield * self.max_fish_reproduction)
			if nearbyFish[1] and nearbyFish[1].valid then
				local spawnPos = nearbyFish[1].position
				for i = 0, reproduction_amount do
					world_surface.create_entity{name = "fish", force = game.forces.neutral, position = spawnPos}
				end
			end
		end

		-- cull overpopulation
		if #nearbyFish > self.max_fish then
			local overflow = fishCount - self.max_fish
			local cullAmount = math.random(0, overflow)
			if cullAmount > 0 then
				for i = self.max_fish, self.max_fish + cullAmount do
					if nearbyFish[i] and nearbyFish[i].valid then
						nearbyFish[i].die()
					end
				end
			end
		end
	end
end

function Fishery:FisheryRoutine()
	while self.enabled do
		local pollution = math.min(world_surface.get_pollution(self.entity.position), self.max_pollution)
		self.water_purity = RemapNumber(pollution, 0, self.max_pollution, 1, 0)

		local pos = self.entity.position
		local nearbyFish = world_surface.find_entities_filtered{
			area = {{pos.x - self.fishing_radius, pos.y - self.fishing_radius},
					{pos.x + self.fishing_radius, pos.y + self.fishing_radius}},
			name = "fish"
		}

		local fishCount = math.min(#nearbyFish, self.max_fish)
		self.fish_population = RemapNumber(fishCount, 0, self.max_fish, 0, 1)
		self.yield = self.fish_population * self.water_purity
		self:UpdateGUIForAllPlayers()

		-- Wait to harvest
		WaitForTicks(self.harvest_interval)

		-- Harvest fish
		local inventory = self.entity.get_inventory(1)
		local maxYield = (self.max_yield_per_minute * self.harvest_interval) / (1*MINUTES);
		local count = math.floor(self.yield * maxYield)
		if count > 0 then
			local stack = {name = "raw-fish", count = count}
			if inventory.can_insert(stack) then
				inventory.insert(stack)
			end

			for i = 0, fishCount do
				if nearbyFish[i] and nearbyFish[i].valid then
					nearbyFish[i].damage(1, game.forces.player)
				end
			end
		end
	end
end

function Fishery:OpenGUI( playerIndex )
	GUI.PushParent(game.players[playerIndex].gui.left)
	self.gui[playerIndex] = GUI.PushParent(GUI.Frame("fishery", "Fishery", GUI.VERTICAL))
	GUI.LabelData("purity", "Water Purity:", "0%")
	GUI.LabelData("population", "Fish Population:", "0%")
	GUI.LabelData("yield", "Yield:", "0%")
	self:UpdateGUI(playerIndex)
end

function Fishery:CloseGUI( playerIndex )
	if self.gui[playerIndex] then
		self.gui[playerIndex].destroy()
		self.gui[playerIndex] = nil
	end
end

function Fishery:UpdateGUIForAllPlayers()
	for playerIndex = 1, #game.players do
		self:_UpdateGUI(playerIndex)
	end
end

function Fishery:UpdateGUI( playerIndex )
	if not self.gui[playerIndex] or not self.yield then return end

	-- calculate rolling average of fish_population
	if not self.fish_roll_avg then
		self.fish_roll_avg = {}
	end
	local fishPop = math.floor(self.fish_population * 100)
	table.insert(self.fish_roll_avg, fishPop)
	if #self.fish_roll_avg > 10 then
		table.remove(self.fish_roll_avg, 1)
	end
	local fishPopSum = 0
	for i = 1, #self.fish_roll_avg do
		fishPopSum = fishPopSum + self.fish_roll_avg[i]
	end
	local fishPopAvg = math.floor(fishPopSum / #self.fish_roll_avg)

	local format = "%i%%"
	self.gui.purity.data.caption = string.format(format, math.floor(self.water_purity * 100))
	self.gui.population.data.caption = string.format(format, fishPopAvg)
	self.gui.yield.data.caption = string.format(format, math.floor(self.yield * 100))
end