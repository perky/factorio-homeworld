data.raw.capsule["raw-fish"].stack_size = 1024
data.raw.item["empty-barrel"].stack_size = 256
data.raw.item["concrete"].stack_size = 1024

data:extend({
	{
		type = "item",
		name = "homeworld_portal",
		icon = "__homeworld__/graphics/icons/portal.png",
		flags = { "goes-to-quickbar" },
		subgroup = "storage",
		place_result = "homeworld_portal",
		stack_size = 1,
		order = "d[items]-c[steel-chest]"
	},

	{
		type = "item",
		name = "fishery",
		icon = "__homeworld__/graphics/icons/fishery.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "fishery",
		order = "c[gatherers]-a[fishery]",
		stack_size = 16
	},

	{
		type = "item",
		name = "sawmill",
		icon = "__homeworld__/graphics/icons/sawmill.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "sawmill",
		order = "a[items]-a[burner-mining-drill]",
		stack_size = 16
	},

	{
		type = "item",
		name = "terraformer",
		icon = "__homeworld__/graphics/icons/terraformer.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "terraformer",
		order = "d[terraformers]-b[terraformer]",
		stack_size = 16
	},

	{
		type = "item",
		name = "seeder",
		icon = "__homeworld__/graphics/icons/seeder.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "seeder",
		order = "d[terraformers]-a[seeder]",
		stack_size = 16
	},

	{
		type = "item",
		name = "distillery",
		icon = "__homeworld__/graphics/icons/distillery.png",
		flags = { "goes-to-quickbar" },
		subgroup = "production-machine",
		place_result = "distillery",
		order = "e[distillery]",
		stack_size = 10
	},

	{
		type = "item",
		name = "sand-collector",
		icon = "__homeworld__/graphics/icons/sand-collector.png",
		flags = { "goes-to-quickbar" },
		subgroup = "extraction-machine",
		place_result = "sand-collector",
		order = "a[items]-b[basic-mining-drill]",
		stack_size = 50
	},
    
    {
		type = "item",
		name = "belt_gate",
		icon = "__homeworld__/graphics/icons/belt_gate.png",
		flags = { "goes-to-quickbar" },
		subgroup = "belt",
		place_result = "belt_gate",
		order = "d[smart-belt]-a[gate]",
		stack_size = 50
	},
    
    {
		type = "item",
		name = "belt_throughput_reader",
		icon = "__homeworld__/graphics/icons/belt_throughput_reader.png",
		flags = { "goes-to-quickbar" },
		subgroup = "belt",
		place_result = "belt_throughput_reader",
		order = "d[smart-belt]-b[throughput-monitor]",
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
	    order = "k[homeworld]-f[glass]",
		stack_size = 1024
  	},

  	{
	    type = "item",
	    name = "building-materials",
	    icon = "__homeworld__/graphics/icons/building-materials.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    order = "k[homeworld]-b[building-materials]",
	    stack_size = 512
  	},

	{
	    type = "item",
	    name = "water-barrel",
	    icon = "__homeworld__/graphics/icons/fluid/water-barrel.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "barrel",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "wine-barrel",
	    icon = "__homeworld__/graphics/icons/fluid/water-barrel.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "barrel",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "furniture",
	    icon = "__homeworld__/graphics/icons/furniture.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    order = "k[homeworld]-a[furniture]",
	    stack_size = 256
  	},

  	{
	    type = "item",
	    name = "portable-electronics",
	    icon = "__homeworld__/graphics/icons/electronics.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
	    order = "k[homeworld]-d[electronics]",
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
		order = "k[homeworld]-e[bread]",
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
	    name = "sawmill-tree",
	    icon = "__base__/graphics/icons/tree-03.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "raw-material",
	    stack_size = 32
  	},

  	{
	    type = "item",
	    name = "luxury-meal",
	    icon = "__homeworld__/graphics/icons/luxury-meal.png",
	    flags = {"goes-to-main-inventory"},
	    subgroup = "intermediate-product",
		order = "k[homeworld]-c[luxury-meal]",
	    stack_size = 256
  	},
})
