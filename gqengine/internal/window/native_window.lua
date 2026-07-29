local SDL = require("SDL")

local Canvas = require("gqengine.core.canvas")
local class = require("gqengine.internal.core.class")

--- Low-level wrapper around the native SDL window object and its surface/canvas properties.
---@class NativeWindow : Class
---@field private sdlWindow any The native SDL window handle.
---@field private visible boolean The visibility status of the window.
---@field private canvas Canvas The active canvas instance attached to this window.
local NativeWindow = class()

--- Initializes a new NativeWindow instance created initially in a hidden state.
---@param title? string The title of the window (default: "Untitled").
---@param width? integer The width of the window in pixels (default: 800).
---@param height? integer The height of the window in pixels (default: 600).
function NativeWindow:init(title, width, height)
    SDL.init { SDL.flags.Video }

    self.sdlWindow = SDL.createWindow {
        title = title or "Untitled",
        width = width or 800,
        height = height or 600,
        flags = { SDL.window.Hidden }
    }
    if not self.sdlWindow then error("[GQEngine Error] The native window could not be created.") end

    self.visible = false
    self.canvas = Canvas(self.sdlWindow:getSize())
end

--- Binds a new Canvas instance to the window.
---@param canvas Canvas The canvas object to attach.
function NativeWindow:setCanvas(canvas)
    assert(
        canvas.is and canvas:is(Canvas), 
        "[GQEngine Error] 'setCanvas' expected an object of type Canvas"
    )
    self.canvas = canvas
end

--- Shows the window on screen and marks it as visible.
function NativeWindow:show()
    if self.sdlWindow then
        self.sdlWindow:show()
        self.visible = true
    end
end

--- Hides the window from screen and marks it as invisible.
function NativeWindow:hide()
    self.sdlWindow:hide()
    self.visible = false
end

--- Returns the raw native SDL window handle for low-level/internal access.
---@return any sdlWindow The native SDL window handle.
function NativeWindow:getNativeHandle() 
    return self.sdlWindow 
end

--- Returns the Canvas instance bound to this window.
---@return Canvas canvas The attached canvas instance.
function NativeWindow:getCanvas() 
    return self.canvas 
end

--- Checks if the window is currently visible on screen.
---@return boolean visible True if visible, false otherwise.
function NativeWindow:isVisible() 
    return self.visible
end

--- Returns the current width and height of the window.
---@return integer width The window width in pixels.
---@return integer height The window height in pixels.
function NativeWindow:getSize() 
    return self.sdlWindow:getSize() 
end

return NativeWindow