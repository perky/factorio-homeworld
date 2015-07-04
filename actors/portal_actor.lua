ActorClass("Portal", {
	open_gui_on_selected = true,
	homeworld = nil,
	transfer_interval = 1 * MINUTES,
	countdown_tick = 0
})

function Portal:Init()
	self.enabled = true

	game.onevent(HOMEWORLD_EVENTS.HOMEWORLD_ONLINE, function()
		StartCoroutine(self.TransferItemsRoutine, self)
	end)
end

function Portal:OnLoad()
	self.enabled = true
	if self.homeworld.online then
		StartCoroutine(self.TransferItemsRoutine, self)
	else
		game.onevent(HOMEWORLD_EVENTS.HOMEWORLD_ONLINE, function()
			StartCoroutine(self.TransferItemsRoutine, self)
		end)
	end
end

function Portal:OnDestroy()
	self.enabled = false
	DestroyRoutines(self)
end

function Portal:OnTick()
	self:UpdateGUI()
end

function Portal:TransferItemsRoutine()
	local inventory = self.entity.getinventory(1)
	self.stats = {}

	while self.enabled do
		while self.countdown_tick > 0 do
			self.countdown_tick = self.countdown_tick - 1
			coroutine.yield()
		end

		local needs = self.homeworld:CurrentNeeds()
		for _, need in ipairs(needs) do
			local count = inventory.getitemcount(need.item)
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
		game.createentity({name = "portal-sound", position = self.entity.position, force = game.forces.player})
		self.countdown_tick = self.transfer_interval
		coroutine.yield()
	end
end

function Portal:DoPortalRoutine()
	while self.enabled do
		while self.countdown_tick > 0 do
			self.countdown_tick = self.countdown_tick - 1
			coroutine.yield()
		end

		-- Create portal FX.
		game.createentity({name = "portal-sound", position = self.entity.position})

		local inventory = self.entity.getinventory(1)
		local contents = inventory.getcontents()
		for item, count in pairs(contents) do
			local remaining = count
			local chunk = 10
			while remaining > 0 do
				local take = math.min(chunk, remaining)
				inventory.remove{name = item, count = take}
				self.homeworld:InsertItem(item, take)
				remaining = remaining - take
				coroutine.yield()
			end
		end
		self.countdown_tick = self.transfer_interval
		coroutine.yield()
	end
end

function Portal:OpenGUI()
	if game.player.gui.left.portal_gui then
		game.player.gui.left.portal_gui.destroy()
	end

	GUI.PushParent(game.player.gui.left)
	self.gui = GUI.Frame("portal_gui", "Homeworld Portal", GUI.VERTICAL)
	GUI.PushParent(self.gui)
	GUI.LabelData("portal_timer", {"portal-timer-label"})
	--GUI.Label("countdown", "00:00", "description_title_label_style")
	GUI.PopAll()
end

function Portal:CloseGUI()
	if self.gui then
		self.gui.destroy()
		self.gui = nil
	end
end

function Portal:UpdateGUI()
	if not self.gui then return end
	if self.homeworld.online then
		if self.countdown_tick >= 0 then
			local minutes = math.floor(self.countdown_tick / 3600)
			local seconds = math.floor((self.countdown_tick / 60) % 60)
			--self.gui.portal_timer.data.caption = "Transfering contents in:"
			self.gui.portal_timer.data.caption = string.format("%02i:%02i", minutes, seconds)
		end
	else
		local minutes = math.floor(self.homeworld.grace_period / 3600)
		local seconds = math.floor((self.homeworld.grace_period / 60) % 60)
		--self.gui.label.caption = "Portal opens in:"
		self.gui.portal_timer.data.caption = string.format("%02i:%02i", minutes, seconds)
	end

	if self.stats then
		if self.gui.stats then
			self.gui.stats.destroy()
		end
		GUI.PushParent(self.gui)
		GUI.PushParent(GUI.Frame("stats", "Stats", GUI.VERTICAL))
			for item, stat in pairs(self.stats) do
				GUI.PushParent(GUI.Flow("stat_"..item, GUI.HORIZONTAL))
				GUI.Icon("item_icon", item)
				GUI.Label("item_name", game.getlocaliseditemname(item))
				local avg = self:GetStatAvg(item)
				GUI.Label("item_avg", string.format("[%s/m]", PrettyNumber(avg)))
				GUI.PopParent()
			end
		GUI.PopAll()
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