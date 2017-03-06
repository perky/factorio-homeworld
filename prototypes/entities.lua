data:extend({
    {
        type = "container",
        name = "fishery",
        icon = "__base__/graphics/icons/fish.png",
        flags = {"player-creation", "placeable-player"},
        minable = {mining_time = 0.3, result = "fishery"},
        max_health = 50,
        corpse = "big-remnants",
        collision_mask = {"ground-tile"},
        collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
        selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
        picture = {
            filename = "__homeworld__/graphics/entity/fishery.png",
            width = 192,
            height = 230,
            scale = 0.8,
            shift = {0, -0.8}
        },
        inventory_size = 3,
        open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
        close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
    },

    {
        type = "furnace",
        name = "sawmill",
        icon = "__homeworld__/graphics/icons/sawmill.png",
        flags = {"player-creation", "placeable-player"},
        minable = {mining_time = 0.3, result = "sawmill"},
        max_health = 50,
        corpse = "big-remnants",
        collision_box = {{-1.8, -1.8}, {1.8, 1.8}},
        selection_box = {{-1.8, -1.8}, {1.8, 1.8}},
        animation = {
            filename = "__homeworld__/graphics/entity/sawmill.png",
            priority = "extra-high",
            width = 260,
            height = 240,
            frame_count = 12,
            line_length = 6,
            shift = {0.40625, -0.71875},
            animation_speed = 4
        },

        crafting_categories = {"sawmill"},
        crafting_speed = 0.1,
        energy_usage = "15kW",
        source_inventory_size = 1,
        result_inventory_size = 5,
        energy_source =
        {
          type = "burner",
          effectivity = 1,
          emissions = 0.002,
          fuel_inventory_size = 1
        },
        inventory_size = 12,
        open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
        close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
    },

	 {
        type = "container",
        name = "homeworld_portal",
        icon = "__homeworld__/graphics/icons/portal.png",
        flags = {"player-creation", "placeable-player"},
        minable = {mining_time = 0.3, result = "homeworld_portal"},
        render_layer = "floor",
        max_health = 150,
        corpse = "big-remnants",
        dying_explosion = "medium-explosion",
        collision_box = {{-2.2, -1.2}, {2.2, 2.2}},
        selection_box = {{-2.5, -1.5}, {2.5, 2.5}},
        picture = {
            filename = "__homeworld__/graphics/entity/portal/portal.png",
            priority = "low",
            width = 226,
            height = 163,
            shift = {0.9375, 0.0625}
        },
        connection_point =
        {
          shadow =
          {
            red = {0.7, -0.3},
            green = {0.7, -0.3}
          },
          wire =
          {
            red = {0.3, -0.8},
            green = {0.3, -0.8}
          }
        },
        inventory_size = 36,
        open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
        close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    },

	 {
        type = "explosion",
        name = "portal-sound",
        flags = {"not-on-map"},
        animations =
        {
            {
                filename = "__core__/graphics/empty.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                frame_count = 1
            }
        },
        sound =
        {
            {
                filename = "__homeworld__/sound/portal.ogg",
                volume = 1
            }
        },
        created_effect =
        {
          type = "direct",
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              type = "create-entity",
              entity_name = "portal-fx",
            }
          }
        }
    },

	 {
        type = "explosion",
        name = "portal-fx",
        flags = {"not-on-map"},
        animations =
        {{
            filename = "__homeworld__/graphics/entity/portal/portal-animation.png",
            priority = "high",
            width = 95,
            height = 215,
            frame_count = 50,
            line_length = 10,
            animation_speed = 0.2,
            shift = {-0.5, -1.95},
            tint = {r = 1, g = 1, b = 1, a = 1}
        }},
    },

    {
    type = "assembling-machine",
    name = "distillery",
    icon = "__homeworld__/graphics/icons/distillery.png",
    flags = {"placeable-neutral","placeable-player", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "distillery"},
    max_health = 300,
    corpse = "big-remnants",
    dying_explosion = "medium-explosion",
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    module_slots = 2,
    allowed_effects = {"consumption", "speed", "productivity", "pollution"},
    animation =
    {
      north =
      {
        filename = "__homeworld__/graphics/entity/distillery/distillery.png",
        width = 156,
        height = 141,
        frame_count = 1,
        shift = {0.5, -0.078125}
      },
      west =
      {
        filename = "__homeworld__/graphics/entity/distillery/distillery.png",
        x = 156,
        width = 156,
        height = 141,
        frame_count = 1,
        shift = {0.5, -0.078125}
      },
      south =
      {
        filename = "__homeworld__/graphics/entity/distillery/distillery.png",
        x = 312,
        width = 156,
        height = 141,
        frame_count = 1,
        shift = {0.5, -0.078125}
      },
      east =
      {
        filename = "__homeworld__/graphics/entity/distillery/distillery.png",
        x = 468,
        width = 156,
        height = 141,
        frame_count = 1,
        shift = {0.5, -0.078125}
      }
    },
    working_visualisations =
    {
      {
        north_position = {0.94, -0.73},
        west_position = {-0.3, 0.02},
        south_position = {-0.97, -1.47},
        east_position = {0.05, -1.46},
        animation =
        {
          filename = "__homeworld__/graphics/entity/distillery/boiling-green-patch.png",
          frame_count = 35,
          width = 17,
          height = 12,
          animation_speed = 0.15
        }
      },
      {
        north_position = {1.4, -0.23},
        west_position = {-0.3, 0.55},
        south_position = {-1, -1},
        east_position = {0.05, -0.96},
        north_animation =
        {
          filename = "__homeworld__/graphics/entity/distillery/boiling-window-green-patch.png",
          frame_count = 1,
          width = 21,
          height = 10
        },
        west_animation =
        {
          filename = "__homeworld__/graphics/entity/distillery/boiling-window-green-patch.png",
          x = 21,
          frame_count = 1,
          width = 21,
          height = 10
        },
        south_animation =
        {
          filename = "__homeworld__/graphics/entity/distillery/boiling-window-green-patch.png",
          x = 42,
          frame_count = 1,
          width = 21,
          height = 10
        }
      }
    },
    working_sound =
    {
      sound = {
        {
          filename = "__base__/sound/chemical-plant.ogg",
          volume = 0.8
        }
      },
      idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
      apparent_volume = 1.5,
    },
    crafting_speed = 1.25,
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      emissions = 0.03 / 3.5
    },
    energy_usage = "20kW",
    ingredient_count = 4,
    crafting_categories = {"alcohol"},
    fluid_boxes =
    {
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {-1, -2} }}
      },
      {
        production_type = "input",
        pipe_covers = pipecoverspictures(),
        base_area = 10,
        base_level = -1,
        pipe_connections = {{ type="input", position = {1, -2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {-1, 2} }}
      },
      {
        production_type = "output",
        pipe_covers = pipecoverspictures(),
        base_level = 1,
        pipe_connections = {{ position = {1, 2} }}
      }
    }
  },
  
  {
    type = "lamp",
    name = "belt_gate",
    icon = "__base__/graphics/icons/small-lamp.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "belt_gate"},
    max_health = 55,
    corpse = "small-remnants",
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input"
    },
    energy_usage_per_tick = "3KW",
    light = {intensity = 0.5, size = 10},
    picture_off =
    {
      filename = "__base__/graphics/entity/small-lamp/light-off.png",
      priority = "high",
      width = 67,
      height = 58,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {-0.021875, 0.16875},
    },
    picture_on =
    {
      filename = "__base__/graphics/entity/small-lamp/light-on-patch.png",
      priority = "high",
      width = 62,
      height = 62,
      frame_count = 1,
      axially_symmetrical = false,
      direction_count = 1,
      shift = {-0.0375, -0.01875},
    },

    circuit_wire_connection_point =
    {
      shadow =
      {
        red = {0.759375, -0.096875},
        green = {0.759375, -0.096875},
      },
      wire =
      {
        red = {0.30625, -0.39375},
        green = {0.30625, -0.39375},
      }
    },

    circuit_wire_max_distance = 7.5
  },
  
  {
    type = "constant-combinator",
    name = "belt_throughput_reader",
    icon = "__base__/graphics/icons/constant-combinator.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "belt_throughput_reader"},
    max_health = 50,
    corpse = "small-remnants",

    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},

    item_slot_count = 15,

    sprites =
    {
      north =
      {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        x = 158,
        y = 126,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      },
      east =
      {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        y = 126,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      },
      south =
      {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        x = 237,
        y = 126,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      },
      west =
      {
        filename = "__base__/graphics/entity/combinator/combinator-entities.png",
        x = 79,
        y = 126,
        width = 79,
        height = 63,
        frame_count = 1,
        shift = {0.140625, 0.140625},
      }
    },
    
    activity_led_sprites =
    {
      north =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-north.png",
        width = 11,
        height = 10,
        frame_count = 1,
        shift = {0.296875, -0.40625},
      },
      east =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-east.png",
        width = 14,
        height = 12,
        frame_count = 1,
        shift = {0.25, -0.03125},
      },
      south =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-south.png",
        width = 11,
        height = 11,
        frame_count = 1,
        shift = {-0.296875, -0.078125},
      },
      west =
      {
        filename = "__base__/graphics/entity/combinator/activity-leds/combinator-led-constant-west.png",
        width = 12,
        height = 12,
        frame_count = 1,
        shift = {-0.21875, -0.46875},
      }
    },

    activity_led_light =
    {
      intensity = 0.8,
      size = 1,
    },
    
    activity_led_light_offsets =
    {
      {0.296875, -0.40625},
      {0.25, -0.03125},
      {-0.296875, -0.078125},
      {-0.21875, -0.46875}
    },
    
    circuit_wire_connection_points =
    {
      {
        shadow =
        {
          red = {0.15625, -0.28125},
          green = {0.65625, -0.25}
        },
        wire =
        {
          red = {-0.28125, -0.5625},
          green = {0.21875, -0.5625},
        }
      },
      {
        shadow =
        {
          red = {0.75, -0.15625},
          green = {0.75, 0.25},
        },
        wire =
        {
          red = {0.46875, -0.5},
          green = {0.46875, -0.09375},
        }
      },
      {
        shadow =
        {
          red = {0.75, 0.5625},
          green = {0.21875, 0.5625}
        },
        wire =
        {
          red = {0.28125, 0.15625},
          green = {-0.21875, 0.15625}
        }
      },
      {
        shadow =
        {
          red = {-0.03125, 0.28125},
          green = {-0.03125, -0.125},
        },
        wire =
        {
          red = {-0.46875, 0},
          green = {-0.46875, -0.40625},
        }
      }
    },
    circuit_wire_max_distance = 7.5
  },
})

-- Copy basic mining drill for the sand collector.
local miningDrill = data.raw["mining-drill"]["electric-mining-drill"]
local sandCollector = {
    name = "sand-collector",
    icon = "__homeworld__/graphics/icons/sand-collector.png",
    minable = {mining_time = 1, result = "sand-collector"},
    resource_categories = {"sand"},
    mining_speed = 3,
    resource_searching_radius = 5,
    energy_usage = "190kW"
}
for key, value in pairs(miningDrill) do
    if not sandCollector[key] then
        sandCollector[key] = value
    end
end
data:extend{sandCollector}

-- copy farm.
function Farm(name, image)
  data:extend({
    {
      type = "container",
      name = name,
      icon = "__base__/graphics/icons/fish.png",
      flags = {"player-creation", "placeable-player"},
      minable = {mining_time = 0.3, result = "farm"},
      max_health = 50,
      corpse = "big-remnants",
      collision_box = {{-4.5, -4.5}, {4.5, 4.5}},
      selection_box = {{-4, -4}, {4, 4}},
      picture = {
          filename = "__homeworld__/graphics/entity/" .. image,
          priority = "low",
          width = 450,
          height = 450,
          shift = {0, 0}
      },
      inventory_size = 30,
      open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
      close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 }
    },
    {
      type = "item",
      name = name,
      icon = "__homeworld__/graphics/icons/farm.png",
      flags = { "goes-to-quickbar" },
      subgroup = "extraction-machine",
      place_result = name,
	  order = "c[gatherers]-b[farm]",
      stack_size = 16
    },
  });
end

Farm("farm", "farm.png")
Farm("farm_01", "farm_01.png")
Farm("farm_02", "farm_02.png")
Farm("farm_03", "farm_03.png")
Farm("farm_full", "farm_full.png")
