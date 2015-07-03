require("defines")
require("homeworld_defines")
require("helpers.helpers")
require("helpers.gui_helpers")
require("helpers.coroutine_helpers")
require("actors.arcology_actor")
require("actors.homeworld_actor")
require("actors.fishery_actor")
require("actors.portal_actor")
require("actors.farm_actor")
require("actors.sawmill_actor")
require("water_drain")

actors = {}
homeworld = nil
main_portal = nil

local function AddActor( actor )
	table.insert(actors, actor)
	actor:Init()
	return actor
end

local function OnGameInit()
	modHasInitialised = true
end

local function OnGameLoad()
	if not modHasInitialised then
		if glob.actors then
			for i, glob_actor in ipairs(glob.actors) do
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
			WaitForTicks(1)
			for _, actor in ipairs(actors) do
				if actor.OnLoad then
					actor:OnLoad()
				end
			end
		end)
		modHasInitialised = true
	end

	if glob.guiButtonCallbacks then
		GUI.buttonCallbacks = glob.guiButtonCallbacks
	end
end

local function OnGameSave()
	glob.actors = actors
	glob.guiButtonCallbacks = GUI.buttonCallbacks
end

local function OnPlayerCreated( playerindex )
	if playerindex ~= 1 then return end

	local player = game.getplayer(playerindex)
	--player.insert{name = "fishery", count = 10}
	--player.insert{name = "offshore-pump", count = 10}
	player.insert{name = "raw-fish", count = 300}
	--[[
	player.insert{name = "homeworld_portal", count = 1}
	player.insert{name = "wood", count = 300}
	
	player.insert{name = "fishery", count = 10}
	player.insert{name = "sawmill", count = 10}
	player.insert{name = "farm", count = 10}
	]]--
	homeworld = AddActor( Homeworld.CreateActor() )

	-- Spawn Portal.
	local portalSpawnPos = game.findnoncollidingposition("homeworld_portal", game.player.position, 30, 1)
	local portalEntity = game.createentity({name = "homeworld_portal", position = portalSpawnPos, force = game.forces.player})
	local portal = Portal.CreateActor{entity = portalEntity, homeworld = homeworld}
	AddActor(portal)
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
		if actor and actor.entity and actor.entity.equals(entity) then
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
		if actor.open_gui_on_selected then
			local openedEntity = game.player.opened
			if openedEntity ~= nil and openedEntity.equals(actor.entity) and not actor.gui_opened then
				actor:OpenGUI()
				actor.gui_opened = true
			elseif actor.gui_opened and openedEntity == nil then
				actor:CloseGUI()
				actor.gui_opened = false
			end
		end
	end

	--WaterDrain.OnTick()
end

local function OnChunkGenerated( area )
	--[[
	local portals = game.findentitiesfiltered{area = area, name = "homeworld_portal"}
	for _, entity in ipairs(portals) do
		local portal = AddActor( PortalActor(entity) )
		portal.homeworld = homeworld
	end
	]]--
end

local function OnResourceDepleted( resource )
	if resource.name == "sand-source" then
		game.settiles{{name = "dirt-dark", position = resource.position}}
	end
end

game.oninit(OnGameInit)
game.onload(OnGameLoad)
game.onsave(OnGameSave)
game.onevent(defines.events.onbuiltentity, function(event) OnPlayerBuiltEntity(event.createdentity) end)
game.onevent(defines.events.onentitydied, function(event) OnEntityDestroy(event.entity) end)
game.onevent(defines.events.onpreplayermineditem, function(event) OnEntityDestroy(event.entity) end)
game.onevent(defines.events.onrobotpremined, function(event) OnEntityDestroy(event.entity) end)
game.onevent(defines.events.onplayercreated, function(event) OnPlayerCreated(event.playerindex) end)
game.onevent(defines.events.onchunkgenerated, function(event) OnChunkGenerated(event.area) end)
game.onevent(defines.events.ontick, OnTick)
game.onevent(defines.events.onresourcedepleted, function(event) OnResourceDepleted(event.entity) end)

local function terraformRoutine(maxStep)
	local current = {x=game.player.position.x, y=game.player.position.y}
	local stepCount = 1
	local totalCount = 0
	local right, down, left, up = 1, 2, 3, 4
	local offsetsMap = {
		[right] = {x=1, y=0},
		[down]  = {x=0, y=1},
		[left]  = {x=-1, y=0},
		[up]    = {x=0, y=-1}
	}
	local state = right
	local offset = offsetsMap[state]

	while totalCount < maxStep do
		for step = 0, stepCount do
			local p1 = current
			local p2 = {current.x - 1, current.y - 1}
			local p3 = {current.x, current.y - 1}
			local p4 = {current.x - 1, current.y}
			local p5 = {current.x + 1, current.y + 1}
			local p6 = {current.x + 1, current.y}
			local p7 = {current.x, current.y + 1}
			game.settiles{
				{name="dirt-dark", position=p1},
				{name="dirt-dark", position=p2},
				{name="dirt-dark", position=p3},
				{name="dirt-dark", position=p4},
				{name="dirt-dark", position=p5},
				{name="dirt-dark", position=p6},
				{name="dirt-dark", position=p7}
			}
			current.x = current.x + offset.x
			current.y = current.y + offset.y
			totalCount = totalCount + 1
			WaitForTicks(2)
			if totalCount >= maxStep then
				break
			end
		end
		stepCount = stepCount + 1
		state = state + 1
		if state > up then
			state = right
		end
		offset = offsetsMap[state]
	end
end

remote.addinterface("homeworld", {
	SetPopulation = function(amount)
		homeworld.population = amount
	end,

	InsertItem = function(itemName, amount)
		homeworld:InsertItem(itemName, amount)
	end,

	Online = function()
		homeworld.grace_period = 1
	end,

	FillAllNeeds = function()
		for _, need in ipairs(needs_prototype[homeworld.population_tier].needs) do
			local count = homeworld:GetNeedItemCount(need)
			homeworld:InsertItem(need.item, count)
		end
	end,

	Terraform = function(maxStep)
		StartCoroutine(terraformRoutine, maxStep)
	end,

	InsertItemToPortal = function(item, count)
		if main_portal then
			local inventory = main_portal.entity.getinventory(1)
			local stack = {item = item, count = count}
			if inventory.caninsert(stack) then
				inventory.insert(stack)
			end
		end
	end
})