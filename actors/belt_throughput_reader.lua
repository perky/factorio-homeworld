BeltThroughputReader = Actor{name = "belt_throughput_reader"}

local config = {
    snapshot_interval = 1 * SECONDS,
    max_snapshots = 60
}

function BeltThroughputReader:init()
    self.state.snapshots = {}
    self.state.total = {}
    self.state.snapshot_index = 1
end

function BeltThroughputReader:tick( dt )
    if ModuloTimer(config.snapshot_interval) then
        self:snapshot_belt_contents()
    end
    if ModuloTimer(1 * MINUTES) then
        self.state.total = self:count_contents()
    end
end

function BeltThroughputReader:set_circuit_output()
end

function BeltThroughputReader:get_average_for( item_name )
    local total = self.state.total
    if total[item_name] then
        return total[item_name] / #self.state.snapshots
    else
        return 0
    end
end

function BeltThroughputReader:snapshot_belt_contents()
    local entity = self.state.entity
    local belts = entity.surface.find_entities_filtered{
        area = SquareArea(entity.position, 1),
        type = "belt"
    }
    local snapshot = {}
    for i, belt in ipairs(belts) do
        local lane1 = belt.get_transport_line(1).get_contents()
        local lane2 = belt.get_transport_line(2).get_contents()
        table.insert(snapshot, lane1)
        table.insert(snapshot, lane2)
    end
    
    self.state.snapshots[self.state.snapshot_index] = snapshot
    self.state.snapshot_index = self.state.snapshot_index + 1
    if self.state.snapshot_index > config.max_snapshots then
        self.state.snapshot_index = 1
    end
end

function BeltThroughputReader:count_contents()
    local total = {}
    for i, contents in ipairs(self.state.snapshots) do
        for item_name, count in ipairs(contents) do
            if total[item_name] then
                total[item_name] = total[item_name] + count
            else
                total[item_name] = count
            end
        end
    end
    return total
end