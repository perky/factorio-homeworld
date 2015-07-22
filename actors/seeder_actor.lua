ActorClass("Seeder", {
	max_seeder_steps = 500,
	energy_usage = 20000,
	seeder_tick_interval = 20
})

function Seeder:Init()
	self.gui = {}
end

function Seeder:OnLoad()
	if self.is_seeding then
		StartCoroutine(self.SeedingRoutine, self)
	end
end

function Seeder:OnDestroy()
	self:CloseAllGUI()
	DestroyRoutines(self)
end

function Seeder:OnTick()
	if (game.tick % 30) == 0 then -- Twice a second.

		for playerIndex = 1, #game.players do
			local player = game.players[playerIndex]
			local distance = util.distance(player.position, self.entity.position)
			if distance < 4 then
				self:OpenGUI(playerIndex)
			else
				self:CloseGUI(playerIndex)
			end
		end

	end
end

function Seeder:OpenGUI( playerIndex )
	if self.gui[playerIndex] then
		return
	end

	GUI.PushLeftSection(playerIndex)
	self.gui[playerIndex] = GUI.PushParent(GUI.Frame("terraformer_gui", "Terraformer", GUI.VERTICAL))

	if self.is_seeding then
		GUI.Label("info", "Seeding in progress.")
	else
		for treeIndex = 1, 5 do
			local treeName = string.format("tree-%02d", treeIndex)
			local buttonCaption = string.format("Start seeding program #%02d", treeIndex)
			GUI.Button("start_"..treeIndex, buttonCaption, "StartSeeding", self, treeName)
		end
	end

	GUI.PopAll()
end

function Seeder:CloseGUI( playerIndex )
	if self.gui[playerIndex] then
		self.gui[playerIndex].destroy()
		self.gui[playerIndex] = nil
	end
end

function Seeder:CloseAllGUI()
	for playerIndex = 1, #game.players do
		self:CloseGUI(playerIndex)
	end
end

function Seeder:StartSeeding( playerIndex, treeName )
	self.is_seeding = true
	self.tree_name = treeName

	-- initialise state variables.
	self.saved_cursor_position = self.entity.position
	self.saved_step = 0
	self.saved_step_count = 1
	self.saved_total_count = 0
	self.saved_state = RIGHT

	self:CloseAllGUI()
	StartCoroutine(self.SeedingRoutine, self)
end

function Seeder:SeedingRoutine()
	local maxStep = self.max_seeder_steps
	local surface = self.entity.surface
	
	-- load in saved state data.
	local current = self.saved_cursor_position
	local startingStep = self.saved_step
	local stepCount = self.saved_step_count
	local totalCount = self.saved_total_count
	local state = self.saved_state
	local offset = OFFSET_MAP[state]

	while totalCount < maxStep do
		for step = startingStep, stepCount do
			-- Make sure the entity has enough energy.
			while self.entity.energy < self.energy_usage do
				coroutine.yield()
			end
			self.entity.energy = self.entity.energy - self.energy_usage

			-- Plant tree. (70% chance)
			if math.random(1,10) < 7 then
				local rpos = {x = current.x + math.random()*2, y = current.y + math.random()*2} 
				local plantPos = surface.find_non_colliding_position(self.tree_name, rpos, 2, 0.2)
				if plantPos then
					surface.create_entity{name = self.tree_name, position = plantPos, force = game.forces.neutral}
				end
			end

			-- Move our 'cursor' along the offset.
			current.x = current.x + (offset.x * 2)
			current.y = current.y + (offset.y * 2)
			totalCount = totalCount + 1

			-- Save our state.
			self.saved_step = step
			self.saved_total_count = totalCount

			-- Wait before setting the tiles again.
			WaitForTicks(self.seeder_tick_interval)

			if totalCount >= maxStep then
				break
			end
		end

		-- The 'cursor' has reached the end of a line, change direction
		-- such that we spiral outwards.
		stepCount = stepCount + 1
		state = state + 1
		if state > UP then
			state = RIGHT
		end
		offset = OFFSET_MAP[state]

		-- Save our state.
		self.saved_step_count = stepCount
		self.saved_state = state
	end

	self.is_seeding = false
	PrintToAllPlayers("Seeding Complete.")
	self:CloseAllGUI()
end