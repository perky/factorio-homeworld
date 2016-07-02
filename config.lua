return {
    homeworld = {
        tiers = require('tiers'),
        starting_tier = 1,
        starting_population = 1000,
        min_population = 10,
        update_interval = 1 * SECONDS
    },
    
    farm = {
        production_interval = 5 * GAME_DAY,
        production_interval_deviation = 1 * GAME_DAY,
        reset_interval = 1 * GAME_DAY,
        max_pollution = 1750,
        pollution_multiplier = 1,
        radius = 12,
        produce = {
            {item_name = "wheat", yield_per_min = 30},
            {item_name = "vegetables", yield_per_min = 10},
            {item_name = "hops", yield_per_min = 10},
            {item_name = "grapes", yield_per_min = 5},
        }, 
        soil_richness = {
            ["water"]       = 5.00,
            ["deepwater"]   = 5.00,
            ["grass"]       = 0.85,
            ["grass-medium"]= 0.75,
            ["grass-dry"]   = 0.65,
            ["dirt"]        = 0.50,
            ["dirt-dark"]   = 0.40,
            ["sand"]        = -1.00,
            ["sand-dark"]   = -1.00
        },
        farm_stages = {
            "farm", "farm_01", "farm_02", "farm_03", "farm_full"
        }
    },
    
    fishery = {
        max_pollution = 4000,
        max_fish_yield_per_min = 400,
        yield_reduce_per_nearby_fishery = 0.2,
        fish_per_chunk = 100000,
        --max_fish = 10,
        --fish_reproduction_chance = 0.06,
        --fish_die_chance = 0.07,
        --fish_die_chance_increase_per_fishery = 0.06,
        --reproduction_interval = 40 * SECONDS,
        harvest_interval = 20 * SECONDS,
        radius = 12
    },
    
    portal = {
        update_interval = 60 * SECONDS,
        test_mode = false
    },
    
    sawmill = {
        saw_interval = 10 * SECONDS,
        work_radius = 20,
        tree_multiplier = 2
    },
    
    seeder = {
        tree_types = {
            ["seeder-module-01"] = "tree-01",
            ["seeder-module-02"] = "tree-02",
            ["seeder-module-03"] = "tree-03",
            ["seeder-module-04"] = "tree-04",
            ["seeder-module-05"] = "tree-05",
        },
        --NOTE: Tree programs last for 250 seconds
		plant_tree_interval = {min = 10 * SECONDS, max = 25 * SECONDS},
        plant_radius = 16,
        plant_precision = 4.0
    },
    
    terraformer = {
        radius = 50,
        min_step_interval = 10, -- Ticks.
        max_step_interval = 1 * MINUTES,
        max_energy = 35555,
        tile_types = {
            ["terraform-module-sand"] = "sand",
            ["terraform-module-grass"] = "grass",
            ["terraform-module-dirt"] = "dirt",
            ["terraform-module-stone"] = "stone-path",
            ["terraform-module-concrete"] = "concrete",
        }
    },
    
    belt_throughput_reader = {
        max_snapshots = 1 * MINUTES,
        calculate_throughput_interval = 5 * SECONDS
    }
}