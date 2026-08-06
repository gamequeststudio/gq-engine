local Plugin = {}
Plugin.__index = Plugin

Plugin.types = {
    Internal = 1,
    External = 2
}

-- Constructor

function Plugin.new(id, type)
    local self = setmetatable({}, Plugin)
    self._id = id or "GenericPlugin"
    self._type = type or Plugin.types.Internal
    return self
end

-- Getters

function Plugin:getId()
    return self._id
end

function Plugin:getType()
    return self._type
end

return Plugin