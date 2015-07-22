local fluidTech = data.raw.technology["fluid-handling"]
local alienTech = data.raw.technology["alien-technology"]
local battery = data.raw.technology["battery"]
local plastics = data.raw.technology["plastics"]
local concreteTech = data.raw.technology["concrete"]
table.insert(fluidTech.effects, {type = "unlock-recipe", recipe = "fill-water-barrel"})
table.insert(alienTech.effects, {type = "unlock-recipe", recipe = "homeworld-portal"})
table.insert(battery.effects, {type = "unlock-recipe", recipe = "portable-electronics"})
table.insert(plastics.effects, {type = "unlock-recipe", recipe = "synthetic-wood"})
table.insert(concreteTech.effects, {type = "unlock-recipe", recipe = "building-materials"})

concreteTech.prerequisites = {"advanced-material-processing-2", "carpentry"}

data:extend({
	{
		type = "technology",
		name = "agriculture",
		icon = "__base__/graphics/icons/fish.png",
		prerequisites = {},
		unit =
	    {
	    	count = 15,
	    	ingredients = {{"science-pack-1", 1}},
	     	time = 10
	    },
	    effects = {
	    	{type = "unlock-recipe", recipe = "fishery"},
	    	{type = "unlock-recipe", recipe = "farm"},
	    	{type = "unlock-recipe", recipe = "sawmill"},
	    	{type = "unlock-recipe", recipe = "bake-bread"},
	    	{type = "unlock-recipe", recipe = "luxury-meal"},
		}
	},

	{
		type = "technology",
		name = "alcohol-technology",
		icon = "__homeworld__/graphics/icons/beer.png",
		prerequisites = {"agriculture", "fluid-handling"},
		unit = {
			count = 30,
			ingredients = {{"science-pack-1", 2}, {"science-pack-2", 1}},
			time = 20
		},
		effects = {
			{type = "unlock-recipe", recipe = "distillery"},
			{type = "unlock-recipe", recipe = "mashing-beer"},
			{type = "unlock-recipe", recipe = "fermenting-beer"},
			{type = "unlock-recipe", recipe = "fill-beer-barrel"},
			{type = "unlock-recipe", recipe = "fermenting-wine"},
			{type = "unlock-recipe", recipe = "maturing-wine"},
		}
	},

	{
		type = "technology",
		name = "carpentry",
		icon = "__homeworld__/graphics/icons/furniture.png",
		prerequisites = {"stone-walls", "agriculture"},
		unit = {
			count = 60,
			ingredients = {{"science-pack-1", 2}, {"science-pack-2", 1}},
			time = 20
		},
		effects = {
			{type = "unlock-recipe", recipe = "furniture"}
		}
	},

	{
		type = "technology",
		name = "terraforming-1",
		icon = "__homeworld__/graphics/icons/seeder.png",
		prerequisites = {"battery"},
		unit = {
			count = 75,
			ingredients = {{"science-pack-1", 1}, {"science-pack-2", 1}, {"science-pack-3", 1}},
			time = 25
		},
		effects = {
			{type = "unlock-recipe", recipe = "seeder"}
		}
	},

	{
		type = "technology",
		name = "terraforming-2",
		icon = "__homeworld__/graphics/icons/terraformer.png",
		prerequisites = {"terraforming-1", "alien-technology"},
		unit = {
			count = 125,
			ingredients = {{"science-pack-1", 1}, {"science-pack-2", 1}, {"science-pack-3", 1}, {"alien-science-pack", 1}},
			time = 40
		},
		effects = {
			{type = "unlock-recipe", recipe = "seeder"}
		}
	},
})

