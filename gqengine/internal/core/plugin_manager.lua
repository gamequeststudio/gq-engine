local Plugin = require("gqengine.internal.core.plugin")
local class = require("gqengine.internal.core.class")

--- Core manager resposible for resgistering, attaching, and notifying engine plugins.
---@class PluginManager : Class
---@field owner any The target engine context passed to plugins during attachment.
---@field allPlugins Plugin[] List of all registered plugins.
---@field updatePlugins Plugin[] Sublist of plugins implementing the `onUpdate` lifecycle method.
---@field renderPlugins Plugin[] Sublist of plugins implementing the `onRender` lifecycle method.
local PluginManager = class()

--- Initialize a new instance of the PluginManager.
---@param owner any The engine context instance to be shared with plugins.
function PluginManager:init(owner)
    self.owner = owner
    self.allPlugins = {}
    self.updatePlugins = {}
    self.renderPlugins = {}
end

--- Broadcasts a lifecycle event to all registered plugins.
---@param eventName string The name of the event method to invoke on plugins (e.g., "onRender", "onWindowCreated").
---@param ... any Optional arguments passed directly to the plugin evnet method.
function PluginManager:notify(eventName, ...)
    local all = self.allPlugins
    for i=1, #all do
        local plugin = all[i]
        local method = plugin[eventName]
        if method then
            method(plugin, ...)
        end
    end
end

--- Registered and attaches a new plugin to the engine.
---@param plugin Plugin An instance of a class inheriting from Plugin.
function PluginManager:addPlugin(plugin)
    assert(
        type(plugin) == "table" and plugin.is and plugin:is(Plugin), 
        "[GQEngine Error] 'enablePlugin' esperava um objeto do tipo Plugin"
    )
    
    -- Attach the plugin to the internal engine context
    plugin:onAttach(self.owner)

    -- Register in master list and categorized sub-lists
    table.insert(self.allPlugins, plugin)
    if plugin.onUpdate then table.insert(self.updatePlugins, plugin) end
    if plugin.onRender then table.insert(self.renderPlugins, plugin) end
end

return PluginManager