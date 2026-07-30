local Canvas = require("gqengine.canvas")
local class = require("gqengine.core.class")

--- Base class representing a game scene with lifecycle callbacks, state flags, and display controls.
---@class Scene : Class
---@field public enabled boolean Flags whether scene update logic is active.
---@field public visible boolean Flags whether scene rendering is active.
local Scene = class()

--- Initializes default scene state flags (`enabled = true`, `visible = true`).
function Scene:init()
    self.enabled = true
    self.visible = true
end

--- Pauses scene logic updates by disabling its `enabled` state flag.
function Scene:pause()
    self.enabled = false
end

--- Resumes scene logic updates by enabling its `enabled` state flag.
function Scene:resume()
    self.enabled = true
end

--- Disables scene rendering by setting its `visible` state flag to false.
function Scene:hide()
    self.visible = false
end

--- Enables scene rendering by setting its `visible` state flag to true.
function Scene:show()
    self.visible = true
end

--- Checks whether the scene is currently marked as visible for rendering.
---@return boolean visible True if visible, false otherwise.
function Scene:isVisible()
    return self.visible
end

--- Checks whether the scene is currently enabled for frame updates.
---@return boolean enabled True if enabled, false otherwise.
function Scene:isEnabled()
    return self.enabled
end

--- Lifecycle callback invoked when the scene is loaded or transitioned into.
--- Override this method in derived scenes to initialize scene entities and state.
---@param data? any Optional payload data passed during transition via `changeTo(id, data)`.
function Scene:onLoad(data)
end

--- Lifecycle callback invoked on every engine frame update.
--- Override this method in derived scenes to update game logic, physics, and state.
---@param dt number Delta time in seconds since the previous frame.
function Scene:onUpdate(dt)
end

--- Lifecycle callback invoked on every engine render pass.
--- Override this method in derived scenes to execute drawing commands.
---@param graphics table The graphics plugin API facade used for rendering commands.
function Scene:onRender(graphics)
end

return Scene