require("helpers.helpers")
require("helpers.coroutine_helpers")

WaterDrain = {}

local MAX_WATER_BODY_SIZE = 10000
local SEARCH_OFFSET = 2
local DRAINED_TILE = "grass"
local WATER_BODY_TOO_BIG = -1
local SEARCH_INTERVAL = 10
local WATER_PER_TILE = 25
local SEDIMENT = {"stone", "stone", "stone", "stone-rock"}
local pumps = {}
local _pumpWater, _findWaterTiles

function WaterDrain.OnInit()
	water_drain_has_init = true
end

function WaterDrain.OnLoad()
	if not water_drain_has_init then
		water_drain_has_init = true
		if global.water_drain then
			pumps = global.water_drain.pumps
			for index, pump in ipairs(pumps) do
				pump.routine = coroutine.create(_pumpWater)
			end
		end
	end
end

function WaterDrain.OnSave()
	if not global.water_drain then
		global.water_drain = {}
	end
	global.water_drain.pumps = pumps
end

function WaterDrain.AddWaterDrainingPump( pumpEntity )
	local origin = pumpEntity.position
	local pump = {
		entity = pumpEntity,
		routine = coroutine.create(_pumpWater),
		deltaWater = 0,
		lastWaterAmount
	}
	table.insert(pumps, pump)
end

function WaterDrain.RemoveWaterDrainingPump( pumpEntity )
	for index, pump in ipairs(pumps) do
		if pump == pumpEntity then
			table.remove(pumps, index)
			break
		end
	end
end

function WaterDrain.OnTick()
	for _, pump in ipairs(pumps) do
		if pump.routine and pump.entity and pump.entity.valid then
			if not SafeResumeCoroutine(pump.routine, pump) then
				pump.routine = nil
			end
		else
			pump.routine = nil
		end
	end

	-- Clean up the pumps array.
	if ModuloTimer(1*MINUTES) then
		for i = #pumps, 1, -1 do
			local pump = pumps[i]
			if not pump.routine then
				table.remove(pumps, i)
			end
		end
	end
end

function WaterDrain.OnBuiltEntity( entity )
	if entity.valid and entity.name == "offshore-pump" then
		WaterDrain.AddWaterDrainingPump( entity )
	end
end

function WaterDrain.OnDestroyEntity( entity )
	if entity.valid and entity.name == "offshore-pump" then
		WaterDrain.RemoveWaterDrainingPump( entity )
	end
end

-- Private Methods.
_tileAtPosIsWater = function( surface, pos )
	local tile = surface.get_tile(pos.x, pos.y)
	if tile.name ~= "water" then
		game.player.print(tile.name)
	end
	return tile.name == "water"
end

_waterNearPos = function( surface, pos )
	local area = SquareArea(pos, 2)
	local nearbyWater = FindTilesInArea(surface, area, "water")
	if #nearbyWater > 0 then
		return true
	else
		return false
	end
end

_nearestWaterTile = function(surface, pos)
	local area = SquareArea(pos, 2)
	local nearbyWater = FindTilePropertiesInArea(surface, area, "water")
	if #nearbyWater > 0 then
		return GetNearest(nearbyWater, pos)
	else
		return nil
	end
end

_drainTilesInArea = function( surface, area )
	local newTiles = {}
	for x, y in iarea(area) do
		table.insert(newTiles, {name = DRAINED_TILE, position = {x, y}})
	end
	surface.set_tiles(newTiles)
end

_pumpWater = function( pump )
	if pump.fully_drained then
		return false, "lake is already drained"
	end

	local origin = pump.entity.position
	local surface = pump.entity.surface
	local counter, tileIndex = 0, 0
	local waterTiles, tileCount
	
	while pump.entity.valid and _waterNearPos(surface, origin) do
		local fluid_box = pump.entity.fluidbox[1]

		-- wait until the pump is pumping
		while not fluid_box do
			coroutine.yield(true)
			if pump.entity.valid then
				fluid_box = pump.entity.fluidbox[1]
			else
				return false
			end
		end
		if not pump.entity.valid then
			return false
		end

		-- Check how much water the pump is taking.
		if not pump.lastWaterAmount then
			pump.lastWaterAmount = 0
		end
		if pump.entity.neighbours[1] and pump.entity.neighbours[1].fluidbox[1] then
			local waterAmount = pump.entity.neighbours[1].fluidbox[1].amount
			if waterAmount < 1 then
				pump.deltaWater = pump.deltaWater + (waterAmount / 10)
			else
				local delta = math.abs(waterAmount - pump.lastWaterAmount)
				local epsilon = 0.0001
				if delta > 0.0 and delta < epsilon then
					delta = epsilon
				end
				pump.deltaWater = pump.deltaWater + delta
			end
			pump.lastWaterAmount = waterAmount
		end
 		
		if pump.deltaWater >= WATER_PER_TILE then
			pump.deltaWater = 0

			if counter == 0 or (counter % SEARCH_INTERVAL) == 0 then
				-- Find all the water tiles in a body of water
				local nearestWaterTile = _nearestWaterTile(surface, origin)
				waterTiles = _findWaterTiles(nearestWaterTile.position, surface)
				-- End the routine if the water body is too big.
				if type(waterTiles) == "number" and waterTiles == WATER_BODY_TOO_BIG then
					return false
				end
				tileCount = #waterTiles
				-- End the routine if no water tiles are found
				if tileCount == 0 then break end
				tileIndex = tileCount
			end

			-- Replace the tiles, in backwards order, with dirt.
			local tilePos = waterTiles[tileIndex]
			counter = counter + 1
			tileIndex = tileIndex - 1
			if tileIndex == 0 then break end

			if tilePos then
				local tile = surface.get_tile(tilePos.x, tilePos.y)
				if tile and tile.valid and (tile.name == "deepwater" or tile.name == "water") then
					local area = SquareArea(tilePos, SEARCH_OFFSET-1)
					_drainTilesInArea(surface, area)
					-- create and destroy any entity to update the map (stole this idea from landfill :D)
					local sediment = SEDIMENT[math.random(1, #SEDIMENT)]
					local stone = surface.create_entity({name = sediment, position = tilePos, force = game.forces.neutral})
					if math.random(0, 10) ~= 0 then
						stone.destroy()
					end
				end
			end
		end
		coroutine.yield(true)
	end

	-- Water fully drained, disable pump.
	if pump.entity.valid then
		pump.entity.active = false
		-- clear all remaining water tiles in area.
		_drainTilesInArea(surface, SquareArea(origin, 3))
	end
	pump.fully_drained = true
end

_getKey = function( pos )
	return (MAX_WATER_BODY_SIZE * pos.y) + pos.x
end

_findWaterTiles = function( pos, surface )
	local nodeQueue = {pos}
	local visited = {}
	local waterTiles = {}
	while #nodeQueue > 0 do
		local node = nodeQueue[1]
		table.remove(nodeQueue, 1)
		local tile = surface.get_tile(node.x, node.y)
		
		if tile.name == "water" or tile.name == "deepwater" and not visited[_getKey(node)] then
			visited[_getKey(node)] = true
			table.insert(waterTiles, node)
			local west =  {x = node.x-SEARCH_OFFSET, y = node.y}
			local east =  {x = node.x+SEARCH_OFFSET, y = node.y}
			local north = {x = node.x, 			     y = node.y-SEARCH_OFFSET}
			local south = {x = node.x, 			     y = node.y+SEARCH_OFFSET}
			if not visited[_getKey(west)] then
				table.insert(nodeQueue, west)
			end
			if not visited[_getKey(east)] then
				table.insert(nodeQueue, east)
			end
			if not visited[_getKey(north)] then
				table.insert(nodeQueue, north)
			end
			if not visited[_getKey(south)] then
				table.insert(nodeQueue, south)
			end
		end

		if #waterTiles % 100 == 0 then
			coroutine.yield(true)
		end
		if #waterTiles > MAX_WATER_BODY_SIZE then
			return WATER_BODY_TOO_BIG
		end
	end

	return waterTiles
end