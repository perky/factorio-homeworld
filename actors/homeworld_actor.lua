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
		grow_rate = { min = 6, max = 9 },
		decline_rate = { min = 4, max = 8 },
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
		},
		rewards = {
			{
				{item = "basic-bullet-magazine", amount = 300},
				{item = "basic-armor", amount = 3}
			},
			{
				{item = "heavy-armor", amount = 4},
				{item = "basic-grenade", amount = 16}
			},
			{
				{item = "poison-capsule", amount = 2},
				{item = "piercing-bullet-magazine", amount = 200}
			},
			{
				{item = "shotgun-shell", amount = 600}
			},
			{
				{item = "speed-module", amount = 3}
			},
			{
				{item = "effectivity-module", amount = 3}
			},
			{
				{item = "productivity-module", amount = 3}
			},
		}
	},

	{
		name = "Tier 2", 
		upgrade_population = 10000,
		downgrade_population = 3000,
		grow_rate = { min = 10, max = 15 },
		decline_rate = { min = 5, max = 17 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 1600,
				consumption_duration = VERY_FAST
			},
			{
				item = "bread",
				max_per_min = 1600,
				consumption_duration = FAST
			},
			{
				item = "furniture",
				max_per_min = 300,
				consumption_duration = SLOW
			}
		},
		rewards = {
			{
				{item = "flame-thrower-ammo", amount = 500},
				{item = "heavy-armor", amount = 10}
			},
			{
				{item = "rocket", amount = 10},
				{item = "basic-grenade", amount = 80}
			},
			{
				{item = "piercing-shotgun-shell", amount = 200},
				{item = "piercing-bullet-magazine", amount = 400}
			},
			{
				{item = "speed-module-2", amount = 5},
				{item = "effectivity-module", amount = 10},
			},
			{
				{item = "effectivity-module-2", amount = 5},
				{item = "productivity-module", amount = 10},
			},
			{
				{item = "productivity-module-2", amount = 5},
				{item = "speed-module", amount = 10},
			},
		}
	},

	{
		name = "Tier 3",
		upgrade_population = 25000,
		downgrade_population = 8000,
		grow_rate = { min = 10, max = 19 },
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
				max_per_min = 500,
				consumption_duration = NORMAL
			},
			{
				item = "beer",
				max_per_min = 250,
				consumption_duration = FAST
			},
			{
				item = "furniture",
				max_per_min = 500,
				consumption_duration = SLOW
			}
		},
		rewards = {
			{
				{item = "laser-turret", amount = 100}
			},
			{
				{item = "express-transport-belt", amount = 500},
				{item = "basic-grenade", amount = 50}
			},
			{
				{item = "piercing-shotgun-shell", amount = 800},
				{item = "solar-panel", amount = 200}
			},
			{
				{item = "speed-module-3", amount = 10},
				{item = "effectivity-module-2", amount = 20},
			},
			{
				{item = "effectivity-module-3", amount = 10},
				{item = "productivity-module-2", amount = 20},
			},
			{
				{item = "productivity-module-3", amount = 10},
				{item = "speed-module-2", amount = 20},
			},
		}
	},

	{
		name = "Tier 4",
		upgrade_population = 50000,
		downgrade_population = 18000,
		grow_rate = { min = 20, max = 35 },
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
				max_per_min = 450,
				consumption_duration = FAST
			},
			{
				item = "building-materials",
				max_per_min = 700,
				consumption_duration = VERY_SLOW
			},
			{
				item = "battery",
				max_per_min = 50,
				consumption_duration = VERY_SLOW
			}
		},
		rewards = {
			{
				{item = "straight-rail", amount = 500},
				{item = "curved-rail", amount = 250},
				{item = "speed-module-3", amount = 1},
			},
			{
				{item = "express-transport-belt", amount = 500},
				{item = "tank", amount = 1},
				{item = "speed-module-3", amount = 3},
			},
			{
				{item = "alien-science-pack", amount = 100},
				{item = "logistic-robot", amount = 300},
				{item = "construction-robot", amount = 300},
			}
		}
	},

	{
		name = "Tier 5",
		upgrade_population = 100000,
		downgrade_population = 40000,
		grow_rate = { min = 30, max = 75 },
		decline_rate = { min = 20, max = 85 },
		needs = {
			{
				item = "luxury-meal",
				max_per_min = 4000,
				consumption_duration = FAST
			},
			{
				item = "wine",
				max_per_min = 820,
				consumption_duration = SLOW
			},
			{
				item = "beer",
				max_per_min = 550,
				consumption_duration = NORMAL
			},
			{
				item = "portable-electronics",
				max_per_min = 20,
				consumption_duration = SUPER_SLOW
			},
			{
				item = "building-materials",
				max_per_min = 1200,
				consumption_duration = VERY_SLOW
			},
			{
				item = "rockets",
				max_per_min = 50,
				consumption_duration = SUPER_SLOW
			}
		},
		rewards = {
			{
				{item = "straight-rail", amount = 250},
			},
			{
				{item = "tank", amount = 2},
				{item = "logistic-robot", amount = 500},
				{item = "construction-robot", amount = 500},
			},
			{
				{item = "alien-science-pack", amount = 200},
				{item = "science-pack-3", amount = 500},
				{item = "science-pack-2", amount = 400},
				{item = "science-pack-1", amount = 300},
			}
		}
	},
}

ActorClass("Homeworld", {
	population = 100,
	max_population = 10000,
	min_population = 10,
	population_tier = 0,
	min_satisfaction_for_growth = 0.4,
	max_satisfaction_for_decline = 0.15,
	max_growth_rate = 35,
	max_decline_rate = 15,
	update_population_rate = 15 * SECONDS
})

function Homeworld:Init()
	self.enabled = true
	self.inventory = {}
	self.radars = {}
	self.collected_reward_tiers = {}
	self.gui = {}
	self.top_button = {}
	self.need_timing = {}

	SetGoalForAllPlayers({"homeworld-first-goal"})
end

function Homeworld:OnLoad()
	self.enabled = true
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
end

function Homeworld:OnTick()
	for playerIndex = 1, #game.players do
		if self.gui[playerIndex] then
			self:UpdateGUI(playerIndex)
		end
	end

	if game.tick % (1*SECONDS) == 0 then
		self:CheckRadars()
	end

	if self.connected_by_radar then
		if (game.tick % self.update_population_rate) == 0 then
			self:UpdatePopulation()
		end

		local needs = self:CurrentNeeds()
		for i, need in ipairs(needs) do
			self:UpdateNeedConsumption(need)
		end
	end
end

function Homeworld:GetNeedItemCount( need )
	local upgradePop = needs_prototype[self.population_tier].upgrade_population
	return (need.max_per_min * (need.consumption_duration / MINUTES) * self.population) / upgradePop
end

function Homeworld:UpdateNeedConsumption( need )
	local timing = self.need_timing[need.item]

	if timing and timing.counter > 0 then
		-- Consume the item over time.
		if (game.tick % timing.tickRate) == 0 then
			self:RemoveItem(need.item, timing.consumptionPerTick)
			timing.counter = timing.counter - 1
			if self:GetItemCount(need.item) == 0 then
				timing.counter = 0
			end
		end
	else
		-- Otherwise we need to calculate the timing data.
		timing = {}
		local totalNeeded = self:GetNeedItemCount(need)
		timing.consumptionPerTick = totalNeeded / need.consumption_duration
		timing.tickRate = 1
		if timing.consumptionPerTick < 1 then
			timing.tickRate = 1 / timing.consumptionPerTick
			timing.consumptionPerTick = 1
		else
			timing.consumptionPerTick = math.floor(timing.consumptionPerTick)
		end
		timing.counter = math.floor(need.consumption_duration / timing.tickRate)
		self.need_timing[need.item] = timing
	end
end

function Homeworld:UpdatePopulation()
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
		self.population = self.population + growAmount
	elseif canDecline then
		local declineAmount = math.random(tier.decline_rate.min, tier.decline_rate.max)
		self.population = self.population - declineAmount
		if self.population < self.min_population then
			self.population = self.min_population
		end
	end

	local currentTier = needs_prototype[self.population_tier]
	local nextTier = needs_prototype[self.population_tier + 1]
	if nextTier and self.population >= currentTier.upgrade_population then
		self:SetTier(self.population_tier + 1)
		PrintToAllPlayers(string.format("Homeworld population upgraded to tier %i. Needs changed.", self.population_tier))
	elseif self.population < currentTier.downgrade_population then
		self:SetTier(self.population_tier - 1)
		PrintToAllPlayers(string.format("Homeworld population downgraded to tier %i. Needs changed.", self.population_tier))
	end
end

function Homeworld:SetTier( tier )

	if not self.collected_reward_tiers then
		self.collected_reward_tiers = {}
	end

	local shouldGiveRewards = (tier > self.population_tier) and (not self.collected_reward_tiers[self.population_tier])
	local lastTier = self.population_tier
	self.population_tier = tier

	if shouldGiveRewards and needs_prototype[lastTier] then
		local possibleRewards = needs_prototype[lastTier].rewards
		local chosenRewards = math.random(#possibleRewards)
		local rewards = possibleRewards[chosenRewards]
		PrintToAllPlayers(serpent.block(rewards))
		for _, reward in ipairs(rewards) do
			game.raise_event(HOMEWORLD_EVENTS.ON_REWARD, reward)
		end
		self.collected_reward_tiers[lastTier] = true
		PrintToAllPlayers({"homeworld-give-gifts"})
	end

	self.need_timing = {}
	self:CreateNeedsGUI()
end

function Homeworld:CurrentNeeds()
	return needs_prototype[self.population_tier].needs
end

function Homeworld:ToggleGUI( playerIndex )
	if self.gui[playerIndex] then
		self:CloseGUI(playerIndex)
	else
		self:OpenGUI(playerIndex)
	end
end

function Homeworld:OpenGUI( playerIndex )
	local player = game.players[playerIndex]
	if self.connected_by_radar then
		GUI.PushParent(player.gui.left)
		self.gui[playerIndex] = GUI.Frame("homeworld_gui", "Homeworld", GUI.VERTICAL)
		GUI.PushParent(self.gui[playerIndex])
		GUI.PushParent(GUI.Flow("population", GUI.HORIZONTAL))
			GUI.Label("pop_label", {"population"})
			GUI.Label("pop_value", "0/0")
		GUI.PopParent()
		GUI.ProgressBar("population_bar", 1)
		GUI.PopAll()
		self:CreateNeedsGUI(playerIndex)
	else
		GUI.PushParent(player.gui.left)
		self.gui[playerIndex] = GUI.Frame("homeworld_gui", "Homeworld", GUI.VERTICAL)
		GUI.PushParent(self.gui[playerIndex])
		GUI.Label("info", {"homeworld-start-transmission"})
		GUI.PopAll()
	end
end

function Homeworld:CreateNeedsGUI( playerIndex )
	if not self.gui[playerIndex] then return end
	if self.gui[playerIndex].needs then
		self.gui[playerIndex].needs.destroy()
	end
	GUI.PopAll()
	GUI.PushParent(self.gui[playerIndex])
	GUI.PushParent(GUI.Frame("needs", "Needs", GUI.VERTICAL))
	for i, need in ipairs(self:CurrentNeeds()) do
		GUI.PushParent(GUI.Flow("need_"..i, GUI.VERTICAL))
			GUI.PushParent(GUI.Flow("label_icon", GUI.HORIZONTAL))
				GUI.Icon("icon", need.item)
				GUI.PushParent(GUI.Flow("labels", GUI.VERTICAL))
					GUI.Label("item", game.get_localised_item_name(need.item))
					GUI.Label("consumption", "")
				GUI.PopParent()
			GUI.PopParent()
			GUI.ProgressBar("satisfaction", 1, 0, "homeworld_need_progressbar_style")
		GUI.PopParent()
	end
end

function Homeworld:UpdateGUI( playerIndex )
	local player = game.players[playerIndex]
	if self.connected_by_radar and self.top_button then
		self.top_button.caption = string.format("Homeworld [%s T%u]", PrettyNumber(self.population), self.population_tier)
	end

	if not self.gui[playerIndex] then
		return
	end

	local maxPop = needs_prototype[self.population_tier].upgrade_population
	local minPop = needs_prototype[self.population_tier].downgrade_population
	local barValue = (self.population - minPop) / (maxPop - minPop)
	self.gui[playerIndex].population.pop_value.caption = string.format("%u / %u - T%u", self.population, maxPop, self.population_tier)
	self.gui[playerIndex].population_bar.value = barValue
	for i, need in ipairs(self:CurrentNeeds()) do
		local needgui = self.gui[playerIndex].needs["need_"..i]
		local amountNeeded = math.floor(self:GetNeedItemCount(need))
		local amountInStock = self:GetItemCount(need.item)
		needgui.satisfaction.value = amountInStock / amountNeeded
		local labels = needgui.label_icon.labels
		GUI.SetLabelCaptionLocalised(labels.item, 
									 game.get_localised_item_name(need.item), 
									 string.format(" [%s/%s]", PrettyNumber(amountInStock), PrettyNumber(amountNeeded))
		)
		labels.consumption.caption = durationLocaleKey[need.consumption_duration]
	end
end

function Homeworld:CloseGUI( playerIndex )
	if self.gui[playerIndex] then
		self.gui[playerIndex].destroy()
		self.gui[playerIndex] = nil
	end
end

function Homeworld:CreateTopButton()
	for playerIndex = 1, #game.players do
		local player = game.players[playerIndex]
		GUI.PushParent(player.gui.top)
		self.top_button[playerIndex] = GUI.Button("homeworld_button", "Homeworld", "ToggleGUI", self)
		GUI.PopParent()
	end
end

function Homeworld:DestroyTopButton()
	for playerIndex = 1, #game.players do
		self.top_button[playerIndex].destroy()
		self.top_button[playerIndex] = nil
	end
end

function Homeworld:OnConnectedToRadar()
	PrintToAllPlayers({"homeworld-start-transmission"})
	PrintToAllPlayers({"homeworld-get-response"})
	SetGoalForAllPlayers("")

	if self.population_tier == 0 then
		self:SetTier(1)
		remote.call("homeworld", "SetHomeworldOnline")
	end

	self:CreateTopButton()
end

function Homeworld:OnDisconnectedFromRadar()
	PrintToAllPlayers({"homeworld-lose-transmission"})
	self:DestroyTopButton()
end

function Homeworld:CheckRadars()
	local poweredRadarDoesExist = false
	for i, radar in ipairs(self.radars) do
		if radar and radar.valid and radar.energy > 1 then
			poweredRadarDoesExist = true
			break
		end
	end

	if poweredRadarDoesExist then
		if not self.connected_by_radar then
			self:OnConnectedToRadar()
		end
		self.connected_by_radar = true
	elseif self.connected_by_radar then
		self:OnDisconnectedFromRadar()
		self.connected_by_radar = false
	end
end

function Homeworld:OnRadarBuilt( radarEntity )
	table.insert(self.radars, radarEntity)
end

function Homeworld:OnRadarDestroy( radarEntity )
	for i, otherRadarEntity in ipairs(self.radars) do
		if otherRadarEntity == radarEntity then
			table.remove(self.radars, i)
			break
		end
	end
end
