ActorClass("Portal", {
	open_gui_on_selected = true,
	homeworld = nil,
	transfer_interval = 1 * MINUTES,
	countdown_tick = 0
})

function Portal:Init()
	self.enabled = true
	self.stats = {}
	self.gui = {}

	game.on_event(HOMEWORLD_EVENTS.HOMEWORLD_ONLINE, function()
		self:OnHomeworldOnline()
	end)

	if self.homeworld and self.homeworld.connected_by_radar then
		self.homeworld_is_online = true
	end
end

function Portal:OnLoad()
	self.enabled = true
	game.on_event(HOMEWORLD_EVENTS.HOMEWORLD_ONLINE, function()
		self:OnHomeworldOnline()
	end)
	if self.can_receive_rewards then
		self:RegisterForRewards()
	end
end

function Portal:RegisterForRewards()
	game.on_event(HOMEWORLD_EVENTS.ON_REWARD, function(reward)
		self:InsertReward(reward)
	end)
	self.can_receive_rewards = true
end

function Portal:OnDestroy()
	self.enabled = false
	DestroyRoutines(self)
end

function Portal:OnHomeworldOnline()
	self.homeworld_is_online = true
end

function Portal:OnTick()
	for playerIndex = 1, #game.players do
		if self.gui[playerIndex] then
			self:UpdateGUI(playerIndex)
		end
	end

	-- Wait until homeworld is online.
	if not self.homeworld_is_online then
		return
	end

	-- Wait until the countdown reaches 0.
	if self.countdown_tick > 0 then
		self.countdown_tick = self.countdown_tick - 1
		return
	end
	self.countdown_tick = self.transfer_interval

	local inventory = self.entity.get_inventory(1)
	local needs = self.homeworld:CurrentNeeds()
	for _, need in ipairs(needs) do
		local count = inventory.get_item_count(need.item)
		if count > 0 then
			inventory.remove({name = need.item, count = count})
			self.homeworld:InsertItem(need.item, count)
		end

		-- Update stats
		local stat = self.stats[need.item]
		if not stat then
			stat = {}
			self.stats[need.item] = stat
		end
		table.insert(stat, count)
		if #stat > 60 then
			table.remove(stat, 1)
		end
	end

	-- Create portal FX.
	self.entity.surface.create_entity({name = "portal-sound", position = self.entity.position, force = self.entity.force, target = self.entity})
end

function Portal:InsertReward( reward )
	local inventory = self.entity.get_inventory(1)
	local itemStack = {name = reward.item, count = reward.amount}
	if inventory.can_insert(itemStack) then
		inventory.insert(itemStack)
	end
end

function Portal:OpenGUI( playerIndex )
	local player = game.players[playerIndex]
	if player.gui.left.portal_gui then
		player.gui.left.portal_gui.destroy()
	end

	GUI.PushParent(player.gui.left)
	self.gui[playerIndex] = GUI.Frame("portal_gui", "Homeworld Portal", GUI.VERTICAL)
	GUI.PushParent(self.gui[playerIndex])
	GUI.LabelData("portal_timer", {"portal-timer-label"})
	GUI.PopAll()
end

function Portal:CloseGUI( playerIndex )
	if self.gui[playerIndex] then
		self.gui[playerIndex].destroy()
		self.gui[playerIndex] = nil
	end
end

function Portal:UpdateGUI( playerIndex )
	if self.homeworld_is_online then
		if self.countdown_tick >= 0 then
			local minutes = math.floor(self.countdown_tick / 3600)
			local seconds = math.floor((self.countdown_tick / 60) % 60)
			self.gui[playerIndex].portal_timer.data.caption = string.format("%02i:%02i", minutes, seconds)
		end

		if self.stats then
			if self.gui[playerIndex].stats then
				self.gui[playerIndex].stats.destroy()
			end
			GUI.PushParent(self.gui[playerIndex])
			GUI.PushParent(GUI.Frame("stats", "Stats", GUI.VERTICAL))
				for item, stat in pairs(self.stats) do
					GUI.PushParent(GUI.Flow("stat_"..item, GUI.HORIZONTAL))
					GUI.Icon("item_icon", item)
					GUI.Label("item_name", game.get_localised_item_name(item))
					local avg = self:GetStatAvg(item)
					GUI.Label("item_avg", string.format("[%s/m]", PrettyNumber(avg)))
					GUI.PopParent()
				end
			GUI.PopAll()
		end
	else
		self.gui[playerIndex].portal_timer.label.caption = "Waiting for connection to homeworld."
		self.gui[playerIndex].portal_timer.data.caption = ""
	end	
end

function Portal:GetStatAvg( item )
	if self.stats and self.stats[item] then
		local sum = 0
		for _, count in ipairs(self.stats[item]) do
			sum = sum + count
		end
		local avg = sum / #self.stats[item]
		return avg
	else
		return 0
	end
end