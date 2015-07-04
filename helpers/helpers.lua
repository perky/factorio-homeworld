function ActorClass( name, class )
	_ENV[name] = class
	class.className = name
	class.CreateActor = function (existing) 
		local actor = existing or {}
		actor.className = name
		setmetatable(actor, {__index = class})
		return actor
	end
	return class
end

function FindTilesInArea( area, tileNameFilter )
	local foundTiles = {}
	local aa = area[1]
	local bb = area[2]
	local width = bb.x - aa.x
	local height = bb.y - aa.y
	for _y = 0, height do
		for _x = 0, width do
			local x = aa.x + _x
			local y = aa.y + _y
			local tile = game.gettile(x, y)
			if tile.name == tileNameFilter then
				table.insert(foundTiles, tile)
			end
		end
	end
	return foundTiles
end

function FindTilePropertiesInArea( area, tileNameFilter )
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
			local tile = game.gettile(pos.x, pos.y)
			local tileProps = game.gettileproperties(pos.x, pos.y)
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
	return function()
		local x = _x
		local y = _y
		_x = _x + 1
		if _x > bb.x then
			_x = aa.x
			_y = _y + 1
			if _y > bb.y then
				return nil
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

function ShuffleTable( tbl )
	local rand = math.random
	local count = #tbl
	local dieRoll
	for i = count, 2, -1 do
		dieRoll = rand(i)
		tbl[i], tbl[dieRoll] = tbl[dieRoll], tbl[i]
	end
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
	for _, tile in ipairs(objects) do
		local dist = DistanceSqr(point, tile.position)
		if dist < maxDist then
			maxDist = dist
			nearest = tile
		end
	end

	return nearest
end