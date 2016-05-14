require("belt_actor")
BeltThroughputReader = Actor{name = "belt_throughput_reader", superclass = BeltActor}

local config = homeworld_config.belt_throughput_reader

function BeltThroughputReader:init()
    local state = self.state
    state.snapshots = {}
    state.snapshot_index = 1
end

function BeltThroughputReader:tick( dt ) 
    -- Find adjacent belts.
    local input_belt, output_belt = self:find_input_output_belt()
    if input_belt and output_belt then
        local transferred = self:transfer_belt_to_belt(input_belt, output_belt)
        -- Save the transferred items so we can average them over time.
        self:add_to_snapshots(transferred)
    else
        self:add_to_snapshots(nil)
    end
    
    -- Average the transferred items and output it as a signal.
    if ModuloTimer(config.calculate_throughput_interval) then
        local throughput = self:calculate_throughput()
        self:set_circuit_output(throughput)
        --PrintToAllPlayers(serpent.block(self.state.inventory))
        --PrintToAllPlayers(serpent.block(throughput))
    end
end

function BeltThroughputReader:add_to_snapshots( items )
    local state = self.state
    state.snapshots[state.snapshot_index] = items
    state.snapshot_index = state.snapshot_index + 1
    if (state.snapshot_index > config.max_snapshots) then
        state.snapshot_index = 1
    end
end

function BeltThroughputReader:find_belt_entity( origin, direction )
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

function BeltThroughputReader:calculate_throughput()
    local state = self.state
    local throughput = {}
    for index = 1, config.max_snapshots do
        local snapshot = state.snapshots[index]
        if snapshot then
            for item, count in pairs(snapshot) do
                if not throughput[item] then
                    throughput[item] = count
                else
                    throughput[item] = throughput[item] + count
                end
            end
        end
    end
    --[[
    for item, count in pairs(throughput) do
        local per = count / config.max_snapshots
        throughput[item] = per
    end
    ]]--
    return throughput
end

function BeltThroughputReader:set_circuit_output( throughput )
    local entity = self.state.entity
    local output = {}
    local index = 1
    for item, per in pairs(throughput) do
        local signal = {type = "item", name = item}
        local row = {index = index, count = math.floor(per), signal = signal}
        table.insert(output, row)
        index = index + 1
    end
    entity.set_circuit_condition(2, {parameters = output})
end