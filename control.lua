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
require("actors.portal")

register_entity_actor(Sawmill, "sawmill")
register_entity_actor(Farm, "farm")
register_entity_actor(Fishery, "fishery")
register_entity_actor(Seeder, "seeder")
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

--[[
local function AddActor( actor )
	table.insert(actors, actor)
	actor:Init()
	return actor
end

local function OnGameInit()
	modHasInitialised = true
	homeworld = AddActor( Homeworld.CreateActor() )
end

local function AfterGameLoad()
	for _, actor in ipairs(actors) do
		if actor.OnLoad then
			actor:OnLoad()
		end
	end

	-- Recreate homeworld if it does not exist.
	if not homeworld then
		if game.player.gui.top.homeworld_button then
			game.player.gui.top.homeworld_button.destroy()
		end
		if game.player.gui.left.homeworld_gui then
			game.player.gui.left.homeworld_gui.destroy()
		end
		homeworld = AddActor( Homeworld.CreateActor() )
	end
end

local function OnGameLoad()
	if not modHasInitialised then
		world_surface = game.players[1].surface

		if global.actors then
			for i, glob_actor in ipairs(global.actors) do
				if glob_actor.className then
					local class = _ENV[glob_actor.className]
					local actor = class.CreateActor(glob_actor)
					table.insert(actors, actor)
					if glob_actor.className == "Homeworld" then
						homeworld = actor
					elseif glob_actor.className == "Portal" and not main_portal then
						main_portal = actor
					end

				end
			end
		end

		-- defer the loading of actors, so that we aren't changing game state here.
		StartCoroutine(function()
			WaitForTicks(1*SECONDS)
			AfterGameLoad()
		end)

		modHasInitialised = true
	end

	if global.guiButtonCallbacks then
		GUI.buttonCallbacks = global.guiButtonCallbacks
	end
end

local function OnGameSave()
	global.actors = actors
	global.guiButtonCallbacks = GUI.buttonCallbacks
end

local function SpawnHomeworldPortal( player )
	local surface = player.surface
	local portalSpawnPos = surface.find_non_colliding_position("homeworld_portal", player.position, 30, 1)
	local portalEntity = surface.create_entity({name = "homeworld_portal", position = portalSpawnPos, force = player.force})
	local portal = Portal.CreateActor{entity = portalEntity, homeworld = homeworld}
	AddActor(portal)
	portal:RegisterForRewards()
end

local function OnPlayerCreated( player_index )
	if player_index == 1 then
		local player = game.get_player(player_index)
		local surface = player.surface
		world_surface = surface

		SpawnHomeworldPortal(player)
	end
end

local function OnPlayerBuiltEntity( entity )
	if entity.name == "fishery" then
		AddActor( Fishery.CreateActor{entity = entity} )
	elseif entity.name == "sawmill" then
		AddActor( Sawmill.CreateActor{entity = entity} )
	elseif entity.name == "homeworld_portal" then
		local portal = Portal.CreateActor{entity = entity, homeworld = homeworld}
		AddActor(portal)
	elseif entity.name == "farm" then
		AddActor( Farm.CreateActor{entity = entity} )
	elseif entity.name == "radar" then
		homeworld:OnRadarBuilt(entity)
	end
	--WaterDrain.OnBuiltEntity(entity)
end

local function OnEntityDestroy( entity )
	for i=1, #actors do
		local actor = actors[i]
		if actor and actor.entity and actor.entity == entity then
			table.remove(actors, i)
			if actor.OnDestroy then
				actor:OnDestroy()
			end
			return
		end
	end

	if entity.name == "radar" then
		homeworld:OnRadarDestroy(entity)
	end
end

local function OnTick()
	ResumeRoutines()
	for i = 1, #actors do
		local actor = actors[i]
		if actor.OnTick then
			actor:OnTick()
		end

		for playerIndex = 1, #game.players do
			if actor.open_gui_on_selected then
				if not actor.gui_opened then
					actor.gui_opened = {}
				end
				local player = game.players[playerIndex]
				local openedEntity = player.opened
				if openedEntity ~= nil and openedEntity == actor.entity and not actor.gui_opened[playerIndex] then
					actor:OpenGUI(playerIndex)
					actor.gui_opened[playerIndex] = true
				elseif actor.gui_opened[playerIndex] and openedEntity == nil then
					actor:CloseGUI(playerIndex)
					actor.gui_opened[playerIndex] = false
				end
			end
		end
	end

	--WaterDrain.OnTick()
end

local function OnResourceDepleted( resource )
	if resource.name == "sand-source" then
		world_surface.set_tiles{{name = "dirt-dark", position = resource.position}}
	end
end

game.on_init(OnGameInit)
game.on_load(OnGameLoad)
game.on_save(OnGameSave)
game.on_event(defines.events.on_built_entity, function(event) OnPlayerBuiltEntity(event.created_entity) end)
game.on_event(defines.events.on_entity_died, function(event) OnEntityDestroy(event.entity) end)
game.on_event(defines.events.on_preplayer_mined_item, function(event) OnEntityDestroy(event.entity) end)
game.on_event(defines.events.on_robot_pre_mined, function(event) OnEntityDestroy(event.entity) end)
game.on_event(defines.events.on_player_created, function(event) OnPlayerCreated(event.player_index) end)
game.on_event(defines.events.on_tick, OnTick)
game.on_event(defines.events.on_resource_depleted, function(event) OnResourceDepleted(event.entity) end)

remote.add_interface("homeworld", {
	SpawnPortal = function( playerIndex )
		local player = game.players[playerIndex]
		SpawnHomeworldPortal(player)
	end,

	SetPopulation = function(amount)
		homeworld.population = amount
	end,

	InsertItem = function(itemName, amount)
		homeworld:InsertItem(itemName, amount)
	end,

	SetHomeworldOnline = function()
		if main_portal then
			main_portal:OnHomeworldOnline()
		end
	end,

	FillAllNeeds = function()
		for _, need in ipairs(needs_prototype[homeworld.population_tier].needs) do
			local count = homeworld:GetNeedItemCount(need)
			homeworld:InsertItem(need.item, count)
		end
	end,

	RegisterPortal = function()
		main_portal:RegisterForRewards()
	end,

	AddRewardToMainPortal = function(reward)
		PrintToAllPlayers(serpent.block(reward))
		if main_portal then
			main_portal:InsertReward(reward)
		end
	end,

	GetHomeworld = function ()
		return homeworld
	end,
})
]]--
