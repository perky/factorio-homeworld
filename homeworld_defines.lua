HOMEWORLD_EVENTS = {}
HOMEWORLD_EVENTS.HOMEWORLD_ONLINE = game.generate_event_name()
HOMEWORLD_EVENTS.ON_REWARD = game.generate_event_name()

SECONDS = 60
MINUTES = 3600
GAME_DAY = 25000

RIGHT, DOWN, LEFT, UP = 1, 2, 3, 4
OFFSET_MAP = {
	[RIGHT] = {x=1, y=0},
	[DOWN]  = {x=0, y=1},
	[LEFT]  = {x=-1, y=0},
	[UP]    = {x=0, y=-1}
}

HOMEWORLD_PORTAL_EID = "homeworld_portal_smart"