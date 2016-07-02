-- Where actor class definitions are stored.
_actor_classes = {}

-- Method to create an actor class.
function Actor( params )
    local o = {}
    assertion.not_nil(params.name, "Name is nil in Actor params")
    local classname = params.name
    local use_entity_gui = params.use_entity_gui or false
    local use_proximity_gui = params.use_proximity_gui or false

    -- store the class name.
    o._classname = classname
    o._instances = {}
    local class_mt = {__index = o}
    -- Superclass
    if params.superclass then
        setmetatable(o, {__index = params.superclass})
    end
    -- the new method used to instantiate an actor.
    o.new = function(self, entity, state)
        local actor = {}
        table.insert(o._instances, actor)
        -- set the metatable to allow OOP behaviour.
        setmetatable(actor, class_mt)
        --self.__index = self
        -- create a new state table or use the one provided.
        if state then
            actor.state = state
            actor.state.entity = entity or state.entity
        else
            actor.state = {_classname = classname, entity = entity}
            -- store the state table inside global (for persistant state).
            if (global.actor_states == nil) then
                global.actor_states = {}
            end
            table.insert(global.actor_states, actor.state)
            -- call init for setup of defaults etc.
            if actor.init then actor:init() end
            if use_entity_gui or use_proximity_gui then
                actor.state.gui = {}
            end
        end
        -- call load
        if actor.load then actor:load() end
        return actor
    end
    o.destroy_if = function(self, predicate)
        for i = #o._instances, 1, -1 do
            local actor = o._instances[i]
            if (predicate(actor)) then
                table.remove( o._instances, i )
                if actor.destroy then actor:destroy() end
            end
        end
    end
    o.tick = function(self) end
    if use_entity_gui then
        o._tick_gui = function(self)
            for player_index = 1, #game.players do
                if game.players[player_index].opened == self.state.entity then
                    if self.state.gui[player_index] == nil then
                        self:show_gui(player_index, self.state.gui)
                    end
                elseif self.state.gui[player_index] then
                    self:hide_gui(player_index, self.state.gui)
                end
            end
        end
    elseif use_proximity_gui then
        o._tick_gui = function(self)
            if ModuloTimer(30) then
                local near_players = nearest_players{
                   origin = self.state.entity.position,
                   max_distance = params.gui_proximity_radius or 2
                }
                for index, player in ipairs(near_players) do
                    self:show_gui(index)
                end
                local far_players = table.except(game.players, near_players)
                for index, player in ipairs(far_players) do
                    self:hide_gui(index)
                end
            end
        end
    else
        o._tick_gui = function(self) end
    end
    -- store the actor class by name so that we can easily instantiate
    -- if we only have it's name and state.
    _actor_classes[o._classname] = o
    return o
end

function load_persisted_actors()
    if not global.actor_states then
        return
    end
    local instantiated_actors = {}
    for _, state in ipairs(global.actor_states) do
        local a = _actor_classes[state._classname]:new(nil, state)
        table.insert(instantiated_actors, a)
    end
    return a
end

function tick_all_actors( tick )
    for classname, class in pairs(_actor_classes) do
        for _, actor in ipairs(class._instances) do
            if actor.state.entity and actor.state.entity.valid then
                actor:_tick_gui()
                actor:tick( tick )
            end
        end
    end
end

_entity_actors = {}
function register_entity_actor( class, entity_name )
    _entity_actors[entity_name] = class
end

function create_entity_actor( entity )
    if _entity_actors[entity.name] then
        return _entity_actors[entity.name]:new(entity)
    end
end

function destroy_entity_actor( entity )
    if _entity_actors[entity.name] then
        _entity_actors[entity.name]:destroy_if(function(x)
            return x.state.entity == entity
        end)
    end
end
