local styles = data.raw["gui-style"].default

local function CreateIconStyle( itemType, itemName )
	local item = data.raw[itemType][itemName]
	local style = {
		type = "checkbox_style",
		parent = "frame_style",
		default_background =
	  	{
	    	filename = item.icon,
	    	width = 32,
	   		height = 32
	  	},
	  	hovered_background =
	  	{
	    	filename = item.icon,
	    	width = 32,
	    	height = 32
	  	}
	}
	styles["arcology-icon-"..itemName] = style
end

styles["arcology-icon-base"] = {
  type = "checkbox_style",
  parent = "checkbox_style",
  width = 35,
  height = 35,
  hovered_background =
  {
    filename = "__test-mode__/styles/gui.png",
    width = 32,
    height = 32,
    x = 0,
    y = 0
  },
  clicked_background =
  {
    filename = "__test-mode__/styles/gui.png",
    width = 32,
    height = 32,
    x = 0,
    y = 0
  },
  checked =
  {
    filename = "__test-mode__/styles/gui.png",
    width = 32,
    height = 32,
    x = 65,
    y = 0
  }
}

--CreateIconStyle("recipes", "wood")
--CreateIconStyle("capsule", "raw-fish")

for typename, sometype in pairs(data.raw) do
  local _, object = next(sometype)
  if object.stack_size then
    for name, item in pairs(sometype) do
      if item.icon then
        local style =
        {
          type = "checkbox_style",
          parent = "arcology-icon-base",
          default_background =
          {
            filename = item.icon,
            width = 32,
            height = 32
          },
          hovered_background =
          {
            filename = item.icon,
            width = 32,
            height = 32
          }
        }
        data.raw["gui-style"].default["arcology-icon-"..name] = style
      end
    end
  end
end