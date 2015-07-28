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
	local max_per_min = need.max_per_min * difficulty.need_max_per_min_modifier
	if need.consumption_duration == NEVER then
		return max_per_min
	else
		local upgradePop = needs_prototype[self.population_tier].upgrade_population
		return (max_per_min * (need.consumption_duration / MINUTES) * self.population) / upgradePop
	end
end

function Homeworld:UpdateNeedConsumption( need )
	if need.consumption_duration == NEVER then
		return
	end

	local timing = self.need_timing[need.item]

	if timing and timing.counter > 0 then
		-- Consume the item over time.
		timing.tickRate = math.floor(timing.tickRate)
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
			timing.tickRate = math.floor((1 / timing.consumptionPerTick) + 0.5)
			timing.consumptionPerTick = 1
		else
			timing.consumptionPerTick = math.floor(timing.consumptionPerTick)
		end
		timing.counter = math.floor(need.consumption_duration / timing.tickRate)
		self.need_timing[need.item] = timing
	end
end

function Homeworld:GetNeedSatisfaction( need )
	local totalNeeded = self:GetNeedItemCount(need)
	local itemCount = math.min(totalNeeded, self:GetItemCount(need.item))
	local satisfaction = itemCount / totalNeeded
	return satisfaction
end

function Homeworld:UpdatePopulation()
	local currentNeeds = self:CurrentNeeds()
	local currentTier = needs_prototype[self.population_tier]

	local satisfied_needs = 0
	local unsatisfied_needs = 0
	local total_satisfaction = 0

	for _, need in ipairs(currentNeeds) do
		local satisfaction = self:GetNeedSatisfaction(need)
		if satisfaction >= self.min_satisfaction_for_growth then
			satisfied_needs = satisfied_needs + 1
		elseif satisfaction <= self.max_satisfaction_for_decline then
			unsatisfied_needs = unsatisfied_needs + 1
		end
		total_satisfaction = total_satisfaction + satisfaction
	end

	-- Get the ranges of satisfaction for growth and decline.
	local max_grow_satisfaction = #currentNeeds
	local min_grow_satisfaction = #currentNeeds * self.min_satisfaction_for_growth
	local max_decline_satisfaction = #currentNeeds
	local min_decline_satisfaction = 0
	
	if satisfied_needs == #currentNeeds then
		-- Grow population.
		local growAmount = RemapNumber(total_satisfaction, 
									   min_grow_satisfaction, max_grow_satisfaction,
									   currentTier.grow_rate.min, currentTier.grow_rate.max)
		growAmount = math.floor(growAmount * difficulty.population_growth_modifier)
		self.population = self.population + growAmount

	elseif unsatisfied_needs > 0 then
		-- Decline population.
		local declineAmount = RemapNumber(total_satisfaction,
										  min_decline_satisfaction, max_decline_satisfaction,
										  currentTier.decline_rate.max, currentTier.decline_rate.min)
		declineAmount = math.floor(declineAmount * difficulty.population_decline_modifier)
		self.population = self.population - declineAmount
		if self.population < self.min_population then
			self.population = self.min_population
		end
	end

	-- Upgrade or downgrade tier.
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
		for _, reward in ipairs(rewards) do
			game.raise_event(HOMEWORLD_EVENTS.ON_REWARD, reward)
		end
		self.collected_reward_tiers[lastTier] = true
		PrintToAllPlayers({"homeworld-give-gifts"})
	end

	self.need_timing = {}

	for playerIndex = 1, #game.players do
		if self.gui[playerIndex] then
			self:CloseGUI(playerIndex)
			self:OpenGUI(playerIndex)
		end
	end
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

			if need.consumption_duration == NEVER then
				GUI.ProgressBar("satisfaction", 1, 0, "homeworld_need_all_progressbar_style")
			else
				GUI.ProgressBar("satisfaction", 1, 0, "homeworld_need_progressbar_style")
			end
			
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
		if needgui then
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
		game.raise_event(HOMEWORLD_EVENTS.HOMEWORLD_ONLINE, {})
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
