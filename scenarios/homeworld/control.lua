require "need_defines"

objective = "Your species is on the brink of extinction. Supply your homeworld with resources.\n1. Build a radar to contact the homeworld.\n2. Collect fish and wood."

--[[ HOW TO CREATE NEEDS:

The needs prototype is a list of tables, each indicating a tier.
Each tier needs the following keys:

name = The name of the tier.

upgrade_population = The population needed to upgrade to the next tier.

downgrade_population = When the population falls below this value they downgrade to the lower tier. (Tier 1 is always -1)

grow_rate = How fast the population grows, this takes a minimum and a maximum. Values are chosen randomly in this range.

decline_rate = How fast the population declines, this takes a minimum and a maximum. Values are chosen randomly in this range.

needs = The list of needs that need to be met for this tier (see below for more on needs.)

rewards = The list of rewards placed in the portal when this tier upgrades. This requires a list of tables, each table containing a list of items.
          One set of items are chosen randomly and placed in the portal.

------------------------------------

The needs table contains a list of tables, each indicating the item needed and how fast it is consumed:

item = The name of the item needed (see Program Files/Factorio/data/base/prototypes/items for a list of item names)

max_per_min = This indicates the maximum production per minute of the item the player needs to reach to fully satisfy the need.
              For example; if there is a need for 'raw-fish', the max_per_min is 800 and the upgrade_population is 5000. Then
              when the population is at 4999 the player will need to be producing 800 raw fish per minute to fully satisfy the need.
              If the population is at half (i.e 2500) then the player will need to be producing 400 per minute to fully satisfy the need.

consumption_duration = How fast the items are consumed by the population. This does not change how much the player needs to be producing the
                       item per minute. Possible values are SUPER_FAST, VERY_FAST, FAST, NORMAL, SLOW, VERY_SLOW, SUPER_SLOW and NEVER.
                       Specifying NEVER indicates the the item is never consumed, but the need must be 100% satisfied before the population
                       can upgrade.

------------------------------------

The rewards table takes a list of tables that contain a list of items. One of these are chosen at random when the population upgrades.

item = The item name.
amount = The amount of that item rewarded.

]]

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