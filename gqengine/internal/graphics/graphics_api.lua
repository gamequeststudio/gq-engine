---@class SDLRenderer
---@field clear fun(self: SDLRenderer)
---@field setDrawColor fun(self:SDLRenderer, rect:table)
---@field fillRect fun(self:SDLRenderer, rect:table)
---@field drawRect fun(self:SDLRenderer, rect:table)

--- Public graphics context interface passed to canvas render callbacks.
---@class GraphicsContext
---@field clear fun() Clears the screen using the current draw color.
---@field setColor fun(r: integer, g: integer, b: integer, a?: integer) Sets the renderer draw color before issuing draw calls.
---@field fillRect fun(x?: number, y?: number, w: integer, h: integer) Draws a filled rectangle.
---@field lineRect fun(x?: number, y?: number, w: integer, h: integer) Draws a rectangle outline.

local GraphicsAPI = {}

--- Creates a graphics interface wrapper bound to a renderer instance
---@param renderer SDLRenderer The native SDL renderer instance.
---@return table api The public graphics drawing API.
function GraphicsAPI.load(renderer)
    ---@type GraphicsContext
    local api = {
        clear = function()
            renderer:clear()
        end,
        setColor = function(r, g, b, a)
            renderer:setDrawColor({r = r, g = g, b = b, a = a or 255})
        end,
        fillRect = function(x, y, w, h)
            renderer:fillRect({x = x or 0, y = y or 0, w = w, h = h})
        end,
        lineRect = function(x, y, w, h)
            renderer:drawRect({x = x or 0, y = y or 0, w = w, h = h})
        end
    }
    return api
end

return GraphicsAPI