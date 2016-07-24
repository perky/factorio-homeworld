--[[
    NOTE(luke):
    Each need has a 'max_per_day' value. This indicates the maximum production per game day of an item a player
    needs to reach to upgrade that tier.
]]

return {
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
                {name = "firearm-bullet-magazine", count = 300},
                {name = "light-armor", count = 3}
            },
            {
                {name = "heavy-armor", count = 4},
                {name = "grenade", count = 16}
            },
            {
                {name = "poison-capsule", count = 2},
                {name = "piercing-rounds-magazine", count = 200}
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
        max_decline_rate = -21,
        needs = {
            {
                item = "raw-fish",
                max_per_day = 6000
            },
            {
                item = "raw-wood",
                max_per_day = 200
            },
            {
                item = "furniture",
                max_per_day = 800
            },
            {
                item = "bread",
                max_per_day = 8500
            }
        },
        rewards = {
            {
                {name = "flame-thrower-ammo", count = 500},
                {name = "heavy-armor", count = 10}
            },
            {
                {name = "rocket", count = 10},
                {name = "grenade", count = 80}
            },
            {
                {name = "piercing-shotgun-shell", count = 200},
                {name = "piercing-rounds-magazine", count = 400}
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
        max_decline_rate = -26,
        needs = {
            {
                item = "raw-fish",
                max_per_day = 13000
            },
            {
                item = "furniture",
                max_per_day = 1500
            },
            {
                item = "bread",
                max_per_day = 11000
            },
            {
                item = "crude-oil-barrel",
                max_per_day = 1200
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
                {name = "grenade", count = 50}
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
        max_decline_rate = -41,
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
                item = "crude-oil-barrel",
                max_per_day = 4000
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
                {name = "rail", count = 500},
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
        max_decline_rate = -90,
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
                item = "solid-fuel",
                max_per_day = 6000
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
            }
        },
        rewards = {
            {
                {name = "rail", count = 500},
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
                {name = "rail", count = 1000},
            },
            {
                {name = "tank", count = 20},
                {name = "logistic-robot", count = 5000},
                {name = "construction-robot", count = 5000},
            },
            {
                {name = "alien-science-pack", count = 2000},
                {name = "science-pack-3", count = 5000},
                {name = "science-pack-2", count = 4000},
                {name = "science-pack-1", count = 3000},
            }
        }
    },
}
