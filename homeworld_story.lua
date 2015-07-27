require "defines"
require "story"

local homeworld_storytable =
{{
	{
		action =
	    function()
	      game.show_message_dialog{text = "homeworld test intro"}
	    end
	}
}}

homeworld_story = story.Story:new(homeworld_storytable)

game.on_event(defines.events, function(event)
  homeworld_story:update(event, "")
end)

game.on_save(function()
  global.storydata = homeworld_story:export()
end)

game.on_load(function()
  homeworld_story:import(global.storydata)
end)