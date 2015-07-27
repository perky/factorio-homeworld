local TREE_TYPES = {
	["seeder-module-01"] = "tree-01",
	["seeder-module-02"] = "tree-02",
	["seeder-module-03"] = "tree-03",
	["seeder-module-04"] = "tree-04",
	["seeder-module-05"] = "tree-05",
}

ActorClass("Seeder", {
	max_seeder_steps = 500
})

function Seeder:Init()
	-- set entity to inactive so that we have a chance to read
	-- the input item before it starts to 'smelt' it.
	self.entity.active = false
end

function Seeder:OnLoad()
	if self.is_seeding then
		StartCoroutine(self.SeedingRoutine, self)
	end
end

function Seeder:OnDestroy()
	DestroyRoutines(self)
end

function Seeder:OnTick()
	local inputInventory = self.entity.get_inventory(2)
	if (not inputInventory.is_empty()) and (not self.is_seeding) then
		self:StartSeeding()
	end
end

function Seeder:StartSeeding()
	self.is_seeding = true

	local inputInventory = self.entity.get_inventory(2)
	local input = inputInventory[1].name

	self.tree_name = TREE_TYPES[input]
	PrintToAllPlayers(self.tree_name)

	-- initialise state variables.
	self.saved_cursor_position = self.entity.position
	self.saved_step = 0
	self.saved_step_count = 1
	self.saved_total_count = 0
	self.saved_state = RIGHT

	self.entity.active = true
	StartCoroutine(self.SeedingRoutine, self)
end

function Seeder:SeedingRoutine()
	local maxStep = self.max_seeder_steps
	local surface = self.entity.surface
	local progressInterval = 1 / maxStep
	
	-- load in saved state data.
	local current = self.saved_cursor_position
	local startingStep = self.saved_step
	local stepCount = self.saved_step_count
	local totalCount = self.saved_total_count
	local state = self.saved_state
	local offset = OFFSET_MAP[state]

	WaitForTicks(1*SECONDS)

	while totalCount < maxStep and self.entity.is_crafting() do
		for step = startingStep, stepCount do
			-- Plant tree. (70% chance)
			if math.random(1,10) < 7 then
				local rpos = {x = current.x + math.random()*2, y = current.y + math.random()*2} 
				local plantPos = surface.find_non_colliding_position(self.tree_name, rpos, 2, 0.2)
				if plantPos then
					surface.create_entity{name = self.tree_name, position = plantPos, force = game.forces.neutral}
				end
			end

			-- Move our 'cursor' along the offset.
			current.x = current.x + (offset.x * 1)
			current.y = current.y + (offset.y * 1)
			totalCount = totalCount + 1

			-- Save our state.
			self.saved_step = step
			self.saved_total_count = totalCount
			self.saved_cursor_position = current

			-- Wait before setting the tiles again.
			coroutine.yield()
			local nextProgress = self.entity.crafting_progress + progressInterval
			while self.entity.crafting_progress < nextProgress do
				coroutine.yield()
			end

			if totalCount >= maxStep or (not self.entity.is_crafting()) then
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
	self.entity.active = false
end