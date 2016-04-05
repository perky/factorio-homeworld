Portal = Actor{name = "portal", use_entity_gui = true}

local config = {
   update_interval = 30 * SECONDS
}

function Portal:tick( tick )
   if ModuloTimer(config.update_interval) then
      local inventory = self.state.entity.get_inventory(1)
      for index = 1, #inventory do
         if inventory[index] and inventory[index].valid_for_read then
            Homeworld:insert_item(inventory[index])
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

function Portal:show_gui( player_index )
   Homeworld:show_gui(player_index)
end

function Portal:hide_gui( player_index )
   Homeworld:hide_gui(player_index)
end
