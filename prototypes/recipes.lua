data:extend({

  -- MACHINE RECIPES

	{
		type = "recipe",
		name = "homeworld-portal",
		enabled = "false",
		ingredients = {
			{"alien-artifact", 30},
			{"smart-chest", 5}
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

  -- SMELTING RECIPES

	{
		type = "recipe",
		name = "bake-bread",
		category = "smelting",
		enabled = "false",
		energy_required = 3,
  	ingredients = {{"wheat", 1}},
  	result = "bread"
	},

  {
    type = "recipe",
    name = "glass",
    category = "smelting",
    enabled = "true",
    energy_required = 2.5,
    ingredients = {{"sand", 5}},
    result = "glass"
  },

  -- CRAFTING RECIPES

	{
		type = "recipe",
		name = "furniture",
		enabled = "false",
  	ingredients = {{"wood", 1}},
  	result = "furniture",
    result_count = 2
	},

	{
		type = "recipe",
		name = "luxury-meal",
		enabled = "false",
  	ingredients = {{"raw-fish", 1}, {"vegetables", 3}, {"bread", 1}},
  	result = "luxury-meal"
	},

	{
		type = "recipe",
		name = "portable-electronics",
		enabled = "false",
  	ingredients = {{"processing-unit", 1}, {"battery", 1}, {"plastic-bar", 2}},
  	result = "portable-electronics"
	},

  {
    type = "recipe",
    name = "concrete",
    enabled = "false",
    ingredients = {{"sand", 2}, {"stone", 3}},
    result = "concrete"
  },

  {
    type = "recipe",
    name = "building-materials",
    enabled = "false",
    ingredients = {{"concrete", 3}, {"stone-brick", 3}, {"steel-plate", 1}, {"wood", 3}},
    result = "building-materials"
  },

  {
    type = "recipe",
    name = "synthetic-wood",
    enabled = "false",
    ingredients = {{"wood", 5}, {"plastic-bar", 5}},
    result = "wood",
    result_count = 20
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
      {type = "fluid", name = "water", amount = 10},
      {type = "item", name = "wheat", amount = 20}
    },
    results = {
      {type = "fluid", name = "ethanol", amount = 4}
    }
  },

  {
    type = "recipe",
    name = "fermenting-beer",
    category = "alcohol",
    enabled = "false",
    energy_required = 5,
    subgroup = "fluid",
    icon = "__homeworld__/graphics/icons/fluid/fermenting.png",
    ingredients = {
      {type = "fluid", name = "ethanol", amount = 1},
      {type = "item", name = "hops", amount = 5}
    },
    results = {
      {type = "fluid", name = "beer-fluid", amount = 1}
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
      {type = "item", name = "grapes", amount = 1}
    },
    results = {
      {type = "fluid", name = "wine-fluid", amount = 2}
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
  {
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
      {type="fluid", name="water", amount=25},
      {type="item", name="empty-barrel", amount=1},
    },
    results=
    {
      {type="item", name="water-barrel", amount=1}
    }
  },

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
      {type="fluid", name="beer-fluid", amount=2},
      {type="item", name="empty-barrel", amount=1},
    },
    results=
    {
      {type="item", name="beer", amount=2}
    }
  },
--[[
  {
    type = "recipe",
    name = "fill-wine-barrel",
    category = "crafting-with-fluid",
    energy_required = 1,
    subgroup = "barrel",
    order = "b",
    enabled = "false",
    icon = "__homeworld__/graphics/icons/fluid/fill-water-barrel.png",
    ingredients =
    {
      {type="fluid", name="wine-fluid", amount=2},
      {type="item", name="empty-barrel", amount=1},
    },
    results=
    {
      {type="item", name="wine-barrel", amount=1}
    }
  },]]--
})