function ModuloTimer( ticks )
	return (game.tick % ticks) == 0
end

function PrintToAllPlayers( text )
	for playerIndex = 1, #game.players do
		if game.players[playerIndex] ~= nil then
			game.players[playerIndex].print(text)
		end
	end
end

function SetGoalForAllPlayers( goalText )
	for playerIndex = 1, #game.players do
		if game.players[playerIndex] ~= nil then
			game.players[playerIndex].set_goal_description(goalText)
		end
	end
end

function transport_lines( belt )
    local lane_index = 0
    return function()
        lane_index = lane_index + 1
        if lane_index > 2 then
            return nil
        end
        local transport_line = belt.get_transport_line(lane_index)
        return lane_index, transport_line
    end
end

function FindTilesInArea( surface, area, tileNameFilter )
	local foundTiles = {}
	local aa = area[1]
	local bb = area[2]
	local width = bb.x - aa.x
	local height = bb.y - aa.y
	for _y = 0, height do
		for _x = 0, width do
			local x = aa.x + _x
			local y = aa.y + _y
			local tile = surface.get_tile(x, y)
			if tile.name == tileNameFilter then
				table.insert(foundTiles, tile)
			end
		end
	end
	return foundTiles
end

function FindTilePropertiesInArea( surface, area, tileNameFilter )
	local foundTiles = {}
	local aa = area[1]
	local bb = area[2]
	local width = bb.x - aa.x
	local height = bb.y - aa.y
	for _y = 0, height do
		for _x = 0, width do
			local pos = {
				x = aa.x + _x,
				y = aa.y + _y
			}
			local tile = surface.get_tile(pos.x, pos.y)
			if tile.name == tileNameFilter then
				table.insert(foundTiles, {
					name = tile.name,
					position = pos,
				})
			end
		end
	end
	return foundTiles
end

function PrettyNumber( number )
	if number < 1000 then
		return string.format("%i", number)
	elseif number < 1000000 then
		return string.format("%.1fk", (number/1000))
	else
		return string.format("%.1fm", (number/1000000))
	end
end

--[[
	Iterator for looping over an area.
	returns the x, y co-ordiantes for each position in an area.
	example:
		area = {{0, 0}, {10, 20}}
		for x, y in iarea(area) do
		end
]]
function iarea( area )
	local aa = area[1]
	local bb = area[2]
	local _x = aa.x
	local _y = aa.y
    local reached_end = false
	return function()
        if reached_end then
            return nil
        end
		local x = _x
		local y = _y
		_x = _x + 1
		if _x > bb.x then
			_x = aa.x
			_y = _y + 1
			if _y > bb.y then
				reached_end = true
			end
		end
		return x, y
	end
end

function SquareArea( origin, radius )
	return {
		{x=origin.x - radius, y=origin.y - radius},
		{x=origin.x + radius, y=origin.y + radius}
	}
end

function RemapNumber(number, from1, to1, from2, to2)
	return (number - from1) / (to1 - from1) * (to2 - from2) + from2
end

function table.random_value( tbl )
	local index = math.random(1, #tbl)
	return tbl[index]
end

function table.shuffle( tbl )
	local rand = math.random
	local count = #tbl
	local dieRoll
	for i = count, 2, -1 do
		dieRoll = rand(i)
		tbl[i], tbl[dieRoll] = tbl[dieRoll], tbl[i]
	end
end

function table.where( tbl, predicate )
    local result = {}
    for index, value in ipairs(tbl) do
        if predicate(value) then
            table.insert(result, value)
        end
    end
    return result
end

function table.except(source, exception)
    local result = {}
    for key, value in ipairs(source) do
        local exception_exists = false
        for key2, value2 in ipairs(exception) do
            if value2 == value then
                exception_exists = true
                break
            end
        end
        if not exception_exists then
            table.insert(result, value)
        end
    end
    return result
end

function DistanceSqr( p1, p2 )
	local dx = p2.x - p1.x
	local dy = p2.y - p1.y
	return dx*dx + dy*dy
end

function GetNearest( objects, point )
	if #objects == 0 then
		return nil
	end

	local maxDist = math.huge
	local nearest = objects[1]
	for _, obj in ipairs(objects) do
		local dist = DistanceSqr(point, obj.position)
		if dist < maxDist then
			maxDist = dist
			nearest = obj
		end
	end

	return nearest
end

function nearest_players( params )
    local origin = params.origin
    local max_distance = params.max_distance or 2
    local list = {}

    for playerIndex = 1, #game.players do
        local player = game.players[playerIndex]
        local distance = util.distance(player.position, origin)
        if distance <= max_distance then
            table.insert(list, player)
        end
    end

    return list
end
