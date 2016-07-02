Seeder = Actor{name = "seeder"}
local config = homeworld_config.seeder

function Seeder:init()
   self:increment_timer()
   
end

function Seeder:increment_timer()
   local interval = math.random(config.plant_tree_interval.min, config.plant_tree_interval.max)
   self.state.next_plant_tick = game.tick + interval
end

function Seeder:get_tree_type()
   local entity = self.state.entity
   if not entity or not entity.valid then return end
   local state = self.state

   -- Get module type.
   local inventory = entity.get_inventory(2)
   if not inventory.is_empty() then
      local module = inventory[1]
      if config.tree_types[module.name] then
		 return config.tree_types[module.name]
	  end
   end
   return nil
end

-- seeder-module-01
-- seeder-module-02
-- seeder-module-03
-- seeder-module-04
-- seeder-module-05

function Seeder:can_plant()
   local entity = self.state.entity
   return game.tick >= self.state.next_plant_tick
      and entity.is_crafting()
      and entity.energy > 0
end

function Seeder:tick( tick )
   local state = self.state
   local entity = self.state.entity
   if not entity.valid then return end
   if entity.energy > 0 and self:get_tree_type() ~= nil then
	state.tree_name = self:get_tree_type()
   end
   if self:can_plant() then
      self:increment_timer()
      if state.tree_name then
         local plant_pos = entity.surface.find_non_colliding_position(
            state.tree_name, entity.position, config.plant_radius, config.plant_precision)
         if plant_pos then
            entity.surface.create_entity{
               name = state.tree_name,
               position = plant_pos,
               force = game.forces.neutral
            }
         end
	  end
   end
end
