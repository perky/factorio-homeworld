local TILE_TYPES = {
	"grass",
	"grass-medium",
	"grass-dry",
	"dirt",
	"dirt-dark",
	"sand",
	"sand-dark",
	"stone-path",
	"concrete"
}

ActorClass("Terraformer", {
	max_terraform_steps = 3000,
	energy_usage = 150000,
	terraform_tick_interval = 1
})

function Terraformer:Init()
	self.gui = {}
end

function Terraformer:OnLoad()
	if self.is_terraforming then
		StartCoroutine(self.TerraformRoutine, self)
	end
end

function Terraformer:OnDestroy()
	for playerIndex = 1, #game.players do
		self:CloseGUI(playerIndex)
	end
	DestroyRoutines(self)
end

function Terraformer:OnTick()
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

function Terraformer:OpenGUI( playerIndex )
	if self.gui[playerIndex] then
		return
	end

	GUI.PushLeftSection(playerIndex)
	self.gui[playerIndex] = GUI.PushParent(GUI.Frame("terraformer_gui", "Terraformer", GUI.VERTICAL))

	if self.is_terraforming then
		GUI.Label("info", "Terraforming in progress.")
	else
		for i, tileType in ipairs(TILE_TYPES) do
			local params = {player_index = playerIndex, tile_type = tileType}
			GUI.Button(tileType.."_btn", tileType, "StartTerraforming", self, params)
		end
	end

	GUI.PopAll()
end

function Terraformer:CloseGUI( playerIndex )
	if self.gui[playerIndex] then
		self.gui[playerIndex].destroy()
		self.gui[playerIndex] = nil
	end
end

function Terraformer:StartTerraforming( playerIndex, params )
	self.is_terraforming = true

	-- initialise state variables.
	self.saved_cursor_position = self.entity.position
	self.saved_step = 0
	self.saved_step_count = 1
	self.saved_total_count = 0
	self.saved_state = RIGHT
	self.terraform_tile_name = params.tile_type

	for playerIndex = 1, #game.players do
		self:CloseGUI(playerIndex)
	end

	StartCoroutine(self.TerraformRoutine, self)
end

--[[
	Terraforms the surface in a 'square spiral'.
]]
function Terraformer:TerraformRoutine()
	local maxStep = self.max_terraform_steps
	local tileName = self.terraform_tile_name
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

			-- Wait before setting the tiles again.
			WaitForTicks(self.terraform_tick_interval)

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

	-- Terraforming routine finished.
	PrintToAllPlayers("Finished Terraforming.")
	self.is_terraforming = false
	for playerIndex = 1, #game.players do
		self:CloseGUI(playerIndex)
	end
end