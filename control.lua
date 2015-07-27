actors = {}
homeworld = nil
main_portal = nil
world_surface = nil
difficulty = nil

require("defines")
require("util")
require("homeworld_defines")
require("homeworld_difficulty")
require("base_needs")
require("helpers.helpers")
require("helpers.gui_helpers")
require("helpers.coroutine_helpers")
require("actors.homeworld_actor")
require("actors.fishery_actor")
require("actors.portal_actor")
require("actors.farm_actor")
require("actors.sawmill_actor")
require("actors.terraformer_actor")
require("actors.seeder_actor")
require("water_drain")


local function AddActor( actor )
	table.insert(actors, actor)
	actor:Init()
	return actor
end

local function OnGameInit()
	difficulty = DIFFICULTY.NORMAL
	modHasInitialised = true
	homeworld = AddActor( Homeworld.CreateActor() )
	WaterDrain.OnInit()
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
				if glob_actor.className and ((glob_actor.entity and glob_actor.entity.valid) or (not glob_actor.entity)) then
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
	if global.difficulty then
		difficulty = global.difficulty
	end

	WaterDrain.OnLoad()
end

local function OnGameSave()
	global.actors = actors
	global.guiButtonCallbacks = GUI.buttonCallbacks
	global.difficulty = difficulty

	WaterDrain.OnSave()
end

local function SpawnHomeworldPortal( player )
	local surface = player.surface
	local portalSpawnPos = surface.find_non_colliding_position("homeworld_portal", player.position, 30, 1)
	local portalEntity = surface.create_entity({name = "homeworld_portal", position = portalSpawnPos, force = player.force})
	local portal = Portal.CreateActor{entity = portalEntity, homeworld = homeworld}
	AddActor(portal)
	portal:RegisterForRewards()
end

local intro_delegate = {}

function intro_delegate:OnSelectDifficulty( player_index, selected_difficulty )
	local player = game.get_player(player_index)
	player.gui.center.homeworld_difficulty_selection.destroy()
	difficulty = selected_difficulty
end

local function OnPlayerCreated( player_index )
	if player_index == 1 then
		local player = game.get_player(player_index)
		local surface = player.surface
		world_surface = surface

		SpawnHomeworldPortal(player)

		GUI.PushParent(player.gui.center)
		GUI.PushParent(GUI.Frame("homeworld_difficulty_selection", "Select Difficulty", GUI.VERTICAL))
		local tbl = GUI.PushParent(GUI.Table("difficulty_table", 2))
			for i, difficultyType in ipairs(DIFFICULTY_SORTED) do
				GUI.Button("difficulty_button_"..i, {difficultyType.locale_key.."-title"}, "OnSelectDifficulty", intro_delegate, difficultyType)
				GUI.PushParent(GUI.Flow("labels_"..i, GUI.VERTICAL))
					for line = 1, difficultyType.description_lines do
						GUI.Label("difficulty_label_"..line, {difficultyType.locale_key.."-description-"..line})
					end
				GUI.PopParent()
				GUI.TableSpacer(tbl, 2)
			end
		GUI.PopAll()
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
	elseif entity.name == "terraformer" then
		AddActor( Terraformer.CreateActor{entity = entity} )
	elseif entity.name == "seeder" then
		AddActor( Seeder.CreateActor{entity = entity} )
	end

	WaterDrain.OnBuiltEntity(entity)
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

	WaterDrain.OnDestroyEntity(entity)
end

local function OnTick()
	ResumeRoutines()
	for i = 1, #actors do
		local actor = actors[i]
		if actor.OnTick then
			actor:OnTick()
		end

		if actor.open_gui_on_selected then
			for playerIndex = 1, #game.players do
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

	if difficulty.finite_water then
		WaterDrain.OnTick()
	end
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

	SetNeedsPrototype = function( other_needs_prototype )
		needs_prototype = other_needs_prototype
	end
})