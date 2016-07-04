-- Overwrite vanilla recipes
-- data.raw.recipe["empty-barrel"].results[1].amount = 10
table.insert(data.raw.recipe["concrete"].ingredients, {"sand", 5})

data:extend({

  -- SAWMILLL RECIPE
  {
    type = "recipe-category",
    name = "sawmill"
  },
  {
    type = "recipe",
    category = "sawmill",
    name = "collect-wood",
    enabled = true,
	hidden = true,
    energy_required = 2,
    ingredients = {{"sawmill-tree", 1}},
    result = "raw-wood",
    result_count = 5
  },

  -- MACHINE RECIPES

	{
		type = "recipe",
		name = "homeworld-portal",
		enabled = "false",
		ingredients = {
			{"alien-artifact", 50},
         {"stone-brick", 200},
			{"iron-chest", 5}
		},
		result = "homeworld_portal"
	},

	{
		type = "recipe",
		name = "fishery",
		enabled = "false",
		ingredients = {
			{"wood", 5},
			{"iron-gear-wheel", 3},
			{"iron-plate", 10}
		},
		result = "fishery"
	},

  {
    type = "recipe",
    name = "sawmill",
    enabled = "false",
    ingredients = {
      {"raw-wood", 10},
      {"iron-gear-wheel", 10},
    },
    result = "sawmill"
  },

  {
    type = "recipe",
    name = "farm",
    enabled = "false",
    ingredients = {
      {"wood", 5},
      {"stone", 5}
    },
    result = "farm"
  },

  {
    type = "recipe",
    name = "distillery",
    enabled = "false",
    ingredients = {
      {"steel-plate", 5},
      {"iron-gear-wheel", 5},
      {"electronic-circuit", 2},
      {"pipe", 3}
    },
    result = "distillery"
  },

  {
    type = "recipe",
    name = "sand-collector",
    enabled = "true",
    ingredients = {
      {"iron-plate", 15},
      {"iron-gear-wheel", 5},
      {"electronic-circuit", 2}
    },
    result = "sand-collector"
  },

  {
    type = "recipe",
    name = "seeder",
    enabled = "false",
    ingredients = {
      {"raw-wood", 100},
      {"iron-plate", 20},
      {"battery", 30},
      {"advanced-circuit", 20}
    },
    result = "seeder"
  },

  {
    type = "recipe",
    name = "terraformer",
    enabled = "false",
    ingredients = {
      {"iron-plate", 50},
      {"battery", 40},
      {"processing-unit", 20}
    },
    result = "terraformer"
  },
  
  {
    type = "recipe",
    name = "belt_gate",
    enabled = "false",
    ingredients = {
      {"small-lamp", 1},
      {"battery", 1},
      {"electronic-circuit", 5}
    },
    result = "belt_gate"
  },
  
  {
    type = "recipe",
    name = "belt_throughput_reader",
    enabled = "false",
    ingredients = {
      {"constant-combinator", 1},
      {"battery", 1},
      {"electronic-circuit", 5}
    },
    result = "belt_throughput_reader"
  },

  -- SMELTING RECIPES

    {
        type = "recipe",
        name = "bake-bread",
        category = "smelting",
        enabled = "false",
        energy_required = 1,
        ingredients = {{"wheat", 1}},
        result = "bread",
        result_count = 4
    },

    {
        type = "recipe",
        name = "glass",
        category = "smelting",
        enabled = "true",
        energy_required = 2.5,
        ingredients = {{"sand", 2}},
        result = "glass"
    },

  -- CRAFTING RECIPES

	{
		type = "recipe",
		name = "furniture",
		enabled = "false",
        ingredients = {{"wood", 1}},
        result = "furniture",
        energy_required = 0.75,
        result_count = 2
	},

	{
		type = "recipe",
		name = "luxury-meal",
        enabled = "false",
        ingredients = {{"raw-fish", 3}, {"vegetables", 1}, {"bread", 4}},
        result = "luxury-meal",
        result_count = 3
	},

	{
		type = "recipe",
		name = "portable-electronics",
		enabled = "false",
        ingredients = {{"processing-unit", 1}, {"battery", 1}, {"plastic-bar", 1}},
        energy_required = 2,
        result = "portable-electronics"
	},

    {
        type = "recipe",
        name = "building-materials",
        enabled = "false",
        ingredients = {{"concrete", 3}, {"stone-brick", 1}, {"steel-plate", 1}, {"wood", 2}},
        result = "building-materials",
        result_count = 3
    },

    {
        type = "recipe",
        name = "synthetic-wood",
        enabled = "false",
        ingredients = {{"raw-wood", 2}, {"plastic-bar", 1}},
        result = "wood",
        result_count = 30
    },

    {
        type = "recipe",
        name = "fishery-test",
        enabled = "false",
        ingredients = {},
        result = "raw-fish",
        result_count = 30
    },

  -- ALCOHOL RECIPES

    {
        type = "recipe-category",
        name = "alcohol"
    },

    {
        type = "recipe",
        name = "mashing-beer",
        category = "alcohol",
        enabled = "false",
        energy_required = 5,
        subgroup = "fluid",
        icon = "__homeworld__/graphics/icons/fluid/mashing.png",
        ingredients = {
            {type = "fluid", name = "water", amount = 5},
            {type = "item", name = "wheat", amount = 10}
        },
        results = {
            {type = "fluid", name = "ethanol", amount = 5}
        }
    },

    {
        type = "recipe",
        name = "fermenting-beer",
        category = "alcohol",
        enabled = "false",
        energy_required = 2.5,
        subgroup = "fluid",
        icon = "__homeworld__/graphics/icons/fluid/fermenting.png",
        ingredients = {
            {type = "fluid", name = "ethanol", amount = 2},
            {type = "item", name = "hops", amount = 2}
        },
        results = {
            {type = "fluid", name = "beer-fluid", amount = 5}
        }
    },

    {
        type = "recipe",
        name = "fermenting-wine",
        category = "alcohol",
        enabled = "false",
        energy_required = 5,
        subgroup = "fluid",
        ingredients = {
            {type = "fluid", name = "ethanol", amount = 1},
            {type = "item", name = "grapes", amount = 3}
        },
        results = {
            {type = "fluid", name = "wine-fluid", amount = 3}
        }
    },

    {
        type = "recipe",
        name = "maturing-wine",
        category = "alcohol",
        enabled = "false",
        subgroup = "fluid",
        energy_required = 400,
        ingredients = {
            {type = "fluid", name = "wine-fluid", amount = 128},
            {type = "item", name = "glass", amount = 128}
        },
        results = {
            {type = "item", name = "wine", amount = 256}
        }
    },

  -- BARREL RECIPES
    --[[{
        type = "recipe",
        name = "fill-water-barrel",
        category = "crafting-with-fluid",
        energy_required = 1,
        subgroup = "barrel",
        order = "b",
        enabled = "false",
        icon = "__homeworld__/graphics/icons/fluid/fill-water-barrel.png",
        ingredients =
        {
            {type="fluid", name="water", amount=0.5},
            {type="item", name="empty-barrel", amount=1},
        },
        results=
        {
            {type="item", name="water-barrel", amount=1}
        }
    },]]--

    {
        type = "recipe",
        name = "fill-beer-barrel",
        category = "crafting-with-fluid",
        energy_required = 1,
        subgroup = "barrel",
        order = "b",
        enabled = "false",
        icon = "__homeworld__/graphics/icons/beer.png",
        ingredients =
        {
            {type="fluid", name="beer-fluid", amount=10},
            {type="item", name="empty-barrel", amount=1},
        },
        results=
        {
            {type="item", name="beer", amount=2}
        }
    },
})
