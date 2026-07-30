local SDL = require("SDL")

local PluginManager = require("gqengine.core.plugin_manager")
local FPSCounter = require("gqengine.core.fps_counter")
local NativeWindow = require("gqengine.window.native_window")
local PublicWindow = require("gqengine.window.window")

local Canvas = require("gqengine.canvas")

--- Internal core class managing application lifecycle, event polling, and main loop execution.
---@class CoreEngine
---@field pluginManager PluginManager The internal plugin manager subsystem.
---@field private window? NativeWindow The active native window instance, if initialized.
---@field private running boolean Flags whether the application main loop is active.
---@field publicAPI table The public API facade table returned when requiring the engine.
---@field private lastTick integer Timestamp of the last frame tick in milliseconds.
---@field private fpsCounter FPSCounter The utility responsible for measuring framerate performance.
local CoreEngine = {}

--- Initializes internal engine subsystems, state variables, and performance counters.
---@private
function CoreEngine:internalInit()
    self.pluginManager = PluginManager(self)
    self.running = false
    self.publicAPI = self:getPublicAPI()
    self.lastTick = SDL.getTicks()
    self.fpsCounter = FPSCounter()
end

--- Enables and registers a subsystem plugin into the engine.
---@param plugin Plugin The plugin instance to attach.
function CoreEngine:enablePlugin(plugin)
    self.pluginManager:addPlugin(plugin)
end

--- Creates the primary application window and exposes its public facade.
---@param title? string The title of the window.
---@param width? integer The width of the window in pixels.
---@param height? integer The height of the window in pixels.
---@return PublicWindow window The public window facade instance.
function CoreEngine:createWindow(title, width, height)
    assert(not self.window, "[GQEngine Error] Only one active window is supported.")
    self.window = NativeWindow(title, width, height)
    self.pluginManager:notify("onWindowCreated", self.window)
    return PublicWindow(self.window)
end

--- Returns the internal native window instance.
---@return NativeWindow? window The internal native window instance, if created.
function CoreEngine:getWindow()
    return self.window
end

--- Creates and returns a standalone Canvas surface.
---@param width integer The width of the canvas in pixels.
---@param height integer The height of the canvas in pixels.
---@return Canvas canvas The newly instantiated canvas.
function CoreEngine:createCanvas(width, height)
    local canvas = Canvas(width, height)
    return canvas
end

--- Builds and returns the public API facade table exposed to application space.
---@private
---@return table publicAPI Table containing all public engine methods.
function CoreEngine:getPublicAPI()
    return {
        enablePlugin = function(p) self:enablePlugin(p) end,
        createWindow = function(t, w, h) return self:createWindow(t, w, h) end,
        createCanvas = function(w, h) return self:createCanvas(w, h) end,
        getFPS = function() return self.fpsCounter:getFPS() end,
        run = function() self:mainloop() end,
    }
end

--- Starts deferred window display, enters the main loop, polls SDL events, and handles shutdown.
function CoreEngine:mainloop()
    -- Deferred Show: Perform initial off-screen render before revealing the window
    self.pluginManager:notify("onRender")
    if self.window and not self.window:isVisible() then
        self.window:show()
    end

    self.running = true
    while self.running do
        -- Process native SDL input and system events
        for event in SDL.pollEvent() do
            if event.type == SDL.event.Quit then
                self.running = false
            end
        end

        local currentTick = SDL.getTicks()
        local dt = (currentTick - self.lastTick) / 1000
        self.lastTick = currentTick
        self.fpsCounter:update(dt)
        self.pluginManager:notify("onUpdate", dt)

        -- Render frame pipeline
        self.pluginManager:notify("onRender")
    end

    SDL.quit()
end

-- Initialize core engine instance
CoreEngine:internalInit()

return CoreEngine.publicAPI