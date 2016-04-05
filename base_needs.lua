--[[
	NOTE(luke):
	Each need has a 'max_per_min' value. This indicates the maximum production per minute of an item a player
	needs to reach to upgrade that tier. The consumption_duration indicates how long it takes to consume the need.
	The higher the duration the more items needed per capita.
	For example:
		if in tier 1 the max_per_min for fish is 1000 and the consumption duration is 10 minutes.
		The total count per capita would be `(max_per_min * (consumption_duration / MINUTES)) / upgrade_population`.
		In this case 0.8 per capita.
]]

needs_prototype =
{
	{
		name = "Tier 1",
		upgrade_population = 5000,
		downgrade_population = -1,
		max_growth_rate = 9,
		max_decline_rate = -8,
		needs = {
			{
				item = "raw-fish",
				max_per_day = 2000
			},
			{
				item = "raw-wood",
				max_per_day = 300
			}
		},
		rewards = {
			{
				{name = "basic-bullet-magazine", count = 300},
				{name = "basic-armor", count = 3}
			},
			{
				{name = "heavy-armor", count = 4},
				{name = "basic-grenade", count = 16}
			},
			{
				{name = "poison-capsule", count = 2},
				{name = "piercing-bullet-magazine", count = 200}
			},
			{
				{name = "shotgun-shell", count = 600}
			},
			{
				{name = "speed-module", count = 3}
			},
			{
				{name = "effectivity-module", count = 3}
			},
			{
				{name = "productivity-module", count = 3}
			},
		}
	},

	{
		name = "Tier 2",
		upgrade_population = 12000,
		downgrade_population = 3000,
		max_growth_rate = 15,
		max_decline_rate = -27,
		needs = {
			{
				item = "raw-fish",
				max_per_day = 7000
			},
			{
				item = "raw-wood",
				max_per_day = 300
			},
			{
				item = "furniture",
				max_per_day = 1000
			},
			{
				item = "bread",
				max_per_day = 9000
			}
		},
		rewards = {
			{
				{name = "flame-thrower-ammo", count = 500},
				{name = "heavy-armor", count = 10}
			},
			{
				{name = "rocket", count = 10},
				{name = "basic-grenade", count = 80}
			},
			{
				{name = "piercing-shotgun-shell", count = 200},
				{name = "piercing-bullet-magazine", count = 400}
			},
			{
				{name = "speed-module-2", count = 5},
				{name = "effectivity-module", count = 10},
			},
			{
				{name = "effectivity-module-2", count = 5},
				{name = "productivity-module", count = 10},
			},
			{
				{name = "productivity-module-2", count = 5},
				{name = "speed-module", count = 10},
			},
		}
	},

	{
		name = "Tier 3",
		upgrade_population = 27000,
		downgrade_population = 8000,
		max_growth_rate = 22,
		max_decline_rate = -30,
		needs = {
			{
				item = "raw-fish",
				max_per_day = 13000
			},
			{
				item = "furniture",
				max_per_day = 2000
			},
			{
				item = "bread",
				max_per_day = 13000
			},
			{
				item = "water-barrel",
				max_per_day = 3200
			},
			{
				item = "beer",
				max_per_day = 1500
			}
		},
		rewards = {
			{
				{name = "laser-turret", count = 100}
			},
			{
				{name = "express-transport-belt", count = 500},
				{name = "basic-grenade", count = 50}
			},
			{
				{name = "piercing-shotgun-shell", count = 800},
				{name = "solar-panel", count = 200}
			},
			{
				{name = "speed-module-3", count = 10},
				{name = "effectivity-module-2", count = 20},
			},
			{
				{name = "effectivity-module-3", count = 10},
				{name = "productivity-module-2", count = 20},
			},
			{
				{name = "productivity-module-3", count = 10},
				{name = "speed-module-2", count = 20},
			},
		}
	},

	{
		name = "Tier 4",
		upgrade_population = 50000,
		downgrade_population = 18000,
		max_growth_rate = 35,
		max_decline_rate = -45,
		needs = {
			{
				item = "raw-fish",
				max_per_day = 5000
			},
			{
				item = "luxury-meal",
				max_per_day = 7000
			},
			{
				item = "furniture",
				max_per_day = 3000
			},
			{
				item = "bread",
				max_per_day = 18000
			},
			{
				item = "water-barrel",
				max_per_day = 9600
			},
			{
				item = "beer",
				max_per_day = 3000,
			},
			{
				item = "building-materials",
				max_per_day = 4500
			},
			{
				item = "battery",
				max_per_day = 320
			}
		},
		rewards = {
			{
				{name = "straight-rail", count = 500},
				{name = "curved-rail", count = 250},
				{name = "speed-module-3", count = 1},
			},
			{
				{name = "express-transport-belt", count = 500},
				{name = "tank", count = 1},
				{name = "speed-module-3", count = 3},
			},
			{
				{name = "alien-science-pack", count = 100},
				{name = "logistic-robot", count = 300},
				{name = "construction-robot", count = 300},
			}
		}
	},

	{
		name = "Tier 5",
		upgrade_population = 100000,
		downgrade_population = 40000,
		max_growth_rate = 75,
		max_decline_rate = -105,
		needs = {
			{
				item = "luxury-meal",
				max_per_day = 27500
			},
			{
				item = "wine",
				max_per_day = 5500
			},
			{
				item = "portable-electronics",
				max_per_day = 120
			},
			{
				item = "building-materials",
				max_per_day = 1200
			},
			{
				item = "rocket",
				consume_once = true,
				count = 1000
			},
			{
				item = "seeder",
				consume_once = true,
				count = 500
			},
			{
				item = "seeder-module-01",
				consume_once = true,
				count = 750
			},
		},
		rewards = {
			{
				{name = "straight-rail", count = 250},
			},
			{
				{name = "tank", count = 2},
				{name = "logistic-robot", count = 500},
				{name = "construction-robot", count = 500},
			},
			{
				{name = "alien-science-pack", count = 200},
				{name = "science-pack-3", count = 500},
				{name = "science-pack-2", count = 400},
				{name = "science-pack-1", count = 300},
			}
		}
	},

	{
		name = "Tier 6",
		upgrade_population = 9900000,
		downgrade_population = 60000,
		max_growth_rate = 85,
		max_decline_rate = -125,
		needs = {
			{
				item = "portable-electronics",
				max_per_day = 300
			},
			{
				item = "terraformer",
				consume_once = true,
				count = 500
			},
			{
				item = "terraform-module-grass",
				consume_once = true,
				count = 1000
			},
			{
				item = "terraform-module-sand",
				consume_once = true,
				count = 1000
			},
			{
				item = "terraform-module-dirt",
				consume_once = true,
				count = 1000
			},
			{
				item = "seeder-module-03",
				consume_once = true,
				count = 1000
			},
			{
				item = "rocket-silo",
				consume_once = true,
				count = 1
			}
		},
		rewards = {
			{
				{name = "straight-rail", count = 3000},
				{name = "curved-rail", count = 1500},
			},
		}
	},
}
