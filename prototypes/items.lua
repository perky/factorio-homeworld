data.raw.capsule["raw-fish"].stack_size = 1024
data.raw.item["empty-barrel"].stack_size = 256
data.raw.item["concrete"].stack_size = 1024

data:extend({
	{
		type = "item",
		name = "arcology",
		icon = "__base__/graphics/icons/lab.png",
		flags = { "goes-to-quickbar" },
		subgroup = "storage",
		place_result = "arcology",
		stack_size = 1
	},

	{
		type = "item",
		name = "homeworld_portal",
		icon = "__homeworld__/graphics/icons/portal.png",
		flags = { "goes-to-quickbar" },
		subgroup = "storage",
		place_result = "homeworld_portal",
		stack_size = 1
	},

	{
		type = "item",
		name = "fishery",
		icon = "__homeworld__/graphics/icons/fishery.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "fishery",
		stack_size = 16
	},

	{
		type = "item",
		name = "sawmill",
		icon = "__homeworld__/graphics/icons/sawmill.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "sawmill",
		stack_size = 16
	},

	{
		type = "item",
		name = "farm",
		icon = "__homeworld__/graphics/icons/farm.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "farm",
		stack_size = 16
	},

	{
		type = "item",
		name = "distillery",
		icon = "__homeworld__/graphics/icons/distillery.png",
		flags = { "goes-to-quickbar" },
		subgroup = "production-machine",
		place_result = "distillery",
		stack_size = 10
	},

	{
		type = "item",
		name = "sand-collector",
		icon = "__homeworld__/graphics/icons/sand-collector.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "sand-collector",
		stack_size = 50
	},

	{
	    type = "item",
	    name = "sand",
	    icon = "__homeworld__/graphics/icons/sand.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    order = "s",
	    stack_size = 2048
  	},

  	{
	    type = "item",
	    name = "glass",
	    icon = "__homeworld__/graphics/icons/glass.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "building-materials",
	    icon = "__homeworld__/graphics/icons/building-materials.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    order = "s",
	    stack_size = 512
  	},

	{
	    type = "item",
	    name = "water-barrel",
	    icon = "__homeworld__/graphics/icons/fluid/water-barrel.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "barrel",
	    order = "b[water-barrel]",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "wine-barrel",
	    icon = "__homeworld__/graphics/icons/fluid/water-barrel.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "barrel",
	    order = "b[water-barrel]",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "furniture",
	    icon = "__homeworld__/graphics/icons/furniture.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    order = "b[water-barrel]",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "portable-electronics",
	    icon = "__homeworld__/graphics/icons/electronics.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "tool",
	    order = "b[water-barrel]",
	    stack_size = 512
  	},

  	{
	    type = "item",
	    name = "wheat",
	    icon = "__homeworld__/graphics/icons/wheat.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "bread",
	    icon = "__homeworld__/graphics/icons/bread.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    stack_size = 512
  	},

  	{
	    type = "item",
	    name = "hops",
	    icon = "__homeworld__/graphics/icons/hops.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "grapes",
	    icon = "__homeworld__/graphics/icons/grapes.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "beer",
	    icon = "__homeworld__/graphics/icons/beer.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "wine",
	    icon = "__homeworld__/graphics/icons/wine.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "vegetables",
	    icon = "__homeworld__/graphics/icons/veg.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "meat",
	    icon = "__homeworld__/graphics/icons/meat.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "luxury-meal",
	    icon = "__homeworld__/graphics/icons/luxury-meal.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    stack_size = 256
  	},
})