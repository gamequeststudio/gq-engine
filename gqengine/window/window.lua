local class = require("gqengine.core.class")

--- Public window facade exposed to the game developer.
--- Wraps the internal `NativeWindow` instance to enforce encapsulation and prevent access to internal engine methods.
---@class PublicWindow : Class
---@field getCanvas fun(self: PublicWindow): Canvas Returns the active canvas bound to this window.
---@field setCanvas fun(self: PublicWindow, canvas: Canvas) Binds a new canvas instance to this window.
---@field getSize fun(self: PublicWindow): integer, integer Returns the width and height of the window in pixels.
---@field setSize fun(self: PublicWindow, width: integer, height: integer) Resizes the window to the specified dimensions.
local PublicWindow = class()

--- Private state storage mapping public instances to their native handles using weak keys.
---@type table<PublicWindow, any>
local private = setmetatable({}, { __mode = "k" })

--- Initializes a new PublicWindow instance wrapping a native window.
---@param nativeWindow any The internal NativeWindow instance to encapsulate.
function PublicWindow:init(nativeWindow)
    private[self] = nativeWindow
end

--- Whitelist of NativeWindow method names exposed on the public facade.
local publicWhiteList = {
    "getCanvas",
    "setCanvas",
    "getSize",
    "setSize",
    "setTitle"
}

-- Dynamically forwards whitelisted method calls to the underlying NativeWindow instance
for _, methodName in ipairs(publicWhiteList) do
    PublicWindow[methodName] = function(self, ...)
        local native = private[self]
        return native[methodName](native, ...)
    end
end

return PublicWindow