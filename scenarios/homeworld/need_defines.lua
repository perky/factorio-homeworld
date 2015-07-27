-- DO NOT CHANGE. -------------
require "defines"

SECONDS 	= 60
MINUTES 	= 3600
GAME_DAY 	= 25000

SUPER_FAST 	= 3 * MINUTES
VERY_FAST  	= 5 * MINUTES
FAST 		= 10 * MINUTES
NORMAL	 	= 15 * MINUTES
SLOW 		= 20 * MINUTES
VERY_SLOW   = 30 * MINUTES
SUPER_SLOW  = 60 * MINUTES
NEVER       = -1

needs_prototype = nil
objective = ""
function set_needs_prototype()
	if needs_prototype ~= nil then
		remote.call("homeworld", "SetNeedsPrototype", needs_prototype)
	end
end
function player_created( player_index )
	if player_index == 1 then
		game.players[player_index].set_goal_description(objective)
	end
end
game.on_init(set_needs_prototype)
game.on_load(set_needs_prototype)
game.on_event(defines.events.on_player_created, function(event) player_created(event.player_index) end)
-------------------------------