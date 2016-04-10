require('belt_actor')
BeltGate = Actor{name = "belt_gate", superclass = BeltActor}

function BeltGate:init()
end

function BeltGate:tick( dt )
    local entity = self.state.entity
    local condition = entity.get_circuit_condition(1)
    local input_belt, output_belt = nil, nil
    if condition.fulfilled then
        input_belt, output_belt = self:find_input_output_belt()
    else
        input_belt, output_belt = self:find_input_orthogonal_output_belt()
    end
    if input_belt and output_belt then
        self:transfer_belt_to_belt(input_belt, output_belt)
    end
end