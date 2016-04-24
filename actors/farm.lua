Farm = Actor{name = "farm", use_entity_gui = true}

local STATE_GROWING = 1
local STATE_RESETTING = 2
local config = homeworld_config.farm;

function Farm:init()
	local state = self.state
	state.current_production_interval = config.production_interval
	state.current_state = STATE_GROWING
	state.stage = 1

	-- Calculate soil richness.
	local surface = state.entity.surface
	local area = util.square_area(state.entity.position, config.radius)
	local total_area = 0
	local total_richness = 0
	for x, y in util.iarea(area) do
		local tile = surface.get_tile(x, y)
		local richness = 0
		if config.soil_richness[tile.name] then
			richness = config.soil_richness[tile.name]
		end
		total_area = total_area + 1
		total_richness = total_richness + richness
	end
	self.state.soil_richness = math.max(total_richness / total_area, 0)

	self:increment_production_timer()
end

function Farm:increment_production_timer()
	local state = self.state
	state.current_state = STATE_GROWING
	local deviation = math.random(-config.production_interval_deviation, config.production_interval_deviation)
	state.current_production_interval = config.production_interval + deviation
	state.next_yield_tick = game.tick + config.production_interval + deviation
end

function Farm:increment_reset_timer()
	local state = self.state
	state.current_state = STATE_RESETTING
	state.next_reset_tick = game.tick + config.reset_interval
end

function Farm:can_operate()
	local state = self.state
	return state.next_yield_tick
		and game.tick >= state.next_yield_tick
		and state.entity.valid
end

function Farm:can_reset()
	local state = self.state
	return state.next_reset_tick
		and game.tick >= state.next_reset_tick
		and state.entity.valid
end

function Farm:get_air_purity()
	local state = self.state
	local surface = state.entity.surface
	local pollution = surface.get_pollution(state.entity.position) * config.pollution_multiplier
	local air_purity = util.inverse_lerp(pollution, 0, config.max_pollution, 1, 0)
	air_purity = math.max(air_purity, 0)
	return air_purity
end

function Farm:get_yield( air_purity )
	local air_purity = air_purity or self:get_air_purity()
	local yield = math.max(self.state.soil_richness * air_purity, 0)
	return yield
end

function Farm:set_entity_stage( stage )
	local entity = self.state.entity
	if self.state.stage == stage or not entity.valid then
		return
	end
	self.state.stage = stage
	-- create new farm entity
	local surface = entity.surface
	local new_farm = surface.create_entity{
		name = config.farm_stages[stage],
		force = entity.force,
		position = entity.position
	}
	-- copy inventory
	local new_farm_inventory = new_farm.get_inventory(1)
	local old_farm_inventory = entity.get_inventory(1)
	for item_name, item_count in pairs(old_farm_inventory.get_contents()) do
		new_farm_inventory.insert{name = item_name, count = item_count}
	end
	-- replace state entity
	self.state.entity = new_farm
	entity.destroy()
end

function Farm:tick()
   local state = self.state
   if state.current_state == STATE_GROWING then
	  if self:can_operate() then
		local yield_multiplier = self:get_yield() * state.current_production_interval * (1/MINUTES)
		local inventory = state.entity.get_inventory(1)
		for i, produce in ipairs(config.produce) do
			local yield = math.max(produce.yield_per_min * yield_multiplier, 1)
			inventory.insert{name = produce.item_name, count = yield}
		end
		self:increment_reset_timer()
	  end
   elseif state.current_state == STATE_RESETTING then
		if self:can_reset() then
			self:set_entity_stage(1)
			self:increment_production_timer()
		end
   end

   if util.modulo_timer(5 * SECONDS) then
	  local production_tick = state.current_production_interval - (state.next_yield_tick - game.tick)
	  local increment = state.current_production_interval / #config.farm_stages
	  for i = #config.farm_stages, 1, -1 do
		 if production_tick >= (increment*i) then
			self:set_entity_stage(i)
			break
		 end
	  end
   end

   if util.modulo_timer(1 * SECONDS) then
	  for player_index, frame in pairs(state.gui) do
		 self:update_gui(player_index, state.gui)
	  end
   end
end

function Farm:show_gui( player_index, gui )
	GUI.push_left_section(player_index)
	gui[player_index] = GUI.push_parent(GUI.frame("farm_gui", "Farm", GUI.VERTICAL))
	GUI.label_data("richness", "Soil Richness:", "0%")
	GUI.label_data("purity", "Air Purity:", "0%")
	GUI.label_data("yield", "Yield:", "0%")
	GUI.pop_all()
	self:update_gui(player_index, gui)
end

function Farm:hide_gui( player_index, gui )
	gui[player_index].destroy()
	gui[player_index] = nil
end

function Farm:update_gui( player_index, gui )
	local format = "%i%%"
	local air_purity = self:get_air_purity()
	local yield = self:get_yield(air_purity)
	gui[player_index].richness.data.caption = string.format(format, math.floor(self.state.soil_richness * 100))
	gui[player_index].purity.data.caption = string.format(format, math.floor(air_purity * 100))
	gui[player_index].yield.data.caption = string.format(format, math.floor(yield * 100))
end
