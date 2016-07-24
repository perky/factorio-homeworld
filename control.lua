require("util")
require("homeworld_defines")
homeworld_config = require('config')
require("helpers.assertion")
require("helpers.actor")
require("helpers.misc_helpers")
require("helpers.gui_helpers")
require("homeworld_logic")
require("actors.sawmill")
require("actors.farm")
require("actors.fishery")
require("actors.seeder")
require("actors.terraformer")
require("actors.portal")
require("actors.belt_throughput_reader")
require("actors.belt_gate")

register_entity_actor(Sawmill, "sawmill")
register_entity_actor(Farm, "farm")
register_entity_actor(Fishery, "fishery")
register_entity_actor(Seeder, "seeder")
register_entity_actor(Terraformer, "terraformer")
register_entity_actor(Portal, "homeworld_portal")
register_entity_actor(BeltThroughputReader, "belt_throughput_reader")
register_entity_actor(BeltGate, "belt_gate")

function on_mod_init( event )
    GUI.init()
    Homeworld:init()
end

function on_mod_load( event )
    Homeworld:load()
    load_persisted_actors()
end

function on_built_entity( event )
    event_create_entity(event.created_entity)
end

function on_entity_died( event )
    event_destroy_entity(event.entity)
end

function on_tick( event )
    tick_all_actors(event.tick)
    Homeworld:tick(event.tick)
    if ModuloTimer(20) then
    	Fishery.update_fish_chunks()
    end
end

function on_player_created( event )
    local player = game.players[event.player_index]
    player.insert{
        name = "homeworld_portal",
        count = 1
   }
   player.insert{
       name = "portable-electronics",
       count = 1
   }
end

function on_resource_depleted( event )
	if event.entity.name == "sand-source" then
		event.entity.surface.set_tiles{{name = "dirt-dark", position = event.entity.position}}
	end
end

function before_player_mined_item( event )
    event_destroy_entity(event.entity)
end

function before_robot_mined( event )
    event_destroy_entity(event.entity)
end

function event_create_entity( entity )
    -- TODO(luke): move this out of control.lua, obviously the best place for this would be in farm.lua
    -- and that will require some changes to the actor system.
	if entity.name == 'entity-ghost' and entity.ghost_prototype and entity.ghost_prototype.name then
		local ghost_name = entity.ghost_prototype.name
		
		if ghost_name == "farm_01" or ghost_name == "farm_02" or ghost_name == "farm_03" or ghost_name == "farm_full" then
			--Get position of entity
			local position = entity.position
			local surface_name = entity.surface.name
			local name = entity.name
			
			--Destroy old farm
			entity.destroy()
			
			--Create proper entity
			local new_farm = game.surfaces['nauvis'].create_entity{
               name = "entity-ghost",
               position = position,
               force = game.forces.player,
			   inner_name = "stone-furnace"
            }
			
			create_entity_actor(new_farm)
			return
		end
	end
	create_entity_actor(entity)
end

function event_destroy_entity( entity )
    destroy_entity_actor(entity)
end

script.on_init(on_mod_init)
script.on_load(on_mod_load)
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_entity_died, on_entity_died)
script.on_event(defines.events.on_player_created, on_player_created)
script.on_event(defines.events.on_preplayer_mined_item, before_player_mined_item)
script.on_event(defines.events.on_robot_pre_mined, before_robot_mined)
script.on_event(defines.events.on_resource_depleted, on_resource_depleted)
script.on_event(defines.events.on_tick, on_tick)

remote.add_interface("homeworld", {
	get_homeworld = function()
      return Homeworld
	end,

   show_gui = function()
      Homeworld:show_gui(game.local_player.index)
   end,

   hide_gui = function( player_index )
      Homeworld:hide_gui(game.local_player.index)
   end,

   add_item = function( name, count )
      Homeworld:insert_item{name = name, count = count}
   end,

   remove_item = function( name, count )
      Homeworld:remove_item{name = name, count = count}
   end,
})
