require("helpers.helpers")
require("helpers.coroutine_helpers")

WaterDrain = {}

local MAX_WATER_BODY_SIZE = 10000
local SEARCH_OFFSET = 2
local DRAINED_TILE = "grass"
local WATER_BODY_TOO_BIG = -1
local SEARCH_INTERVAL = 10
local WATER_PER_TILE = 1
local pumps = {}
local _pumpWater, _findWaterTiles, _findWaterTiles2

function WaterDrain.AddWaterDrainingPump( pumpEntity )
	local origin = pumpEntity.position
	local pump = {
		entity = pumpEntity,
		routine = coroutine.create(_pumpWater),
		lastFluidAmount = 0,
		deltaWater = 0
	}
	table.insert(pumps, pump)
end

function WaterDrain.OnTick()
	for _, pump in ipairs(pumps) do
		if pump.routine then
			if not SafeResumeCoroutine(pump.routine, pump) then
				game.player.print("Water reserve fully drained")
				pump.routine = nil
			end
		end
	end
end

function WaterDrain.OnBuiltEntity( entity )
	if entity.name == "offshore-pump" then
		WaterDrain.AddWaterDrainingPump( entity )
	end
end

-- Private Methods.

_pumpWater = function( pump )
	if not pump.entity.active then return end

	-- Find shallow water tiles immediatly near pump
	local origin = pump.entity.position
	local surface = pump.entity.surface
	local area = SquareArea(origin, 1)
	local nearbyShallowWaterTiles = FindTilePropertiesInArea(surface, area, "water")
	if #nearbyShallowWaterTiles == 0 then return end
	local nearestShallowWaterTile = GetNearest(nearbyShallowWaterTiles, origin).position
	local counter, tileIndex = 0, 0
	local waterTiles, tileCount
	

	while (surface.get_tile(nearestShallowWaterTile.x, nearestShallowWaterTile.y).name == "water") do
		-- wait until the pump is pumping
		while not pump.entity.fluidbox[1] do
			coroutine.yield()
		end

		-- Check how much water the pump is taking.
		local currentWater = pump.entity.fluidbox[1].amount
		local deltaWater = math.abs(currentWater - pump.lastFluidAmount)
		pump.lastFluidAmount = currentWater
		pump.deltaWater = pump.deltaWater + deltaWater
		--if currentWater >= 10 then
		--	pump.entity.fluidbox[1] = {type = "water", amount = 0.01, temperature = 15}
		--	pump.deltaWater = 0
		--end

		if pump.deltaWater >= WATER_PER_TILE then
			game.player.print("removing water tile")
			pump.deltaWater = 0

			if counter == 0 or (counter % SEARCH_INTERVAL) == 0 then
				game.player.print("scanning water body")
				-- Find all the water tiles in a body of water
				waterTiles = _findWaterTiles2(nearestShallowWaterTile)
				-- End the routine if the water body is too big.
				if type(waterTiles) == "number" and waterTiles == WATER_BODY_TOO_BIG then
					game.player.print("water body too big")
					return
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
					local newTiles = {}
					for x, y in iarea(area) do
						table.insert(newTiles, {name = DRAINED_TILE, position = {x, y}})
					end
					surface.set_tiles(newTiles)
					-- create and destroy any entity to update the map (stole this idea from landfill :D)
					surface.create_entity({name = "stone", position = tilePos, force = game.forces.neutral}).destroy()
				end
			end
		end
		coroutine.yield()
	end

	-- Water fully drained, disable pump.
	pump.entity.active = false
end

_findWaterTiles = function( pos, visitedTiles )
	if not visitedTiles.positions then
		visitedTiles.positions = {}
		visitedTiles.map = {}
	end

	if #visitedTiles.positions > MAX_WATER_BODY_SIZE then
		return
	end
	--game.player.print(string.format("checking tile at x:%i y:%i", pos.x, pos.y))
	local tile = game.gettile(pos.x, pos.y)
	if not tile or not tile.valid then return end

	local key = MAX_WATER_BODY_SIZE * pos.x + pos.y
	if visitedTiles.map[key] then return end

	if tile.name == "water" or tile.name == "deepwater" then
		visitedTiles.map[key] = pos
		--game.settiles{{name = "dirt", position=pos}}
		table.insert(visitedTiles.positions, pos)
		coroutine.yield()

		_findWaterTiles({x=pos.x+SEARCH_OFFSET, y=pos.y}, visitedTiles)
		_findWaterTiles({x=pos.x-SEARCH_OFFSET, y=pos.y}, visitedTiles)
		_findWaterTiles({x=pos.x, y=pos.y-SEARCH_OFFSET}, visitedTiles)
		return _findWaterTiles({x=pos.x, y=pos.y+SEARCH_OFFSET}, visitedTiles)
	end
end

_getKey = function( pos )
	return (MAX_WATER_BODY_SIZE * pos.y) + pos.x
end

_findWaterTiles2 = function( pos )
	local nodeQueue = {pos}
	local visited = {}
	local waterTiles = {}
	while #nodeQueue > 0 do
		local node = nodeQueue[1]
		table.remove(nodeQueue, 1)
		local tile = game.gettile(node.x, node.y)
		--game.player.print(tile.name)
		
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
			coroutine.yield()
		end
		if #waterTiles > MAX_WATER_BODY_SIZE then
			game.player.print(#waterTiles)
			return WATER_BODY_TOO_BIG
		end
	end

	return waterTiles
end