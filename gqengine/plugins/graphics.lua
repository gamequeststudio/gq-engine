local SDL = require("SDL")

local Plugin = require("gqengine.core.plugin")
local class = require("gqengine.core.class")

--- Core engine plugin responsible for 2D hardware-accelerated rendering and pipeline management.
---@class GraphicsPlugin : Plugin
---@field private core CoreEngine The core engine context providing internal subsystem access.
---@field private renderer any The native SDL renderer handle instance.
---@field private publicAPI GraphicsContext The public graphics drawing API facade.
---@field private sceneManager? SceneManagerPlugin Cached reference to the scene manager plugin instance.
---@field private checkedSceneManager boolean Flag indicating whether scene manager lookup was attempted.
local GraphicsPlugin = class(Plugin)

--- Initializes the GraphicsPlugin instance.
function GraphicsPlugin:init()
    GraphicsPlugin.super.init(self, "GraphicsPlugin")
end

--- Called when the plugin is attached to the engine context.
---@param engineCore CoreEngine The core engine context instance.
function GraphicsPlugin:onAttach(engineCore)
    self.core = engineCore
    self.sceneManager = nil
    self.checkedSceneManager = false

    local window = self.core:getWindow()
    if window then self:setupRenderer(window) end
end

--- Lazily retrieves and caches the SceneManagerPlugin instance from the plugin manager.
---@private
---@return SceneManagerPlugin? sceneManager The cached scene manager plugin instance, if active.
function GraphicsPlugin:getSceneManager()
    if not self.checkedSceneManager then
        self.sceneManager = self.core.pluginManager:getPluginByName("SceneManagerPlugin")
        self.checkedSceneManager = true
    end
    return self.sceneManager
end

--- Initializes the native SDL renderer and prepares the public Graphics API.
---@private
---@param window NativeWindow The native window instance.
function GraphicsPlugin:setupRenderer(window)
    local sdlWindow = window:getNativeHandle()

    -- Creates the GPU-accelerated renderer
    self.renderer = SDL.createRenderer(sdlWindow, -1, SDL.rendererFlags.Accelerated)
    self.renderer:setDrawColor({r = 0, g = 0, b = 0, a = 255})
    self.renderer:clear()

    -- Instantiates the drawing interface
    self.publicAPI = self:getPublicAPI()
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

    -- Guard clause: Skip rendering if window or renderer is unavailable or invisible
    if not window or not renderer or not window:isVisible() then return end

    -- 1. Clear backbuffer with default black background
    renderer:setDrawColor({r = 0, g = 0, b = 0, a = 255})
    renderer:clear()

    -- 2. Render active scene context
    local sceneManager = self:getSceneManager()
    if sceneManager then
        local scene = sceneManager:getCurrentScene()
        if scene and scene:isVisible() then
            scene:onRender(self.publicAPI)
        end
    end

    -- 3. Render user content on the active canvas facade
    local canvas = window:getCanvas()
    if canvas and canvas.onRender then
        canvas:onRender(self.publicAPI)
    end

    -- 4. Swap framebuffers to display on screen
    renderer:present()
end

--- Public graphics context interface passed to canvas and scene render callbacks.
---@class GraphicsContext
---@field clear fun() Clears the screen using the current draw color.
---@field setColor fun(r: integer, g: integer, b: integer, a?: integer) Sets the renderer draw color before issuing draw calls.
---@field fillRect fun(x?: number, y?: number, w: integer, h: integer) Draws a filled rectangle.
---@field lineRect fun(x?: number, y?: number, w: integer, h: integer) Draws a rectangle outline.
---@field line fun(x1: number, y1: number, x2: number, y2: number) Draws a straight line between two points.

--- Builds and returns the public graphics context API table.
---@private
---@return GraphicsContext publicAPI Table containing public drawing functions.
function GraphicsPlugin:getPublicAPI()
    ---@type GraphicsContext
    return {
        clear = function()
            self.renderer:clear()
        end,
        setColor = function(r, g, b, a)
            self.renderer:setDrawColor({r = r, g = g, b = b, a = a or 255})
        end,
        fillRect = function(x, y, w, h)
            self.renderer:fillRect({x = x or 0, y = y or 0, w = w, h = h})
        end,
        lineRect = function(x, y, w, h)
            self.renderer:drawRect({x = x or 0, y = y or 0, w = w, h = h})
        end,
        line = function(x1, y1, x2, y2)
            self.renderer:drawLine(x1, y1, x2, y2)
        end
    }
end

return GraphicsPlugin