--[[
    NOTE(luke):
    Each need has a 'max_per_day' value. This indicates the maximum production per game day of an item a player
    needs to reach to upgrade that tier.
]]

local rewards01 = {
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
    }
}

local rewards02 = {
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

return {
    {
        name = "Tier 1",
        upgrade_population = 3000,
        downgrade_population = -1,
        max_growth_rate = 9,
        max_decline_rate = -8,
        needs = {
            {
                item = "raw-wood",
                max_per_day = 100
            }
        },
        rewards = rewards01
    },
    {
        name = "Tier 2",
        upgrade_population = 6000,
        downgrade_population = 1500,
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
            },
            {
                item = "coal",
                max_per_day = 300
            }
        },
        rewards = rewards01
    },
    {
        name = "Tier 3",
        upgrade_population = 12000,
        downgrade_population = 3000,
        max_growth_rate = 13,
        max_decline_rate = -18,
        needs = {
            {
                item = "raw-fish",
                max_per_day = 6000
            },
            {
                item = "furniture",
                max_per_day = 800
            },
            {
                item = "coal",
                max_per_day = 600
            },
            {
                item = "bread",
                max_per_day = 6000
            }
        },
        rewards = rewards01
    },

    {
        name = "Tier 4",
        upgrade_population = 27000,
        downgrade_population = 8000,
        max_growth_rate = 22,
        max_decline_rate = -26,
        needs = {
            {
                item = "raw-fish",
                max_per_day = 14000
            },
            {
                item = "furniture",
                max_per_day = 1500
            },
            {
                item = "bread",
                max_per_day = 10000
            },
            {
                item = "crude-oil-barrel",
                max_per_day = 1000
            },
            {
                item = "beer",
                max_per_day = 400
            }
        },
        rewards = rewards02
    },
    {
        name = "Tier 5",
        upgrade_population = 50000,
        downgrade_population = 18000,
        max_growth_rate = 35,
        max_decline_rate = -41,
        needs = {
            {
                item = "luxury-meal",
                max_per_day = 6000
            },
            {
                item = "furniture",
                max_per_day = 3000
            },
            {
                item = "bread",
                max_per_day = 10000
            },
            {
                item = "crude-oil-barrel",
                max_per_day = 3000
            },
            {
                item = "beer",
                max_per_day = 1500,
            },
            {
                item = "building-materials",
                max_per_day = 3000
            },
            {
                item = "battery",
                max_per_day = 250
            }
        },
        rewards = rewards02
    },

    {
        name = "Tier 6",
        upgrade_population = 100000,
        downgrade_population = 40000,
        max_growth_rate = 65,
        max_decline_rate = -70,
        needs = {
            {
                item = "luxury-meal",
                max_per_day = 20000
            },
            {
                item = "beer",
                max_per_day = 4000,
            },
            {
                item = "wine",
                max_per_day = 1000
            },
            {
                item = "portable-electronics",
                max_per_day = 120
            },
            {
                item = "building-materials",
                max_per_day = 7000
            },
            {
                item = "solid-fuel",
                max_per_day = 5000
            }
        },
        rewards = rewards02
    },

    {
        name = "Tier 7",
        upgrade_population = 200000,
        downgrade_population = 60000,
        max_growth_rate = 75,
        max_decline_rate = -90,
        needs = {
            {
                item = "luxury-meal",
                max_per_day = 30000
            },
            {
                item = "beer",
                max_per_day = 5000,
            },
            {
                item = "wine",
                max_per_day = 2000
            },
            {
                item = "portable-electronics",
                max_per_day = 500
            },
            {
                item = "building-materials",
                max_per_day = 10000
            },
            {
                item = "solid-fuel",
                max_per_day = 8000
            },
            {
                item = "seeder",
                consume_once = true,
                count = 100
            },
            {
                item = "seeder-module-01",
                consume_once = true,
                count = 1000
            },
            {
                item = "seeder-module-02",
                consume_once = true,
                count = 1000
            },
        },
        rewards = rewards02
    },

    {
        name = "Tier 8",
        upgrade_population = 500000,
        downgrade_population = 120000,
        max_growth_rate = 75,
        max_decline_rate = -90,
        needs = {
            {
                item = "luxury-meal",
                max_per_day = 40000
            },
            {
                item = "beer",
                max_per_day = 6000,
            },
            {
                item = "wine",
                max_per_day = 3000
            },
            {
                item = "portable-electronics",
                max_per_day = 1000
            },
            {
                item = "building-materials",
                max_per_day = 13000
            },
            {
                item = "rocket-fuel",
                max_per_day = 3000
            },
            {
                item = "satellite",
                consume_once = true,
                count = 100
            },
            {
                item = "terraformer",
                consume_once = true,
                count = 500
            },
            {
                item = "terraform-module-grass",
                consume_once = true,
                count = 500
            },
            {
                item = "terraform-module-sand",
                consume_once = true,
                count = 500
            },
            {
                item = "terraform-module-dirt",
                consume_once = true,
                count = 500
            }
        },
        rewards = rewards02
    },

    {
        name = "Tier 9",
        upgrade_population = 1000000,
        downgrade_population = 300000,
        max_growth_rate = 75,
        max_decline_rate = -90,
        needs = {
            {
                item = "luxury-meal",
                max_per_day = 60000
            },
            {
                item = "beer",
                max_per_day = 8000,
            },
            {
                item = "wine",
                max_per_day = 5000
            },
            {
                item = "portable-electronics",
                max_per_day = 3000
            },
            {
                item = "building-materials",
                max_per_day = 15000
            },
            {
                item = "rocket-fuel",
                max_per_day = 6000
            },
            {
                item = "satellite",
                consume_once = true,
                count = 1000
            },
            {
                item = "rocket-control-unit",
                consume_once = true,
                count = 1000
            },
            {
                item = "rocket",
                consume_once = true,
                count = 5000
            },
            {
                item = "rocket-silo",
                consume_once = true,
                count = 10
            }
        },
        rewards = rewards02
    },
}
