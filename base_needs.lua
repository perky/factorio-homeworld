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
				max_per_day = 600
			},
			{
				item = "raw-wood",
				max_per_day = 300
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
		max_growth_rate = 15,
		max_decline_rate = -17,
		needs = {
			{
				item = "raw-fish",
				max_per_day = 7000
			},
			{
				item = "bread",
				max_per_day = 9000
			},
			{
				item = "furniture",
				max_per_day = 1000
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
		max_growth_rate = 19,
		max_decline_rate = -20,
		needs = {
			{
				item = "raw-fish",
				max_per_day = 13000
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
			},
			{
				item = "furniture",
				max_per_day = 3000
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
		max_growth_rate = 35,
		max_decline_rate = -40,
		needs = {
			{
				item = "luxury-meal",
				max_per_day = 7000
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
		max_growth_rate = 75,
		max_decline_rate = -85,
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
		max_growth_rate = 75,
		max_decline_rate = -85,
		needs = {
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
				{item = "straight-rail", amount = 250},
			},
		}
	},
}
