GUI = {
	parentStack = {},
	buttonCallbacks = {}
}
GUI.VERTICAL = "vertical"
GUI.HORIZONTAL = "horizontal"

function GUI.PushLeftSection()
	return GUI.PushParent(game.player.gui.left)
end

function GUI.PushParent( parent )
	table.insert(GUI.parentStack, parent)
	return parent
end

function GUI.PopParent()
	table.remove(GUI.parentStack, #GUI.parentStack)
end

function GUI.PopAll()
	GUI.parentStack = {}
end

function GUI.Parent()
	return GUI.parentStack[#GUI.parentStack]
end

function GUI.Frame(name, caption, direction)
	if direction == nil then
		direction = GUI.VERTICAL
	end
	local parent = GUI.Parent()
	if not parent[name] then
		return GUI.Parent().add{type = "frame", name=name, caption=caption, direction=direction}
	else
		return parent[name]
	end
end

function GUI.Label(name, caption, style)
	return GUI.Parent().add{type = "label", name = name, caption = caption, style = style}
end

function GUI.LabelData(name, caption, initialValue)
	local flow = GUI.PushParent(GUI.Flow(name, GUI.HORIZONTAL))
	GUI.Label("label", caption, "caption_label_style")
	GUI.Label("data", initialValue, "description_title_label_style")
	GUI.PopParent()
	return flow
end

function GUI.ProgressBar(name, size, initialValue, style)
	return GUI.Parent().add{
		type = "progressbar",
		name = name,
		size = size,
		value = initialValue,
		style = style
	}
end

function GUI.Flow(name, direction)
	return GUI.Parent().add{type = "flow", name = name, direction = direction}
end

function GUI.Icon(name, iconName)
	return GUI.Parent().add{type = "checkbox", style = "arcology-icon-"..iconName, state = true, name = name}
end

function GUI.Button(name, caption, methodName, delegate)
	local parent = GUI.Parent()
	local button = parent.add{type = "button", name = name, caption = caption, style = style}
	GUI.buttonCallbacks[name] = {onclick = methodName, delegate = delegate}
	return button
end

function GUI.OnClick( event )
	local element = event.element
	local callback = GUI.buttonCallbacks[element.name]
	if callback then
		callback.delegate[callback.onclick](callback.delegate)
	end
end
game.onevent(defines.events.onguiclick, GUI.OnClick)