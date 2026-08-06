local Plugin = require("gqengine.core.Plugin")

local InputPlugin = Plugin.new("InputPlugin", Plugin.types.External)

local devices = {
    Mouse = 1,
    Keyboard = 2,
    Gamepad = 3
}

local data = setmetatable({}, { __mode = "k" })

function InputPlugin:onAttach(engine)
    data[self] = {
        actions = {},
        pressedKeys = {},
        justPressedKeys = {},
        releasedKeys = {},
    }

    engine:registerAPI("devices", devices)

    engine:registerAPI("addInputAction", function(action, keys, device) 
        self:registerAction(action, keys, device) 
    end)

    engine:registerAPI("isActionPressed", function(action) 
        return self:checkActionPressed(action) 
    end)

    engine:registerAPI("isActionJustPressed", function(action) 
        return self:checkActionJustPressed(action) 
    end)

    engine:registerAPI("isActionReleased", function(action) 
        return self:checkActionReleased(action) 
    end)
end

function InputPlugin:onUpdate(dt)
    local state = data[self]
    state.justPressedKeys = {}
    state.releasedKeys = {}
end

-- Actions

function InputPlugin:registerAction(action, keys, device)
    local state = data[self]

    assert(not state.actions[action], string.format("[ERROR] Action '%s' already exists.", action))
    assert(type(keys) == "table", "[ERROR] Keys must be provided in a table.")

    state.actions[action] = {keys = keys, device = device}
end

function InputPlugin:checkActionPressed(action)
    local state = data[self]

    local inputAction = state.actions[action]
    if not inputAction then return false end

    if inputAction.device == devices.Keyboard then
        for i=1, #inputAction.keys do
            local key = inputAction.keys[i]
            if state.pressedKeys[key] then
                return true
            end
        end
    end

    return false
end

function InputPlugin:checkActionJustPressed(action)
    local state = data[self]

    local inputAction = state.actions[action]
    if not inputAction then return false end

    if inputAction.device == devices.Keyboard then
        for i=1, #inputAction.keys do
            local key = inputAction.keys[i]
            if state.justPressedKeys[key] then
                return true
            end
        end
    end

    return false
end

function InputPlugin:checkActionReleased(action)
    local state = data[self]

    local inputAction = state.actions[action]
    if not inputAction then return false end

    if inputAction.device == devices.Keyboard then
        for i=1, #inputAction.keys do
            local key = inputAction.keys[i]
            if state.releasedKeys[key] then
                return true
            end
        end
    end

    return false
end

-- Keyboard events  

function InputPlugin:onKeyDown(key)
    local state = data[self]

    if not state.pressedKeys[key] then
        state.justPressedKeys[key] = true
    end
    state.pressedKeys[key] = true
end

function InputPlugin:onKeyUp(key)
    local state = data[self]

    state.releasedKeys[key] = true
    state.pressedKeys[key] = false
end

return InputPlugin