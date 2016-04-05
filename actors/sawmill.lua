Sawmill = Actor{name = "Sawmill"}

function Sawmill:init()
    -- set defaults
    local state = self.state
    state.saw_interval = 10 * SECONDS
    state.work_radius = 20
    self:increment_saw_timer()
end

function Sawmill:increment_saw_timer()
    self.state.next_saw_tick = game.tick + self.state.saw_interval
end

function Sawmill:can_operate(tick)
    return tick >= self.state.next_saw_tick
        and self.state.entity.valid
        and self.state.entity.energy > 0
end

function Sawmill:tick( tick )
    if self:can_operate(tick) then
        self:increment_saw_timer()
        local item = {name = "sawmill-tree", count = 1}
        local input_inventory = self.state.entity.get_inventory(2)
        if input_inventory.can_insert(item) then
            local pos = self.state.entity.position
            local r = self.state.work_radius
            local nearby_entities = self.state.entity.surface.find_entities{
                {pos.x - r, pos.y - r}, {pos.x + r, pos.y + r}
            }
            local nearby_trees = table.where(nearby_entities, function(x)
                return x.valid and x.type == "tree"
            end)
            if #nearby_trees > 0 then
                table.shuffle(nearby_trees)
                nearby_trees[1].destroy()
                input_inventory.insert(item)
            end
        end
    end
end
