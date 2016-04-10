Fishery = Actor{name = "fishery", use_entity_gui = true}

local config = homeworld_config.fishery;

function Fishery:init()
   self:increment_harvest_timer()
   self:increment_reproduce_timer()
end

function Fishery:increment_harvest_timer()
   self.state.next_harvest_tick = game.tick + config.harvest_interval
end

function Fishery:increment_reproduce_timer()
   self.state.next_reproduce_tick = game.tick + config.reproduction_interval
end

function Fishery:can_harvest()
   return game.tick >= self.state.next_harvest_tick
end

function Fishery:can_reproduce()
   return game.tick >= self.state.next_reproduce_tick
end

function Fishery:get_water_purity()
   local entity = self.state.entity
   local pollution = entity.surface.get_pollution(entity.position)
   pollution = math.min(pollution, config.max_pollution)
   local water_purity = RemapNumber(pollution, 0, config.max_pollution, 1, 0)
   return water_purity
end

function Fishery:get_yield( water_purity )
   local water_purity = water_purity or self:get_water_purity()
   local nearby_fisheries = self:count_nearby_fisheries()
   local yield = 1.0 - math.min(nearby_fisheries * config.yield_reduce_per_nearby_fishery, 1.0)
   return yield * water_purity
end

function Fishery:count_nearby_fisheries()
   local entity = self.state.entity
   local nearby_fisheries = entity.surface.find_entities_filtered{
      area = SquareArea(entity.position, config.radius),
      name = "fishery"
   }
   return #nearby_fisheries - 1
end

function Fishery:get_nearby_fish()
   local entity = self.state.entity
   if not entity.valid then return {} end
   local nearby_fish = entity.surface.find_entities_filtered{
      area = SquareArea(entity.position, config.radius),
      name = "fish"
   }
   return nearby_fish
end

function Fishery:get_random_nearby_fish()
   local nearby_fish = self:get_nearby_fish()
   if #nearby_fish > 0 then
      return table.random_value(nearby_fish)
   else
      return nil
   end
end

function Fishery:tick( tick )
   local entity = self.state.entity
   -- Harvest.
   if self:can_harvest() then
      local fish = self:get_random_nearby_fish()
      if fish then
         local inventory = entity.get_inventory(1)
         local interval = config.harvest_interval * (1/MINUTES)
         local yield = self:get_yield()
         local item_count = math.max(config.max_fish_yield_per_min * interval * yield, 1)
         local fish_stack = {
            name = "raw-fish",
            count = item_count
         }
         if item_count > 0 and inventory.can_insert(fish_stack) then
            inventory.insert(fish_stack)
            local die_chance = config.fish_die_chance
            local nearby_fisheries = self:count_nearby_fisheries()
            die_chance = die_chance + (nearby_fisheries * config.fish_die_chance_increase_per_fishery)
            if math.random() <= die_chance then
               fish.destroy()
            end
         end
      end
      self:increment_harvest_timer()
   end
   -- Reproduce.
   if self:can_reproduce() then
      if math.random() <= config.fish_reproduction_chance then
         local nearby_fish = self:get_nearby_fish()
         if #nearby_fish > 0 and #nearby_fish < config.max_fish then
            local fish = table.random_value(nearby_fish)
            local entity = self.state.entity
            entity.surface.create_entity{
               name = "fish",
               force = game.forces.neutral,
               position = fish.position
            }
         end
      end
      self:increment_reproduce_timer()
   end
   -- Update GUI.
   if ModuloTimer(1 * SECONDS) then
      for player_index, frame in pairs(self.state.gui) do
         self:update_gui(player_index, self.state.gui)
      end
   end
end

function Fishery:show_gui( player_index, gui )
   GUI.push_left_section(player_index)
   gui[player_index] = GUI.push_parent(GUI.frame("fishery", "Fishery", GUI.VERTICAL))
   GUI.label_data("purity", "Water Purity:", "0%")
   GUI.label_data("fish", "Fish:", "0")
   GUI.label_data("yield", "Yield:", "0%")
   GUI.pop_all()
   self:update_gui(player_index, gui)
end

function Fishery:hide_gui( player_index, gui )
   gui[player_index].destroy()
   gui[player_index] = nil
end

function Fishery:update_gui( player_index, gui )
   local format = "%i%%"
   local water_purity = self:get_water_purity()
   local yield = self:get_yield(water_purity)
   gui[player_index].purity.data.caption = string.format(format, math.floor(water_purity * 100))
   gui[player_index].yield.data.caption = string.format(format, math.floor(yield * 100))
   if gui[player_index].fish then
      gui[player_index].fish.data.caption = string.format("%i", #self:get_nearby_fish())
   end
end
