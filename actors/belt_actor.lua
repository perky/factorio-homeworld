BeltActor = {}

local DIRECTION_ORTHO = {
    [defines.direction.south] = {defines.direction.west, defines.direction.east},
    [defines.direction.north] = {defines.direction.west, defines.direction.east},
    [defines.direction.west] = {defines.direction.north, defines.direction.south},
    [defines.direction.east] = {defines.direction.north, defines.direction.south}
}

function BeltActor:find_adjacent_belts()
    local entity = self.state.entity
    local belts = {}
    belts[defines.direction.south] = self:find_belt_entity(entity.position, defines.direction.south)
    belts[defines.direction.west] = self:find_belt_entity(entity.position, defines.direction.west)
    belts[defines.direction.north] = self:find_belt_entity(entity.position, defines.direction.north)
    belts[defines.direction.east] = self:find_belt_entity(entity.position, defines.direction.east)
    return belts
end

function BeltActor:find_input_output_belt()
    local belts = self:find_adjacent_belts()
    for direction, belt in pairs(belts) do
        if belt and belt.valid and belt.direction == DIRECTION_INVERSE[direction] then
            local output_belt = belts[belt.direction]
            if output_belt and output_belt.valid and output_belt.direction == belt.direction then
                return belt, output_belt
            end
        end
    end
    
    return nil, nil
end

function BeltActor:find_input_orthogonal_output_belt()
    local belts = self:find_adjacent_belts()
    for direction, belt in pairs(belts) do
        if belt and belt.valid and belt.direction == DIRECTION_INVERSE[direction] then
            for _, orth_dir in ipairs(DIRECTION_ORTHO[direction]) do
                local output_belt = belts[orth_dir]
                if output_belt and output_belt.valid and output_belt.direction == orth_dir then
                    return belt, output_belt
                end
            end
        end
    end
    
    return nil, nil
end

function BeltActor:find_belt_entity( origin, direction )
    local area = SquareArea(origin, 0.5)
    local offset = DIRECTION_OFFSET[direction]
    for i = 1, 2 do
        area[i].x = area[i].x + offset.x
        area[i].y = area[i].y + offset.y
    end
    local belts = self.state.entity.surface.find_entities_filtered{
        area = area,
        type = "transport-belt"
    }
    if #belts > 0 then
        return belts[1]
    else
        return nil
    end
end

function BeltActor:transfer_belt_to_belt( belt_in, belt_out )
    assertion.not_nil(belt_in)
    assertion.not_nil(belt_out)
    local transferred = {}
    for index, line in transport_lines(belt_in) do
        local contents = line.get_contents()
        for name, count in pairs(contents) do
            local item_stack = {name = name, count = 1}
            if belt_out.get_transport_line(index).can_insert_at_back() then
                belt_out.get_transport_line(index).insert_at_back(item_stack)
                belt_in.remove_item(item_stack)
                if transferred[name] then
                    transferred[name] = transferred[name] + count
                else
                    transferred[name] = count
                end
            end
        end
    end
    return transferred
end