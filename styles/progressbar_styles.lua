data.raw["gui-style"].default["homeworld_need_progressbar_style"] = {
	type = "progressbar_style",
	name = "homeworld_need_progressbar_style",
	smooth_color = {g = 1},
	other_smooth_colors = {
   		{
      		less_then = 0.15,
      		color = {r = 1, g = 0, b = 0}
    	},
    	{
      		less_then = 0.4,
      		color = {r = 1, g = 1, b = 0}
    	}
  	}
}

data.raw["gui-style"].default["homeworld_need_all_progressbar_style"] = {
  type = "progressbar_style",
  name = "homeworld_need_all_progressbar_style",
  smooth_color = {g = 1},
  other_smooth_colors = {
      {
          less_then = 0.99,
          color = {r = 1, g = 1, b = 0}
      },
      {
          less_then = 0.15,
          color = {r = 1, g = 0, b = 0}
      },
    }
}
