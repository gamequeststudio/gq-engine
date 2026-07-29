local class = require("gqengine.internal.core.class")

--- Drawing surface bound to a window, serving as the user canvas for render callbacks.
---@class Canvas : Class
---@field width integer The width of the canvas in pixels.
---@field height integer The height of the canvas in pixels.
local Canvas = class()

--- Initializes a new Canvas instance with the specified dimensions.
---@param width integer The canvas width in pixels.
---@param height integer The canvas height in pixels.
function Canvas:init(width, height)
    self.width = width
    self.height = height
end

--- User-defined callback executed during the render phase.
--- Override this method or assign a function to draw on the canvas.
---@param graphics GraphicsContext The public graphics drawing API provided by the engine.
function Canvas:onRender(graphics)

end

return Canvas