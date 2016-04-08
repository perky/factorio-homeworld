Homeworld = {}

local config = homeworld_config.homeworld

function Homeworld:init()
   self.state = {
      tier = config.starting_tier,
      population = config.starting_population,
      population_delta = 0,
      inventory = {},
      average_satisfaction = {},
      average_satisfaction_window = 120,
      claimed_rewards = {},
      gui = {}
   }
   self:increment_update_timer()
   global.homeworld_state = self.state
end

function Homeworld:load()
   self.state = global.homeworld_state
   if self.state.claimed_rewards == nil then
    self.state.claimed_rewards = {}
   end
end

function Homeworld:insert_item( item_stack )
   local inventory = self.state.inventory
   if not inventory[item_stack.name] then
      inventory[item_stack.name] = item_stack.count
   else
      local count = inventory[item_stack.name]
      inventory[item_stack.name] = count + item_stack.count
   end
end

function Homeworld:remove_item( item_stack )
   local inventory = self.state.inventory
   if inventory[item_stack.name] then
      inventory[item_stack.name] = inventory[item_stack.name] - item_stack.count
      if inventory[item_stack.name] <= 0 then
         inventory[item_stack.name] = nil
      end
   end
end

function Homeworld:count_item( item_name )
   local inventory = self.state.inventory
   if inventory[item_name] then
      return inventory[item_name]
   else
      return 0
   end
end

function Homeworld:can_update()
   return game.tick >= self.state.next_update_tick
end

function Homeworld:increment_update_timer()
   self.state.next_update_tick = game.tick + config.update_interval
end

function Homeworld:get_tier()
   return config.tiers[self.state.tier]
end

function Homeworld:get_next_tier()
   return config.tiers[self.state.tier + 1]
end

function Homeworld:get_needs()
   return self:get_tier().needs
end

function Homeworld:get_need_item_count( need, duration )
   if need.consume_once then
      return need.count
   else
      local duration = duration or MINUTES
      local upgrade_pop = self:get_tier().upgrade_population
      local pop = self.state.population
      return (need.max_per_day * duration * pop) / (upgrade_pop * GAME_DAY)
   end
end

function Homeworld:get_satisfaction_for_need( need )
   local total_needed = self:get_need_item_count(need, config.update_interval)
   local item_count = math.min(total_needed, self:count_item(need.item))
   local satisfaction = item_count / total_needed
   return satisfaction
end

function Homeworld:get_average_satisfaction_for_need( need )
   if need.consume_once then
      return self:get_satisfaction_for_need(need)
   else
      local average = self.state.average_satisfaction
      if average[need.item] then
         return average[need.item].satisfaction
      else
         return 0
      end
   end
end

function Homeworld:get_total_satisfaction()
   local total_satisfaction = 0
   local current_needs = self:get_needs()
   for _, need in ipairs(current_needs) do
      total_satisfaction = total_satisfaction + self:get_average_satisfaction_for_need(need)
   end
   return total_satisfaction / #current_needs
end

function Homeworld:change_tier_by( amount )
   local new_tier = self.state.tier + amount
   
   if new_tier == 7 then
    game.set_game_state{game_finished = true, player_won = true, next_level = false, can_continue = true}
   end
   
   if config.tiers[new_tier] then
      -- If upgrading...
      if amount > 0 then
         -- Spawn rewards.
         if not self.state.claimed_rewards[self.state.tier] then
            self:spawn_reward(self:get_tier())
            self.state.claimed_rewards[self.state.tier] = true
         end
         -- Consume 'consume_once' needs.
         for index, need in ipairs(self:get_needs()) do
            if need.consume_once then
               self:remove_item{name = need.item, count = need.count}
            end
         end
         PrintToAllPlayers("Homeworld population upgraded to ".. config.tiers[new_tier].name ..".")
      end

      -- If downgrading..
      if amount < 0 then
         PrintToAllPlayers("Homeworld population downgraded to ".. config.tiers[new_tier].name .."!")
      end

      -- Update tier.
      self.state.tier = new_tier
      for player_index, frame in pairs(self.state.gui) do
         self:show_needs_gui(player_index)
         self:update_gui(player_index)
      end
   end
end

function Homeworld:update_satisfaction()
   local window = self.state.average_satisfaction_window
   local average_satisfaction = self.state.average_satisfaction
   for index, need in ipairs(self:get_needs()) do
      local avg = average_satisfaction[need.item]
      if not avg then
         avg = {
            next = 1,
            satisfaction = 0
         }
         for k = 1, window do
            avg[k] = 0
         end
      end
      avg[avg.next] = self:get_satisfaction_for_need(need)
      avg.next = avg.next + 1
      if avg.next > window then
         avg.next = 1
      end
      local total = 0
      for k = 1, window do
         total = total + avg[k]
      end
      avg.satisfaction = total / window
      average_satisfaction[need.item] = avg
   end
end

function Homeworld:are_consume_once_needs_satisfied()
   for index, need in ipairs(self:get_needs()) do
      if need.consume_once then
         if self:count_item(need.item) < need.count then
            return false
         end
      end
   end
   return true
end

function Homeworld:can_upgrade_tier()
   local current_tier = self:get_tier()
   if self.state.population >= current_tier.upgrade_population then
      -- All 'consume_once' needs must be met before we can upgrade tier.
      return self:are_consume_once_needs_satisfied()
   end
   return false
end

function Homeworld:update_population()
   local state = self.state

   -- Calculate population change.
   local total_satisfaction = self:get_total_satisfaction()
   local current_tier = self:get_tier()
   local pop_change = RemapNumber(
      total_satisfaction,
      0,
      1,
      current_tier.max_decline_rate,
      current_tier.max_growth_rate
   )
   if pop_change > 0 and state.population >= current_tier.upgrade_population and not self:are_consume_once_needs_satisfied() then
      pop_change = 0
   end

   -- Change population.
   local last_pop = state.population
   state.population = state.population + pop_change
   if state.population < config.min_population then
      state.population = config.min_population
   end

   local last_pop_delta = state.population_delta
   state.population_delta = state.population - last_pop

   if state.population_delta > 0 then
      state.is_population_increasing = true
   elseif state.population_delta < 0 then
      if state.is_population_increasing then
         PrintToAllPlayers("Homeworld population is declining!")
      end
      state.is_population_increasing = false
   end

   -- Upgrade or downgrade tier.
   local next_tier = self:get_next_tier()
   if next_tier and self:can_upgrade_tier() then
      self:change_tier_by(1)
   elseif state.population < current_tier.downgrade_population then
      self:change_tier_by(-1)
   end
end

function Homeworld:update_consumption()
   local needs = self:get_needs()
   for index, need in ipairs(needs) do
      if not need.consume_once then
         local needed = self:get_need_item_count(need, config.update_interval)
         self:remove_item{
            name = need.item,
            count = needed
         }
      end
   end
end

function Homeworld:spawn_reward( tier )
   -- Select random portal.
   local portal = table.random_value(Portal._instances)
   if portal then
      local portal_entity = portal.state.entity
      local chest_name = "iron-chest"
      local spawn_pos = portal_entity.surface.find_non_colliding_position(chest_name, portal_entity.position, 30, 1.0)
      if spawn_pos then
         -- Spawn chest.
         local chest = portal_entity.surface.create_entity{
            name = chest_name,
            force = portal_entity.force,
            position = spawn_pos
         }
         -- Insert reward items.
         local chest_inventory = chest.get_inventory(1)
         local reward = table.random_value(tier.rewards)
         for index, item_stack in ipairs(reward) do
            chest_inventory.insert(item_stack)
         end
         -- Show arrow to closest player.
         local nearest_player = GetNearest(game.players, portal_entity.position)
         if nearest_player then
            nearest_player.set_gui_arrow{
               type = "entity",
               entity = chest
            }
         end
      else
         PrintToAllPlayers("Could not find suitable location to drop reward chest.")
      end
   end
end

function Homeworld:tick( tick )
   if self:can_update() then
      self:increment_update_timer()
      self:update_satisfaction()
      self:update_population()
      self:update_consumption()
      for player_index, frame in pairs(self.state.gui) do
         self:update_gui(player_index)
      end
   end
end

function Homeworld:show_gui( player_index )
   if self.state.gui[player_index] then
      return
   end

   GUI.push_left_section(player_index)
   self.state.gui[player_index] = GUI.push_parent(GUI.frame("homeworld", "Homeworld", GUI.VERTICAL))
   GUI.label_data("tier", "Tier:", "1 / 6")
   GUI.label_data("population", {"population"}, "0 / 0 [0]")
   GUI.progress_bar("population_bar", 0)
   self:show_needs_gui(player_index)
   GUI.pop_all()
   self:update_gui(player_index)
end

function Homeworld:show_needs_gui( player_index )
   local my_gui = self.state.gui[player_index]
   if my_gui.needs then
      my_gui.needs.destroy()
   end
   GUI.push_parent(my_gui)
   GUI.push_parent(GUI.flow("needs", GUI.VERTICAL))
   for index, need in ipairs(self:get_needs()) do
      GUI.push_parent(GUI.flow("need_"..index, GUI.VERTICAL))
         GUI.push_parent(GUI.flow("label_icon", GUI.HORIZONTAL))
            GUI.icon("icon", need.item)
            GUI.push_parent(GUI.flow("labels", GUI.VERTICAL))
					GUI.label_data("item", game.item_prototypes[need.item].localised_name, "[0]")
               if need.consume_once then
                  GUI.label("consumption", "Target: "..PrettyNumber(need.count))
               else
                  local per_day = self:get_need_item_count(need, GAME_DAY)
                  GUI.label("consumption", "Consumption per day: "..PrettyNumber(per_day))
               end
            GUI.pop_parent()
         GUI.pop_parent()
         if need.consume_once then
            GUI.progress_bar("satisfaction", 1, 0, "homeworld_need_all_progressbar_style")
         else
            GUI.progress_bar("satisfaction", 1, 0, "homeworld_need_progressbar_style")
         end
      GUI.pop_parent()
   end
   GUI.pop_parent()
   GUI.pop_parent()
end

function Homeworld:update_gui( player_index )
   local my_gui = self.state.gui[player_index]
   local state = self.state
   local pop = state.population
   local pop_delta = state.population_delta
   local upgrade_pop = self:get_tier().upgrade_population
   local downgrade_pop = self:get_tier().downgrade_population
   local pop_bar_value = (pop - downgrade_pop) / (upgrade_pop - downgrade_pop)
   if math.floor(pop_delta) > 0 then
      pop_delta = string.format("+%i", math.floor(pop_delta))
   else
      pop_delta = string.format("%i", math.floor(pop_delta))
   end
   my_gui.tier.data.caption = string.format("%i / %i", self.state.tier, #config.tiers)
   my_gui.population.data.caption = string.format("%s / %s [%s]", PrettyNumber(pop), PrettyNumber(upgrade_pop), pop_delta)
   my_gui.population_bar.value = pop_bar_value
   local needs_gui = my_gui.needs
   for index, need in ipairs(self:get_needs()) do
      local need_gui = needs_gui["need_"..index]
      if need_gui then
         local labels = need_gui.label_icon.labels
         if not need.consume_once then
            local per_day = self:get_need_item_count(need, GAME_DAY)
            labels.consumption.caption = string.format("Consumption per day: %s", PrettyNumber(per_day))
         end
         local in_stock = self:count_item(need.item)
         labels.item.label.caption = game.item_prototypes[need.item].localised_name
         labels.item.data.caption = string.format("[%s]", PrettyNumber(in_stock))
         need_gui.satisfaction.value = self:get_average_satisfaction_for_need(need)
      end
   end
end

function Homeworld:hide_gui( player_index )
   if self.state.gui[player_index] == nil then
      return
   end
   self.state.gui[player_index].destroy()
   self.state.gui[player_index] = nil
end
