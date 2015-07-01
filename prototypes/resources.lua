data:extend({
	{
		type = "resource-category",
		name = "sand"
	},

	{
	    type = "resource",
	    name = "sand-source",
	    icon = "__homeworld__/graphics/icons/sand.png",
	    flags = {"placeable-neutral"},
	    order="a-b-a",
	    category = "sand",
	    --infinite = true,
	    --minimum = 75,
    	--normal = 76,
	    minable =
	    {
	      hardness = 1,
	      mining_particle = "copper-ore-particle",
	      mining_time = 1,
	      result = "sand"
	    },
	    collision_box = {{ -0.1, -0.1}, {0.1, 0.1}},
	    selection_box = {{ -0.5, -0.5}, {0.5, 0.5}},
	    autoplace =
	    {
	      control = "sand",
	      sharpness = 0.5,
	      richness_multiplier = 300,
	      richness_base = 10,
	      size_control_multiplier = 0.06,
	      tile_restriction = {"sand", "sand-dark"},
	      peaks = {
	        {
	          influence = 0.95
	        }
	      },
	    },
	    stage_counts = {0},
	    stages = { filename = "__homeworld__/graphics/empty.png",
	      priority = "extra-high",
	      width = 16,
	      height = 16,
	      frame_count = 1,
	      direction_count = 1
	    },
	    map_color = {r=0.48, g=0.36, b=0.128}
	},

	{
    	type = "autoplace-control",
    	name = "sand",
    	richness = true,
    	frequency = false,
    	size = false,
    	order = "b-c-s"
  	},
})