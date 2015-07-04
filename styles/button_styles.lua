data:extend(
{
  {
    type = "font",
    name = "small",
    from = "default",
    size = 12
  }
})

data.raw["gui-style"].default["homeworld_radar_button_style"] = {
	type = "button_style",
	parent = "button_style",
	font = "small",
	top_padding = 2,
	right_padding = 2,
	bottom_padding = 2,
	left_padding = 2
}

data.raw["gui-style"].default["homeworld_radar_button_disabled_style"] = {
	type = "button_style",
	parent = "fake_disabled_button_style",
	font = "small",
	top_padding = 2,
	right_padding = 2,
	bottom_padding = 2,
	left_padding = 2
}
