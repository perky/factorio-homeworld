local curry = fun.curry

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

function util.modulo_timer( ticks )
	return (game.tick % ticks) == 0
end

function util.print_to_player( player, text )
  player.print(text)
end

function util.print_to_all_players( text )
  fun.for_each(game.players, curry(util.print_to_player, text))
end

function util.itransport_lines( belt )
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

function util.pretty_number( number )
	if number < 1000 then
		return string.format("%i", number)
	elseif number < 1000000 then
		return string.format("%.1fk", (number/1000))
	else
		return string.format("%.1fm", (number/1000000))
	end
end

function util.inverse_lerp(number, from1, to1, from2, to2)
	return (number - from1) / (to1 - from1) * (to2 - from2) + from2
end

function util.distance_sqr( p1, p2 )
  local dx = p2.x - p1.x
	local dy = p2.y - p1.y
	return dx*dx + dy*dy
end

function util.get_nearest( objects, point )
  local distance = curry(util.distance_sqr, point)
  return fun.best(objects, function(a, b)
    return distance(a) < distance(b)
  end)
end

function util.nearest_players( point, radius )
  return fun.filter(game.players, function(player)
    return util.distance_sqr(player, point) <= (radius or 2)
  end)
end

function util.square_area( origin, radius )
  return {
  	{x=origin.x - radius, y=origin.y - radius},
  	{x=origin.x + radius, y=origin.y + radius}
  }
end

function util.iarea( area )
  local aa, bb = area[1], area[2]
  local _x, _y = aa.x, aa.y
  local reached_end = false
  return function()
    if reached_end then
      return nil
    end
    local x, y = _x, _y
    _x = _x + 1
    if _x > bb.x then
      _x, _y = aa.x, _y+1
      if _y > bb.y then
        reached_end = true
      end
    end
    return x, y
  end
end
