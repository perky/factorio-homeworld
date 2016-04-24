Terraformer = Actor{name = "terraformer"}

local RIGHT, DOWN, LEFT, UP = 1, 2, 3, 4
local CURSOR_OFFSET = {
   [RIGHT] = {x = 1, y = 0},
   [DOWN] = {x = 0, y = 1},
   [LEFT] = {x = -1, y = 0},
   [UP] = {x = 0, y = -1}
}
local config = homeworld_config.terraformer

function Terraformer:init()
   self.state.last_step_tick = game.tick
   self:reset_cursor()
end

function Terraformer:load()
   if not self.state.last_step_tick then
      self.state.last_step_tick = 0
   end
end

function Terraformer:can_do_step()
   local entity = self.state.entity
   local energy = entity.energy
   if energy == 0 then
      return false
   else
      local step_interval = RemapNumber(energy, 0, config.max_energy, config.max_step_interval, config.min_step_interval)
      local wait_time = game.tick - self.state.last_step_tick
      return wait_time >= step_interval and entity.is_crafting()
   end
end

function Terraformer:tick( tick )
   local entity = self.state.entity
   if not entity or not entity.valid then return end
   local state = self.state

   -- Get module type.
   local inventory = entity.get_inventory(2)
   if not inventory.is_empty() then
      local module = inventory[1]
      if config.tile_types[module.name] then
         state.tile_name = config.tile_types[module.name]
      end
   end

   if self:can_do_step() then
      self:do_step()
      state.last_step_tick = tick
      if util.distance(state.cursor, entity.position) >= config.radius then
         self:reset_cursor()
      end
   end
end

function Terraformer:reset_cursor()
   local state = self.state
   state.cursor = state.entity.position
   state.line_step_end = 1
   state.line_step = 1
   state.direction = RIGHT
end

function Terraformer:terraform_block( position, tile_name )
   local p1 = position
   local p2 = {position.x - 1,   position.y - 1}
   local p3 = {position.x,       position.y - 1}
   local p4 = {position.x - 1,   position.y}
   local p5 = {position.x + 1,   position.y + 1}
   local p6 = {position.x + 1,   position.y}
   local p7 = {position.x,       position.y + 1}
   self.state.entity.surface.set_tiles{
      {name=tile_name, position=p1},
      {name=tile_name, position=p2},
      {name=tile_name, position=p3},
      {name=tile_name, position=p4},
      {name=tile_name, position=p5},
      {name=tile_name, position=p6},
      {name=tile_name, position=p7}
   }
end

function Terraformer:do_step()
   local state = self.state
   self:terraform_block(state.cursor, state.tile_name)
   state.cursor.x = state.cursor.x + CURSOR_OFFSET[state.direction].x
   state.cursor.y = state.cursor.y + CURSOR_OFFSET[state.direction].y
   state.line_step = state.line_step + 1
   -- Spiral the cursor outwards.
   if state.line_step >= state.line_step_end then
      state.line_step = 1
      state.line_step_end = state.line_step_end + 1
      state.direction = state.direction + 1
      if state.direction > UP then
         state.direction = RIGHT
      end
   end
end
