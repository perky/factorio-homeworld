SECONDS = 60
MINUTES = 3600
GAME_DAY = 25000

DIRECTION_OFFSET = {
   [defines.direction.east] = {x = 1, y = 0},
   [defines.direction.south] = {x = 0, y = 1},
   [defines.direction.west] = {x = -1, y = 0},
   [defines.direction.north] = {x = 0, y = -1}
}

DIRECTION_INVERSE = {
    [defines.direction.east] = defines.direction.west,
    [defines.direction.west] = defines.direction.east,
    [defines.direction.north] = defines.direction.south,
    [defines.direction.south] = defines.direction.north
}
