Homeworld = {}

local config = {
   starting_population = 100,
   min_population = 10,
   max_population = 10000,
   max_growth_rate = 35,
   max_decline_rate = 15,
   update_interval = 1 * SECONDS,
}

function Homeworld:init()
   self.state = {
      tier = 1,
      population = config.starting_population,
      inventory = {},
      average_satisfaction = {},
      gui = {}
   }
   self:increment_update_timer()
   global.homeworld_state = self.state
end

function Homeworld:load()
   self.state = global.homeworld_state
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
   return needs_prototype[self.state.tier]
end

function Homeworld:get_next_tier()
   return needs_prototype[self.state.tier + 1]
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

function Homeworld:get_total_satisfaction()
   local total_satisfaction = 0
   local current_needs = self:get_needs()
   for _, need in ipairs(current_needs) do
      total_satisfaction = total_satisfaction + self:get_satisfaction_for_need(need)
   end
   local result = total_satisfaction / #current_needs
   return result
end

function Homeworld:change_tier_by( amount )
   local new_tier = self.state.tier + amount
   if needs_prototype[new_tier] then
      self.state.tier = new_tier
      for player_index, frame in pairs(self.state.gui) do
         self:show_needs_gui(player_index)
         self:update_gui(player_index)
      end
   end
end

function Homeworld:update_population()
   local total_satisfaction = self:get_total_satisfaction()
   local current_tier = self:get_tier()
   local pop_change = RemapNumber(
      total_satisfaction,
      0,
      1,
      current_tier.max_decline_rate,
      current_tier.max_growth_rate
   )
   self.state.population = self.state.population + pop_change
   if self.state.population < config.min_population then
      self.state.population = config.min_population
   end
   local next_tier = self:get_next_tier()
   if next_tier and self.state.population >= current_tier.upgrade_population then
      self:change_tier_by(1)
   elseif self.state.population < current_tier.downgrade_population then
      self:change_tier_by(-1)
   end
end

function Homeworld:update_consumption()
   local needs = self:get_needs()
   for index, need in ipairs(needs) do
      if need.consume_once then
         if self:count_item(need.item) >= need.count then
            self:remove_item{
               name = need.item,
               count = need.count
            }
         end
      else
         local needed = self:get_need_item_count(need, config.update_interval)
         self:remove_item{
            name = need.item,
            count = needed
         }
      end
   end
end

function Homeworld:tick( tick )
   if self:can_update() then
      self:increment_update_timer()
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
   GUI.label_data("population", {"population"}, "0 / 0")
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
                  GUI.label("consumption", "Consume once: "..PrettyNumber(need.count))
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
   local upgrade_pop = self:get_tier().upgrade_population
   local downgrade_pop = self:get_tier().downgrade_population
   local pop_bar_value = (pop - downgrade_pop) / (upgrade_pop - downgrade_pop)
   my_gui.tier.data.caption = string.format("%i / %i", self.state.tier, #needs_prototype)
   my_gui.population.data.caption = string.format("%s / %s", PrettyNumber(pop), PrettyNumber(upgrade_pop))
   my_gui.population_bar.value = pop_bar_value
   local needs_gui = my_gui.needs
   for index, need in ipairs(self:get_needs()) do
      local need_gui = needs_gui["need_"..index]
      local labels = need_gui.label_icon.labels
      if not need.consume_once then
         local per_day = self:get_need_item_count(need, GAME_DAY)
         labels.consumption.caption = string.format("Consumption per day: %s", PrettyNumber(per_day))
      end
      local in_stock = self:count_item(need.item)
      labels.item.label.caption = game.item_prototypes[need.item].localised_name
      labels.item.data.caption = string.format("[%s]", PrettyNumber(in_stock))
      need_gui.satisfaction.value = self:get_satisfaction_for_need(need)
   end
end

function Homeworld:hide_gui( player_index )
   if not self.state.gui[player_index] then
      return
   end

   self.state.gui[player_index].destroy()
   self.state.gui[player_index] = nil
end
