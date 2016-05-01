data:extend({
  {
    type = "furnace",
    name = "seeder",
    icon = "__homeworld__/graphics/icons/seeder.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, result = "seeder"},
    max_health = 150,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    light = {intensity = 1, size = 10},
    resistances =
    {
      {
        type = "fire",
        percent = 80
      }
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    module_specification =
    {
      module_slots = 2,
      module_info_icon_shift = {0, 0.8}
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    crafting_categories = {"seeder"},
	result_inventory_size = 0,
    crafting_speed = 1,
    energy_usage = "500kW",
	source_inventory_size = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.005
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__homeworld__/sound/terraformer.ogg",
        volume = 0.7
      },
      apparent_volume = 1.5
    },
    animation =
    {
      filename = "__homeworld__/graphics/entity/seeder/seeder_animation.png",
      priority = "high",
      width = 300,
      height = 300,
      frame_count = 25,
      line_length = 5,
      scale = 1
    },
    fast_replaceable_group = "furnace"
  },

  {
    type = "furnace",
    name = "terraformer",
    icon = "__homeworld__/graphics/icons/terraformer.png",
    flags = {"placeable-neutral", "placeable-player", "player-creation"},
    minable = {mining_time = 1, result = "terraformer"},
    max_health = 150,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    light = {intensity = 1, size = 10},
    resistances =
    {
      {
        type = "fire",
        percent = 80
      }
    },
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    module_specification =
    {
      module_slots = 2,
      module_info_icon_shift = {0, 0.8}
    },
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    crafting_categories = {"terraformer"},
    result_inventory_size = 0,
    crafting_speed = 6,
    energy_usage = "2MW",
    source_inventory_size = 1,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.005
    },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    working_sound =
    {
      sound =
      {
        filename = "__homeworld__/sound/terraformer.ogg",
        volume = 0.7
      },
      apparent_volume = 1.5
    },
    animation =
    {
      filename = "__homeworld__/graphics/entity/seeder/seeder_animation.png",
      priority = "high",
      width = 300,
      height = 300,
      frame_count = 25,
      line_length = 5,
      scale = 1,
      tint = {r = 0.5, g = 0.75, b = 1, a = 1}
    },
    fast_replaceable_group = "furnace"
  },

  {
    type = "recipe-category",
    name = "seeder"
  },

  {
    type = "recipe-category",
    name = "terraformer"
  }
})

function SeederModule( itemName )
  data:extend({
    {
      type = "item",
      name = itemName,
      icon = "__homeworld__/graphics/icons/"..itemName..".png",
      flags = { "goes-to-quickbar" },
      subgroup = "module",
      stack_size = 10
    },
    {
      type = "recipe",
      category = "seeder",
      name = itemName,
      enabled = "false",
	  hidden = "true",
      energy_required = 250,
      ingredients = {{itemName, 1}},
      result = "raw-wood",
      result_count = 0
    },
    {
      type = "recipe",
      name = "craft-"..itemName,
      enabled = "false",
      ingredients = {
        {"raw-wood", 50},
        {"alien-artifact", 1},
        {"plastic-bar", 5}
      },
      result = itemName
    }
  })
end

function TerraformerModule( itemName )
  data:extend({
    {
      type = "item",
      name = "terraform-module-"..itemName,
      icon = "__homeworld__/graphics/icons/terraform-module-"..itemName..".png",
      flags = { "goes-to-quickbar" },
      subgroup = "module",
      stack_size = 10
    },
    {
      type = "recipe",
      category = "terraformer",
      name = "terraform-module-"..itemName,
      enabled = "false",
	  hidden = true,
      energy_required = 500,
      ingredients = {{"terraform-module-"..itemName, 1}},
      result = "plastic-bar",
      result_count = 0
    },
    {
      type = "recipe",
      name = "craft-terraform-module-"..itemName,
      enabled = "false",
      ingredients = {
        {"alien-artifact", 5},
        {"processing-unit", 2},
        {"plastic-bar", 5}
      },
      result = "terraform-module-"..itemName
    }
  })
end

for i = 1, 5 do
  local name = string.format("seeder-module-%02d", i)
  SeederModule(name)
end

TerraformerModule("sand")
TerraformerModule("grass")
TerraformerModule("dirt")
TerraformerModule("stone")
TerraformerModule("concrete")

