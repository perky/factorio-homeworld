Fishery = Actor{name = "fishery", use_entity_gui = true}

local config = homeworld_config.fishery;

local fish_chunks = {}
local fish_chunk_index = 1
function Fishery.update_fish_chunks()
   if global.fish_in_chunk == nil then return end
   if #fish_chunks == 0 then
      for chunk_name, num_fish in pairs(global.fish_in_chunk) do
         table.insert(fish_chunks, chunk_name)
      end
      fish_chunk_index = 1
   else
      if fish_chunk_index <= #fish_chunks then
         local chunk_name = fish_chunks[fish_chunk_index]
         global.fish_in_chunk[chunk_name] = global.fish_in_chunk[chunk_name] + math.random(0,10)
         fish_chunk_index = fish_chunk_index + 1  
      else
         fish_chunks = {}
      end
   end
end

function Fishery:init()
   local chunk_size = 100
   self.state.chunk_x = math.floor(self.state.entity.position.x / chunk_size)
   self.state.chunk_y = math.floor(self.state.entity.position.y / chunk_size)
   self.state.chunk_name = "["..self.state.chunk_x..","..self.state.chunk_y.."]"
   PrintToAllPlayers(self.state.chunk_name)
   
   if global.fish_in_chunk == nil then
      global.fish_in_chunk = {}
   end
   if global.fish_in_chunk[self.state.chunk_name] == nil then
      global.fish_in_chunk[self.state.chunk_name] = config.fish_per_chunk
   end
   
   self:increment_harvest_timer()
end

function Fishery:get_fish_in_chunk()
   local fishAmount = global.fish_in_chunk[self.state.chunk_name]
   return fishAmount
end

function Fishery:remove_fish_in_chunk( amount )
   local fish_amount = global.fish_in_chunk[self.state.chunk_name]
   global.fish_in_chunk[self.state.chunk_name] = fish_amount - amount
   if global.fish_in_chunk[self.state.chunk_name] < 0 then
      global.fish_in_chunk[self.state.chunk_name] = 0
   end
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

function Fishery:get_overfishing_percent()
   local nearby_fisheries = self:count_nearby_fisheries()
   local result = 1.0 - math.min(nearby_fisheries * config.yield_reduce_per_nearby_fishery, 1.0)
   return result
end

function Fishery:get_yield( water_purity, overfishing )
   local potential_fish = self:get_fish_in_chunk()
   local water_purity = water_purity or self:get_water_purity()
   local overfishing = overfishing or self:get_overfishing_percent()
   local interval = config.harvest_interval * (1/MINUTES)
   local yield = config.max_fish_yield_per_min * interval * water_purity * overfishing
   if yield > potential_fish then
      return potential_fish
   else
      return yield
   end
end

function Fishery:count_nearby_fisheries()
   local entity = self.state.entity
   local nearby_fisheries = entity.surface.find_entities_filtered{
      area = SquareArea(entity.position, config.radius),
      name = "fishery"
   }
   return #nearby_fisheries - 1
end

function Fishery:tick( tick )
   local entity = self.state.entity
   if self:can_harvest() then
      local yield = math.floor(self:get_yield())
      local fish_stack = {
         name = "raw-fish",
         count = yield
      }
      local inventory = entity.get_inventory(1)
      if yield > 0 and inventory.can_insert(fish_stack) then
         inventory.insert(fish_stack)
         self:remove_fish_in_chunk(yield)
      end
      self:increment_harvest_timer()
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
   GUI.label_data("fishamount", "Potential fish:", "0")
   GUI.label_data("nearbyfishery", "Overfishing:", "0%")
   GUI.label_data("purity", "Water Purity:", "0%")
   GUI.label_data("yield", "Total Yield:", "0/m")
   GUI.pop_all()
   self:update_gui(player_index, gui)
end

function Fishery:hide_gui( player_index, gui )
   gui[player_index].destroy()
   gui[player_index] = nil
end

function Fishery:update_gui( player_index, gui )
   local format = "%i%%"
   local fish_amount = self:get_fish_in_chunk()
   local water_purity = self:get_water_purity()
   local overfishing = self:get_overfishing_percent()
   local yield = self:get_yield(water_purity, overfishing)
   gui[player_index].fishamount.data.caption = string.format("%i", fish_amount)
   gui[player_index].nearbyfishery.data.caption = string.format("-%i%%", math.floor(100 - (overfishing*100)))
   gui[player_index].purity.data.caption = string.format(format, math.floor(water_purity * 100))
   gui[player_index].yield.data.caption = string.format("%i/m", math.floor(yield))
end
