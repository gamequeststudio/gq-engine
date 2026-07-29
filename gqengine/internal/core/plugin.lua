local class = require("gqengine.internal.core.class")

--- Base class and interface for all GQEngine plugins.
--- Extend this and override lifecycle methods to inject custm funtionality.
---@class Plugin : Class
local Plugin = class()

--- Lifecycle callback executed when the plugin is attached to the engine context.
--- Override this method to perform initialization and acquire required core resources.
---@param core CoreEngine The internal engine context instance
function Plugin:onAttach(core)

end

--- Lifecycle callback executed every frame during the logic update phase.
---@param dt? number Time elapsed since the last frame in seconds (Delta Time).
function Plugin:onUpdate(dt)

end

--- Lifecycle callback executed every frame during the redering phase.
function Plugin:onRender()

end

return Plugin