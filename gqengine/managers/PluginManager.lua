local Plugin = require("gqengine.core.Plugin")

local PluginManager = {}
PluginManager.__index = PluginManager

-- Constructor

function PluginManager.new(engine)
    local self = setmetatable({}, PluginManager)

    self._engine = engine

    self._allPlugins = {}
    self._externalPlugins = {}
    self._internalPlugins = {}

    return self
end

-- Plugin management

function PluginManager:addPlugin(plugin)
    assert(getmetatable(plugin) == Plugin, "[ERROR] Function 'addPlugin' requires a Plugin object")

    local pluginType = plugin:getType()
    if pluginType == Plugin.types.Internal then
        self._internalPlugins[#self._internalPlugins + 1] = plugin
    elseif pluginType == Plugin.types.External then
        self._externalPlugins[#self._externalPlugins + 1] = plugin
    end

    self._allPlugins[#self._allPlugins+1] = plugin

    if plugin.onAttach then
        plugin:onAttach(self._engine)
    end
end

-- Event system

function PluginManager:notify(event, ...)
    local results = {}
    for i=1, #self._allPlugins do
        local plugin = self._allPlugins[i]
        if plugin[event] then
            local result = plugin[event](plugin, ...)
            if result then results[#results + 1] = result end
        end
    end
    return results
end

return PluginManager