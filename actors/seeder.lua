Seeder = Actor{name = "seeder"}
local config = homeworld_config.seeder

-- TODO: use module invetory to store seeder programs and have 'seeds' item that gets
-- 'smelted'.

function Seeder:init()
   self:increment_timer()
end

function Seeder:increment_timer()
   local interval = math.random(config.plant_tree_interval.min, config.plant_tree_interval.max)
   self.state.next_plant_tick = game.tick + interval
end

function Seeder:get_tree_type()
   if self.state.entity.is_crafting() then
      local inventory = self.state.entity.get_inventory(2)
      if inventory[1] then
         local tree_module = inventory[1].name
         return config.tree_types[tree_module]
      end
   end
   return nil
end

function Seeder:can_plant()
   local entity = self.state.entity
   return game.tick >= self.state.next_plant_tick
      and entity.valid
      and entity.is_crafting()
      and entity.energy > 0
end

function Seeder:tick( tick )
   local state = self.state
   local entity = self.state.entity
   if not entity.valid then return end

   if self:can_plant() then
      self:increment_timer()
      local tree_name = self:get_tree_type()
      if tree_name then
         local plant_pos = entity.surface.find_non_colliding_position(
            tree_name, entity.position, config.plant_radius, config.plant_precision)
         if plant_pos then
            entity.surface.create_entity{
               name = tree_name,
               position = plant_pos,
               force = game.forces.neutral
            }
         end
      end
   end
end
