local TERRFORM_MODULE_TYPES = {
	["terraform-module-sand"] = "sand",
	["terraform-module-grass"] = "grass",
	["terraform-module-dirt"] = "dirt",
	["terraform-module-stone"] = "stone-path",
	["terraform-module-concrete"] = "concrete",
}

ActorClass("Terraformer", {
	max_terraform_steps = 3000
})

function Terraformer:Init()
	self.entity.active = false
end

function Terraformer:OnLoad()
	if self.is_terraforming then
		StartCoroutine(self.TerraformRoutine, {delegate = self, validater = self.ValidateRoutine})
	end
end

function Terraformer:OnDestroy()
	DestroyRoutines(self)
end

function Terraformer:OnTick()
	local inputInventory = self.entity.get_inventory(2)
	if (not inputInventory.is_empty()) and (not self.is_terraforming) then
		self:StartTerraforming()
	end
end

function Terraformer:ValidateRoutine()
	return self.entity and self.entity.valid
end

function Terraformer:StartTerraforming()
	self.is_terraforming = true
	self.entity.active = true

	local inputInventory = self.entity.get_inventory(2)
	local input = inputInventory[1].name
	self.terraform_tile_name = TERRFORM_MODULE_TYPES[input]

	-- initialise state variables.
	self.saved_cursor_position = self.entity.position
	self.saved_step = 0
	self.saved_step_count = 1
	self.saved_total_count = 0
	self.saved_state = RIGHT

	StartCoroutine(self.TerraformRoutine, {delegate = self, validater = self.ValidateRoutine})
end

--[[
	Terraforms the surface in a 'square spiral'.
]]
function Terraformer:TerraformRoutine()
	local maxStep = self.max_terraform_steps
	local tileName = self.terraform_tile_name
	local surface = self.entity.surface
	local progressInterval = 1 / maxStep
	
	-- load in saved state data.
	local current = self.saved_cursor_position
	local startingStep = self.saved_step
	local stepCount = self.saved_step_count
	local totalCount = self.saved_total_count
	local state = self.saved_state
	local offset = OFFSET_MAP[state]

	while totalCount < maxStep and self.entity.is_crafting() do
		for step = startingStep, stepCount do
			-- Set the tiles.
			local p1 = current
			local p2 = {current.x - 1, current.y - 1}
			local p3 = {current.x, current.y - 1}
			local p4 = {current.x - 1, current.y}
			local p5 = {current.x + 1, current.y + 1}
			local p6 = {current.x + 1, current.y}
			local p7 = {current.x, current.y + 1}
			surface.set_tiles{
				{name=tileName, position=p1},
				{name=tileName, position=p2},
				{name=tileName, position=p3},
				{name=tileName, position=p4},
				{name=tileName, position=p5},
				{name=tileName, position=p6},
				{name=tileName, position=p7}
			}

			-- Move our 'cursor' along the offset.
			current.x = current.x + offset.x
			current.y = current.y + offset.y
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
				if not self.entity.is_crafting() then
					break
				end
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

	-- Terraforming routine finished.
	self.is_terraforming = false
	self.entity.active = false
end