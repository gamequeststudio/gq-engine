local SDL = require("SDL")

local Plugin = require("gqengine.internal.core.plugin")
local GraphicsAPI = require("gqengine.internal.graphics.graphics_api")
local class = require("gqengine.internal.core.class")

--- Core engine plugin responsible for 2D hardware-accelerated rendering and pipeline management.
---@class GraphicsPlugin : Plugin
---@field core any The engine context providing internal subsystem access.
---@field renderer any The native SDL renderer handle instance.
---@field publicAPI table The public graphics drawing API injected into the canvas.
local GraphicsPlugin = class(Plugin)

--- Called when the plugin is attached to the engine context.
---@param engineCore CoreEngine The core engine context instance.
function GraphicsPlugin:onAttach(engineCore)
    self.core = engineCore

    local window = self.core:getWindow()
    if window then self:setupRenderer(window) end
end

--- Initialize the native SDL renderer and prepares the public Graphics API.
---@private
---@param window NativeWindow The native window instance.
function GraphicsPlugin:setupRenderer(window)
    local sdlWindow = window:getNativeHandle()

    -- Creates the GPU-accelerated renderer
    self.renderer = SDL.createRenderer(sdlWindow, -1, SDL.rendererFlags.Accelerated)
    self.renderer:setDrawColor({r = 0, g = 0, b = 0, a = 255})
    self.renderer:clear()

    -- Instantiates the drawing interface
    self.publicAPI = GraphicsAPI.load(self.renderer)
end

--- Lifecycle event triggered when a new window is created by the engine.
---@param window NativeWindow The newly created window instance.
function GraphicsPlugin:onWindowCreated(window)
    if not self.renderer then self:setupRenderer(window) end
end

--- Hot path lifecycle method executed every frame to render graphics onto the window canvas.
function GraphicsPlugin:onRender()
    local window = self.core:getWindow()
    local renderer = self.renderer

    -- Grad clause: Skip rendering if window or renderer is unavaliable or invisible
    if not window or not renderer or not window:isVisible() then return end

    -- 1. Clear backbuffer with default black background
    renderer:setDrawColor({r = 0, g = 0, b = 0, a = 255})
    renderer:clear()

    -- 2. Render user content on the active canvas
    local canvas = window:getCanvas()
    if canvas and canvas.onRender then
        canvas:onRender(self.publicAPI)
    end

    -- 3. Swap framebuffers to display on screen
    renderer:present()
end

return GraphicsPlugin