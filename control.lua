require("defines")
require("util")
require("homeworld_defines")
require("helpers.assertion")
require("helpers.actor")
require("helpers.misc_helpers")
require("helpers.gui_helpers")
require("base_needs")
require("homeworld_logic")
require("actors.sawmill")
require("actors.farm")
require("actors.fishery")
require("actors.seeder")
require("actors.terraformer")
require("actors.portal")

register_entity_actor(Sawmill, "sawmill")
register_entity_actor(Farm, "farm")
register_entity_actor(Fishery, "fishery")
register_entity_actor(Seeder, "seeder")
register_entity_actor(Terraformer, "terraformer")
register_entity_actor(Portal, "homeworld_portal")

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
end

function on_player_created( event )
    local player = game.get_player(event.player_index)
    player.insert{
        name = "sawmill",
        count = 10
    }
    player.insert{
        name = "farm",
        count = 30
    }
    player.insert{
        name = "fishery",
        count = 30
    }
    player.insert{
        name = "raw-fish",
        count = 1000
    }
    player.insert{
        name = "raw-wood",
        count = 1000
    }
    player.insert{
        name = "homeworld_portal",
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
    create_entity_actor(entity)
end

function event_destroy_entity( entity )
    destroy_entity_actor(entity)
end

script.on_init(on_mod_init)
script.on_load(on_mod_load)
script.on_event(defines.events.on_built_entity, on_built_entity)
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
