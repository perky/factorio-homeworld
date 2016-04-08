Sawmill = Actor{name = "Sawmill"}

local config = homeworld_config.sawmill

function Sawmill:init()
    self:increment_saw_timer()
end

function Sawmill:increment_saw_timer()
    self.state.next_saw_tick = game.tick + config.saw_interval
end

function Sawmill:input_inventory()
    return self.state.entity.get_inventory(2)
end

function Sawmill:can_operate(tick)
    local entity = self.state.entity
    return tick >= self.state.next_saw_tick
        and entity.valid
        and (entity.energy > 0 or self:input_inventory().is_empty())
end

function Sawmill:tick( tick )
    if self:can_operate(tick) then
        self:increment_saw_timer()
        local item = {name = "sawmill-tree", count = config.tree_multiplier}
        local input_inventory = self:input_inventory()
        if input_inventory.can_insert(item) then
            local entity = self.state.entity
            local nearby_trees = entity.surface.find_entities_filtered{
                area = SquareArea(entity.position, config.work_radius),
                type = "tree"
            }
            if #nearby_trees > 0 then
                table.shuffle(nearby_trees)
                nearby_trees[1].destroy()
                input_inventory.insert(item)
            end
        end
    end
end
