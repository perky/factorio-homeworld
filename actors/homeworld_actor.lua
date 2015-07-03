--[[
	NOTE(luke): 
	Each need has a 'max_per_min' value. This indicates the maximum production per minute of an item a player
	needs to reach to upgrade that tier. The consumption_duration indicates how long it takes to consume the need.
	The higher the duration the more items needed per capita.
	For example: 
		if in tier 1 the max_per_min for fish is 1000 and the consumption duration is 10 minutes.
		The total amount per capita would be `(max_per_min * (consumption_duration / MINUTES)) / upgrade_population`.
		In this case 0.8 per capita.
]]

local SUPER_FAST= 3 * MINUTES
local VERY_FAST = 5 * MINUTES
local FAST 		= 10 * MINUTES
local NORMAL	= 15 * MINUTES
local SLOW 		= 20 * MINUTES
local VERY_SLOW = 30 * MINUTES
local SUPER_SLOW = 60 * MINUTES
local durationLocaleKey = {
	[SUPER_FAST] = {"duration-super-fast"},
	[VERY_FAST] = {"duration-very-fast"},
	[FAST] = {"duration-fast"},
	[NORMAL] = {"duration-normal"},
	[SLOW] = {"duration-slow"},
	[VERY_SLOW] = {"duration-very-slow"},
	[SUPER_SLOW] = {"duration-super-slow"}
}

needs_prototype = {
	{
		name = "Tier 1", 
		upgrade_population = 5000,
		downgrade_population = -1,
		grow_rate = { min = 2, max = 12 },
		decline_rate = { min = 1, max = 12 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 800,
				consumption_duration = SUPER_FAST
			},
			{
				item = "raw-wood",
				max_per_min = 100,
				consumption_duration = FAST
			}
		}
	},

	{
		name = "Tier 2", 
		upgrade_population = 10000,
		downgrade_population = 3000,
		grow_rate = { min = 3, max = 15 },
		decline_rate = { min = 2, max = 17 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 1600,
				consumption_duration = VERY_FAST
			},
			{
				item = "bread",
				max_per_min = 1000,
				consumption_duration = FAST
			},
			{
				item = "furniture",
				max_per_min = 300,
				consumption_duration = SLOW
			}
		}
	},

	{
		name = "Tier 3",
		upgrade_population = 25000,
		downgrade_population = 8000,
		grow_rate = { min = 5, max = 19 },
		decline_rate = { min = 5, max = 20 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 2000,
				consumption_duration = VERY_FAST
			},
			{
				item = "bread",
				max_per_min = 3000,
				consumption_duration = FAST
			},
			{
				item = "water-barrel",
				max_per_min = 700,
				consumption_duration = NORMAL
			},
			{
				item = "beer",
				max_per_min = 500,
				consumption_duration = FAST
			},
			{
				item = "furniture",
				max_per_min = 500,
				consumption_duration = SLOW
			}
		}
	},

	{
		name = "Tier 4",
		upgrade_population = 50000,
		downgrade_population = 18000,
		grow_rate = { min = 10, max = 35 },
		decline_rate = { min = 10, max = 40 },
		needs = {
			{
				item = "luxury-meal",
				max_per_min = 1000,
				consumption_duration = NORMAL
			},
			{
				item = "water-barrel",
				max_per_min = 1400,
				consumption_duration = NORMAL
			},
			{
				item = "beer",
				max_per_min = 700,
				consumption_duration = FAST
			},
			{
				item = "building-materials",
				max_per_min = 800,
				consumption_duration = VERY_SLOW
			},
			{
				item = "battery",
				max_per_min = 200,
				consumption_duration = VERY_SLOW
			}
		}
	},

	{
		name = "Tier 5",
		upgrade_population = 100000,
		downgrade_population = 40000,
		grow_rate = { min = 20, max = 75 },
		decline_rate = { min = 20, max = 85 },
		needs = {
			{
				item = "luxury-meal",
				max_per_min = 2000,
				consumption_duration = FAST
			},
			{
				item = "wine",
				max_per_min = 1000,
				consumption_duration = SLOW
			},
			{
				item = "beer",
				max_per_min = 1700,
				consumption_duration = NORMAL
			},
			{
				item = "portable-electronics",
				max_per_min = 2000,
				consumption_duration = SUPER_SLOW
			},
			{
				item = "building-materials",
				max_per_min = 1200,
				consumption_duration = VERY_SLOW
			},
			{
				item = "rockets",
				max_per_min = 200,
				consumption_duration = SUPER_SLOW
			}
		}
	},
}

ActorClass("Homeworld", {
	population = 100,
	max_population = 10000,
	min_population = 10,
	population_tier = 1,
	min_satisfaction_for_growth = 0.4,
	max_satisfaction_for_decline = 0.15,
	max_growth_rate = 35,
	max_decline_rate = 15,
	update_population_rate = 15 * SECONDS,
	grace_period = 5 * MINUTES
})

function Homeworld:Init()
	self.enabled = true
	self.inventory = {}
	self.radars = {}

	game.player.setgoaldescription(game.localise("homeworld-first-goal"))
end

function Homeworld:OnLoad()
	self.enabled = true
	if not self.online and not self.connected_by_radar then
		game.player.setgoaldescription(game.localise("homeworld-first-goal"))
	end

	if self.online then
		for _, need in ipairs(self:CurrentNeeds()) do
			StartCoroutine(function() self:ConsumeNeed(need, self.population_tier) end)
		end
		StartCoroutine(self.UpdatePopulation, self)
	elseif self.grace_period_started then
		self.grace_period = 5*SECONDS
		StartCoroutine(self.GracePeriodRoutine, self)
	end

	StartCoroutine(self.CheckRadarsRoutine, self)
	self.radarRoutineStarted = true
end

function Homeworld:GracePeriodRoutine()
	self.grace_period_started = true

	-- Wait until grace period has finished.
	while self.grace_period > 0 do
		self.grace_period = self.grace_period - 1
		coroutine.yield()
	end

	-- Wait until we are connected by radar.
	while not self.connected_by_radar do
		coroutine.yield()
	end

	-- After grace period, start need and population routines.
	self.online = true
	self:SetTier(1)
	StartCoroutine(self.UpdatePopulation, self)
	QueueEvent(HOMEWORLD_EVENTS.HOMEWORLD_ONLINE, {homeworld = self})

	-- Print feedback to player
	game.player.print(game.localise("homeworld-get-response"))
	-- Reset the gui.
	if self.gui then
		self:CloseGUI()
		self:OpenGUI()
	end
end


function Homeworld:InsertItem(itemName, count)
	if not self.inventory[itemName] then
		self.inventory[itemName] = count
	else
		self.inventory[itemName] = self.inventory[itemName] + count
	end
end

function Homeworld:GetItemCount(itemName)
	if self.inventory[itemName] then
		return self.inventory[itemName]
	else
		return 0
	end
end

function Homeworld:RemoveItem(itemName, count)
	count = math.min(self:GetItemCount(itemName), count)
	if count > 0 then
		self.inventory[itemName] = self.inventory[itemName] - count
	end
	return count
end

function Homeworld:OnDestroy()
	-- body
end

function Homeworld:OnTick()
	if self.online then
		self:UpdateGUI()
	end
end

function Homeworld:GetNeedItemCount( need )
	local upgradePop = needs_prototype[self.population_tier].upgrade_population
	return (need.max_per_min * (need.consumption_duration / MINUTES) * self.population) / upgradePop
end

function Homeworld:ConsumeNeed( need, tier )
	while self.enabled and tier == self.population_tier do
		-- Wait until we have items to consume.
		while self:GetItemCount(need.item) == 0 do
			WaitForTicks(60)
		end

		local totalNeeded = self:GetNeedItemCount(need)
		local consumptionPerTick = totalNeeded / need.consumption_duration
		local tickRate = 1

		if consumptionPerTick < 1 then
			tickRate = 1 / consumptionPerTick
			consumptionPerTick = 1
		else
			consumptionPerTick = math.floor(consumptionPerTick)
		end
		
		for i = 0, need.consumption_duration/tickRate do
			self:RemoveItem(need.item, consumptionPerTick)
			if self:GetItemCount(need.item) == 0 or self.population_tier ~= tier then
				break
			end
			WaitForTicks(tickRate)
		end
	end
end

function Homeworld:UpdatePopulation()
	while self.enabled do
		WaitForTicks(self.update_population_rate)
		local canGrow = false
		local canDecline = false
		local needsSatisfied = 0
		local needsUnsatisfied = 0
		local needCount = 0
		for _, need in ipairs(self:CurrentNeeds()) do
			local totalNeeded = self:GetNeedItemCount(need)
			local satisfaction = self:GetItemCount(need.item) / totalNeeded
			if satisfaction >= self.min_satisfaction_for_growth then
				needsSatisfied = needsSatisfied + 1
			elseif satisfaction <= self.max_satisfaction_for_decline then
				needsUnsatisfied = needsUnsatisfied + 1
			end
			needCount = needCount + 1
		end

		local tier = needs_prototype[self.population_tier]
		local canGrow = (needsSatisfied == needCount)
		local canDecline = (needsUnsatisfied > 0)

		if canGrow then
			local growAmount = math.random(tier.grow_rate.min, tier.grow_rate.max)
			for i = 0, growAmount do
				self.population = self.population + 1
				WaitForTicks(5)
			end
		elseif canDecline then
			local declineAmount = math.random(tier.decline_rate.min, tier.decline_rate.max)
			for i = 0, declineAmount do
				self.population = self.population - 1
				if self.population < self.min_population then
					self.population = self.min_population
				end
				WaitForTicks(5)
			end
		end

		local currentTier = needs_prototype[self.population_tier]
		local nextTier = needs_prototype[self.population_tier + 1]
		if nextTier and self.population >= currentTier.upgrade_population then
			self:SetTier(self.population_tier + 1)
			game.player.print(string.format("Homeworld population upgraded to tier %i. Needs changed.", self.population_tier))
			WaitForTicks(2 * SECONDS) -- wait before changing population to prevent flipping between tiers.
		elseif self.population < currentTier.downgrade_population then
			self:SetTier(self.population_tier - 1)
			game.player.print(string.format("Homeworld population downgraded to tier %i. Needs changed.", self.population_tier))
			WaitForTicks(2 * SECONDS) -- wait before changing population to prevent flipping between tiers.
		end
	end
end

function Homeworld:SetTier( tier )
	self.population_tier = tier
	for _, need in ipairs(self:CurrentNeeds()) do
		StartCoroutine(function() self:ConsumeNeed(need, tier) end)
	end
	self:CreateNeedsGUI()
end

function Homeworld:CurrentNeeds()
	return needs_prototype[self.population_tier].needs
end

function Homeworld:ToggleGUI()
	if self.gui then
		self:CloseGUI()
	else
		self:OpenGUI()
	end
end

function Homeworld:OpenGUI()
	if self.online then
		GUI.PushParent(game.player.gui.left)
		self.gui = GUI.Frame("homeworld_gui", "Homeworld", GUI.VERTICAL)
		GUI.PushParent(self.gui)
		GUI.PushParent(GUI.Flow("population", GUI.HORIZONTAL))
			GUI.Label("pop_label", {"population"})
			GUI.Label("pop_value", "0/0")
		GUI.PopParent()
		GUI.ProgressBar("population_bar", 1)
		GUI.PopAll()
		self:CreateNeedsGUI()
	else
		GUI.PushParent(game.player.gui.left)
		self.gui = GUI.Frame("homeworld_gui", "Homeworld", GUI.VERTICAL)
		GUI.PushParent(self.gui)
		GUI.Label("info", {"homeworld-start-transmission"})
		GUI.PopAll()
	end
end

function Homeworld:CreateNeedsGUI()
	if not self.gui then return end
	if self.gui.needs then
		self.gui.needs.destroy()
	end
	GUI.PopAll()
	GUI.PushParent(self.gui)
	GUI.PushParent(GUI.Frame("needs", "Needs", GUI.VERTICAL))
	for i, need in ipairs(self:CurrentNeeds()) do
		GUI.PushParent(GUI.Flow("need_"..i, GUI.VERTICAL))
			GUI.PushParent(GUI.Flow("label_icon", GUI.HORIZONTAL))
				GUI.Icon("icon", need.item)
				GUI.PushParent(GUI.Flow("labels", GUI.VERTICAL))
					GUI.Label("item", game.getlocaliseditemname(need.item))
					GUI.Label("consumption", "")
				GUI.PopParent()
			GUI.PopParent()
			GUI.ProgressBar("satisfaction", 1, 0, "homeworld_need_progressbar_style")
		GUI.PopParent()
	end
end

function Homeworld:UpdateGUI()
	if self.online and self.top_button then
		self.top_button.caption = string.format("Homeworld [%s T%u]", PrettyNumber(self.population), self.population_tier)
	end
	if not self.gui or not self.online then return end

	local maxPop = needs_prototype[self.population_tier].upgrade_population
	local minPop = needs_prototype[self.population_tier].downgrade_population
	local barValue = (self.population - minPop) / (maxPop - minPop)
	self.gui.population.pop_value.caption = string.format("%u / %u - T%u", self.population, maxPop, self.population_tier)
	self.gui.population_bar.value = barValue
	for i, need in ipairs(self:CurrentNeeds()) do
		local needgui = self.gui.needs["need_"..i]
		local amountNeeded = math.floor(self:GetNeedItemCount(need))
		local amountInStock = self:GetItemCount(need.item)
		needgui.satisfaction.value = amountInStock / amountNeeded
		local labels = needgui.label_icon.labels
		GUI.SetLabelCaptionLocalised(labels.item, 
									 game.getlocaliseditemname(need.item), 
									 string.format(" [%s/%s]", PrettyNumber(amountInStock), PrettyNumber(amountNeeded))
		)
		labels.consumption.caption = durationLocaleKey[need.consumption_duration]
	end
end

function Homeworld:CloseGUI()
	self.gui.destroy()
	self.gui = nil
end

function Homeworld:CreateTopButtonGUI()
	if not self.top_button then
		GUI.PushParent(game.player.gui.top)
		self.top_button = GUI.Button("homeworld_button", "Homeworld", "ToggleGUI", self)
		GUI.PopParent()
	end
end

function Homeworld:CheckRadarsRoutine()
	while self.enabled do
		WaitForTicks(5*SECONDS)
		local poweredRadarDoesExist = false
		for i, radar in ipairs(self.radars) do
			if radar and radar.valid and radar.energy > 1 then
				poweredRadarDoesExist = true
				break
			end
		end
		if poweredRadarDoesExist and not self.connected_by_radar then
			self:CreateTopButtonGUI()
			self.connected_by_radar = true
			game.player.print(game.localise("homeworld-start-transmission"))
			game.player.setgoaldescription("")
			if self.online then
				game.player.print(game.localise("homeworld-get-response"))
			elseif not self.grace_period_started then
				StartCoroutine(self.GracePeriodRoutine, self)
			end
		elseif not poweredRadarDoesExist and self.connected_by_radar then
			self.connected_by_radar = false
			GUI.DestroyButton(self.top_button)
			self.top_button = nil
			if self.gui then
				self.gui.destroy()
				self.gui = nil
			end
			if self.online then
				game.player.print(game.localise("homeworld-lose-transmission"))
			end
		end
	end
end

function Homeworld:OnRadarBuilt( radarEntity )
	table.insert(self.radars, radarEntity)
	if #self.radars == 1 and not self.radarRoutineStarted then
		StartCoroutine(self.CheckRadarsRoutine, self)
		self.radarRoutineStarted = true
	end
end

function Homeworld:OnRadarDestroy( radarEntity )
	for i, otherRadarEntity in ipairs(self.radars) do
		if otherRadarEntity.equals(radarEntity) then
			table.remove(self.radars, i)
			break
		end
	end
end
