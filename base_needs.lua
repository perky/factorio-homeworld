--[[
	NOTE(luke): 
	Each need has a 'max_per_min' value. This indicates the maximum production per minute of an item a player
	needs to reach to upgrade that tier. The consumption_duration indicates how long it takes to consume the need.
	The higher the duration the more items needed per capita.
	For example: 
		if in tier 1 the max_per_min for fish is 1000 and the consumption duration is 10 minutes.
		The total amount per capita would be `(max_per_min * (consumption_duration / MINUTES)) / upgrade_population`.
		In this case 0.8 per capita.
]]

local SUPER_FAST= 3 * MINUTES
local VERY_FAST = 5 * MINUTES
local FAST 		= 10 * MINUTES
local NORMAL	= 15 * MINUTES
local SLOW 		= 20 * MINUTES
local VERY_SLOW = 30 * MINUTES
local SUPER_SLOW = 60 * MINUTES
local NEVER = -1
local durationLocaleKey = {
	[SUPER_FAST] = {"duration-super-fast"},
	[VERY_FAST] = {"duration-very-fast"},
	[FAST] = {"duration-fast"},
	[NORMAL] = {"duration-normal"},
	[SLOW] = {"duration-slow"},
	[VERY_SLOW] = {"duration-very-slow"},
	[SUPER_SLOW] = {"duration-super-slow"},
	[NEVER] = {"duration-never"},
}

needs_prototype =
{
	{
		name = "Tier 1", 
		upgrade_population = 5000,
		downgrade_population = -1,
		grow_rate = { min = 6, max = 9 },
		decline_rate = { min = 4, max = 8 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 800,
				consumption_duration = SUPER_FAST
			},
			{
				item = "raw-wood",
				max_per_min = 100,
				consumption_duration = FAST
			}
		},
		rewards = {
			{
				{item = "basic-bullet-magazine", amount = 300},
				{item = "basic-armor", amount = 3}
			},
			{
				{item = "heavy-armor", amount = 4},
				{item = "basic-grenade", amount = 16}
			},
			{
				{item = "poison-capsule", amount = 2},
				{item = "piercing-bullet-magazine", amount = 200}
			},
			{
				{item = "shotgun-shell", amount = 600}
			},
			{
				{item = "speed-module", amount = 3}
			},
			{
				{item = "effectivity-module", amount = 3}
			},
			{
				{item = "productivity-module", amount = 3}
			},
		}
	},

	{
		name = "Tier 2", 
		upgrade_population = 10000,
		downgrade_population = 3000,
		grow_rate = { min = 10, max = 15 },
		decline_rate = { min = 5, max = 17 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 1600,
				consumption_duration = VERY_FAST
			},
			{
				item = "bread",
				max_per_min = 1600,
				consumption_duration = FAST
			},
			{
				item = "furniture",
				max_per_min = 300,
				consumption_duration = SLOW
			}
		},
		rewards = {
			{
				{item = "flame-thrower-ammo", amount = 500},
				{item = "heavy-armor", amount = 10}
			},
			{
				{item = "rocket", amount = 10},
				{item = "basic-grenade", amount = 80}
			},
			{
				{item = "piercing-shotgun-shell", amount = 200},
				{item = "piercing-bullet-magazine", amount = 400}
			},
			{
				{item = "speed-module-2", amount = 5},
				{item = "effectivity-module", amount = 10},
			},
			{
				{item = "effectivity-module-2", amount = 5},
				{item = "productivity-module", amount = 10},
			},
			{
				{item = "productivity-module-2", amount = 5},
				{item = "speed-module", amount = 10},
			},
		}
	},

	{
		name = "Tier 3",
		upgrade_population = 25000,
		downgrade_population = 8000,
		grow_rate = { min = 10, max = 19 },
		decline_rate = { min = 5, max = 20 },
		needs = {
			{
				item = "raw-fish",
				max_per_min = 2000,
				consumption_duration = VERY_FAST
			},
			{
				item = "bread",
				max_per_min = 3000,
				consumption_duration = FAST
			},
			{
				item = "water-barrel",
				max_per_min = 500,
				consumption_duration = NORMAL
			},
			{
				item = "beer",
				max_per_min = 250,
				consumption_duration = FAST
			},
			{
				item = "furniture",
				max_per_min = 500,
				consumption_duration = SLOW
			}
		},
		rewards = {
			{
				{item = "laser-turret", amount = 100}
			},
			{
				{item = "express-transport-belt", amount = 500},
				{item = "basic-grenade", amount = 50}
			},
			{
				{item = "piercing-shotgun-shell", amount = 800},
				{item = "solar-panel", amount = 200}
			},
			{
				{item = "speed-module-3", amount = 10},
				{item = "effectivity-module-2", amount = 20},
			},
			{
				{item = "effectivity-module-3", amount = 10},
				{item = "productivity-module-2", amount = 20},
			},
			{
				{item = "productivity-module-3", amount = 10},
				{item = "speed-module-2", amount = 20},
			},
		}
	},

	{
		name = "Tier 4",
		upgrade_population = 50000,
		downgrade_population = 18000,
		grow_rate = { min = 20, max = 35 },
		decline_rate = { min = 10, max = 40 },
		needs = {
			{
				item = "luxury-meal",
				max_per_min = 1000,
				consumption_duration = NORMAL
			},
			{
				item = "water-barrel",
				max_per_min = 1400,
				consumption_duration = NORMAL
			},
			{
				item = "beer",
				max_per_min = 450,
				consumption_duration = FAST
			},
			{
				item = "building-materials",
				max_per_min = 700,
				consumption_duration = VERY_SLOW
			},
			{
				item = "battery",
				max_per_min = 50,
				consumption_duration = VERY_SLOW
			}
		},
		rewards = {
			{
				{item = "straight-rail", amount = 500},
				{item = "curved-rail", amount = 250},
				{item = "speed-module-3", amount = 1},
			},
			{
				{item = "express-transport-belt", amount = 500},
				{item = "tank", amount = 1},
				{item = "speed-module-3", amount = 3},
			},
			{
				{item = "alien-science-pack", amount = 100},
				{item = "logistic-robot", amount = 300},
				{item = "construction-robot", amount = 300},
			}
		}
	},

	{
		name = "Tier 5",
		upgrade_population = 100000,
		downgrade_population = 40000,
		grow_rate = { min = 30, max = 75 },
		decline_rate = { min = 20, max = 85 },
		needs = {
			{
				item = "luxury-meal",
				max_per_min = 4000,
				consumption_duration = FAST
			},
			{
				item = "wine",
				max_per_min = 820,
				consumption_duration = SLOW
			},
			{
				item = "portable-electronics",
				max_per_min = 20,
				consumption_duration = SUPER_SLOW
			},
			{
				item = "building-materials",
				max_per_min = 1200,
				consumption_duration = VERY_SLOW
			},
			{
				item = "rocket",
				max_per_min = 1000,
				consumption_duration = NEVER
			},
			{
				item = "seeder",
				max_per_min = 500,
				consumption_duration = NEVER
			},
			{
				item = "seeder-module-01",
				max_per_min = 1000,
				consumption_duration = NEVER
			},
		},
		rewards = {
			{
				{item = "straight-rail", amount = 250},
			},
			{
				{item = "tank", amount = 2},
				{item = "logistic-robot", amount = 500},
				{item = "construction-robot", amount = 500},
			},
			{
				{item = "alien-science-pack", amount = 200},
				{item = "science-pack-3", amount = 500},
				{item = "science-pack-2", amount = 400},
				{item = "science-pack-1", amount = 300},
			}
		}
	},

	{
		name = "Tier 6",
		upgrade_population = 9900000,
		downgrade_population = 80000,
		grow_rate = { min = 30, max = 75 },
		decline_rate = { min = 20, max = 85 },
		needs = {
			{
				item = "terraformer",
				max_per_min = 500,
				consumption_duration = NEVER
			},
			{
				item = "terraform-module-grass",
				max_per_min = 1000,
				consumption_duration = NEVER
			},
			{
				item = "terraform-module-sand",
				max_per_min = 1000,
				consumption_duration = NEVER
			},
			{
				item = "terraform-module-dirt",
				max_per_min = 1000,
				consumption_duration = NEVER
			},
			{
				item = "seeder-module-03",
				max_per_min = 1000,
				consumption_duration = NEVER
			},
			{
				item = "rocket-silo",
				max_per_min = 1,
				consumption_duration = NEVER
			}
		},
		rewards = {
			{
				{item = "straight-rail", amount = 250},
			},
		}
	},
}