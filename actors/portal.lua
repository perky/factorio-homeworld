Portal = Actor{name = "portal", use_proximity_gui = true, gui_proximity_radius = 6}

local config = homeworld_config.portal

function Portal:tick( tick )
   if util.modulo_timer(config.update_interval) then
      local inventory = self.state.entity.get_inventory(1)
      if inventory.is_empty() then
        return
      end
      for index = 1, #inventory do
         if inventory[index] and inventory[index].valid_for_read then
            Homeworld:insert_item(inventory[index])
            if not config.test_mode then
               inventory.remove(inventory[index])
            end
         end
      end
      self:do_fx()
   end
end

function Portal:do_fx()
   local entity = self.state.entity
   entity.surface.create_entity{
      name = "portal-sound",
      position = entity.position,
      force = entity.force,
      target = entity
   }
end

function Portal:show_gui( player_index, gui )
   Homeworld:show_gui(player_index)
end

function Portal:hide_gui( player_index, gui )
   Homeworld:hide_gui(player_index)
end
