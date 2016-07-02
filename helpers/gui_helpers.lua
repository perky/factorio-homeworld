GUI = {
	parentStack = {}
}
GUI.VERTICAL = "vertical"
GUI.HORIZONTAL = "horizontal"

function GUI.init()
    global.gui_button_callbacks = {}
end

function GUI.push_left_section( playerIndex )
	return GUI.push_parent(game.players[playerIndex].gui.left)
end

function GUI.push_parent( parent )
	table.insert(GUI.parentStack, parent)
	return parent
end

function GUI.pop_parent()
	table.remove(GUI.parentStack, #GUI.parentStack)
end

function GUI.pop_all()
	GUI.parentStack = {}
end

function GUI.parent()
	return GUI.parentStack[#GUI.parentStack]
end

function GUI.frame(name, caption, direction)
	if direction == nil then
		direction = GUI.VERTICAL
	end
	local parent = GUI.parent()
	if not parent[name] then
		return GUI.parent().add{type = "frame", name=name, caption=caption, direction=direction}
	else
		return parent[name]
	end
end

function GUI.label(name, caption, style)
	return GUI.parent().add{type = "label", name = name, caption = caption, style = style}
end

function GUI.set_label_caption_localized( label, ... )
	local texts = {...}
	table.insert(texts, 1, "")
	label.caption = texts
end

function GUI.label_data(name, caption, initialValue)
	local flow = GUI.push_parent(GUI.flow(name, GUI.HORIZONTAL))
	GUI.label("label", caption, "caption_label_style")
	GUI.label("data", initialValue, "description_title_label_style")
	GUI.pop_parent()
	return flow
end

function GUI.table( name, colspan )
	return GUI.parent().add{type = "table", name = name, colspan = colspan}
end

function GUI.table_spacer( tbl, amount )
	for i = 1, amount do
		GUI.label("spacer_"..#tbl.children_names, "")
	end
end

function GUI.progress_bar(name, size, initialValue, style)
	return GUI.parent().add{
		type = "progressbar",
		name = name,
		size = size,
		value = initialValue,
		style = style
	}
end

function GUI.flow(name, direction)
	return GUI.parent().add{type = "flow", name = name, direction = direction}
end

function GUI.icon(name, iconName)
	return GUI.parent().add{type = "checkbox", style = "item-icon-"..iconName, state = false, name = name}
end

function GUI.text_field(name, defaultText)
	if defaultText == nil then
		defaultText = ""
	end
	return GUI.parent().add{type = "textfield", name = name, text = defaultText}
end

function GUI.button(name, caption, methodName, delegate, args)
	local parent = GUI.parent()
	local button = parent.add{type = "button", name = name, caption = caption, style = style}
	local identifier = GUI.get_button_identifier(parent.gui.player, button)
	global.gui_button_callbacks[identifier] = {onclick = methodName, delegate = delegate, args = args}
	return button
end

function GUI.checkbox( name, caption, state, methodName, delegate, args )
	local parent = GUI.parent()
	local checkbox = parent.add{type = "checkbox", caption = caption, state = state}
	local identifier = GUI.get_button_identifier(parent.gui.player, checkbox)
	global.gui_button_callbacks[identifier] = {onclick = methodName, delegate = delegate, args = args}
end

function GUI.destroy_button( button )
	global.gui_button_callbacks[button.name] = nil
	button.destroy()
end

function GUI.get_button_identifier( player, button )
	return string.format("p_%s_%s", player.name, button.name)
end

function GUI.on_click( event )
	local playerIndex = event.player_index
	local button = event.element
	local identifier = GUI.get_button_identifier(game.players[playerIndex], button)
	local callback = global.gui_button_callbacks[identifier]

	if callback then
		local func = callback.delegate[callback.onclick]
		if func then
			func(callback.delegate, event, callback.args)
		end
	end
end
script.on_event(defines.events.on_gui_click, GUI.on_click)
