local SDL = require("SDL")

local PluginManager = require("gqengine.internal.core.plugin_manager")

local NativeWindow = require("gqengine.internal.window.native_window")
local PublicWindow = require("gqengine.core.window")

local Canvas = require("gqengine.core.canvas")

--- Internal core class managing application lifecycle, event polling, and main loop execution.
---@class CoreEngine
---@field private pluginManager PluginManager The internal plugin manager subsystem.
---@field private window? NativeWindow The active native window instance, if initialized.
---@field private running boolean Flags whether the application main loop is active.
local CoreEngine = {}

--- Initializes internal engine subsystems and state variables.
---@private
function CoreEngine:internalInit()
    self.pluginManager = PluginManager(self)
    self.running = false
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
---@private
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

--- Starts the deferred window display, enters the main loop, processes SDL events, and manages shutdown.
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

        -- Render frame pipeline
        self.pluginManager:notify("onRender")
    end

    SDL.quit()
end

-- Initialize core engine instance
CoreEngine:internalInit()

--- Public API interface exposed when requiring the GQEngine module.
---@class GQEngineModule
---@field enablePlugin fun(plugin: Plugin) Enables and attaches a plugin to the engine.
---@field createWindow fun(title?: string, width?: integer, height?: integer): PublicWindow Creates and registers the application window.
---@field createCanvas fun(width: integer, height: integer): Canvas Factory method to instantiate a new Canvas.
---@field run fun() Starts the engine main execution loop.
return {
    enablePlugin = function(p) CoreEngine:enablePlugin(p) end,
    createWindow = function(t, w, h) return CoreEngine:createWindow(t, w, h) end,
    createCanvas = function(w, h) return CoreEngine:createCanvas(w, h) end,
    run = function() CoreEngine:mainloop() end
}