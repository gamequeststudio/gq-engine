local SDL = require("SDL")
local PluginManager = require("gqengine.managers.PluginManager")

local Engine = {}

-- Initilization

function Engine:internalInit()
    self._running = false
    self._lastTick = 0

    self._pluginManager = PluginManager.new(self)

    self:_enablePlugin(require("gqengine.plugins.internal.WindowPlugin"))

    self._api = self:_generateAPI()
end

-- Window and scene creation

function Engine:_createWindow(title, windowWidth, windowHeight)
    local results = self._pluginManager:notify("onCreateWindow", title, windowWidth, windowHeight)
    return results[1]
end

-- Plugin management

function Engine:_enablePlugin(plugin)
    self._pluginManager:addPlugin(plugin)
end

-- SDL events

function Engine:_handleSDLEvents()
    for event in SDL.pollEvent() do
        if event.type == SDL.event.Quit then
            self._running = false
        end

        if event.type == SDL.event.KeyDown then
            local key = event.keysym.sym
            self._pluginManager:notify("onKeyDown", SDL.getKeyName(key))
        end

        if event.type == SDL.event.KeyUp then
            local key = event.keysym.sym
            self._pluginManager:notify("onKeyUp", SDL.getKeyName(key))
        end
    end
end

-- Public API

function Engine:registerAPI(name, callback)
    self._api[name] = callback
end

function Engine:getAPI()
    return self._api
end

function Engine:_generateAPI()
    return {
        createWindow = function(title, width, height) return self:_createWindow(title, width, height) end,
        enablePlugin = function(plugin) self:_enablePlugin(plugin) end,
        run = function() self:_run() end
    }
end

-- Main loop

function Engine:_run()
    self._pluginManager:notify("onLoad")

    self._running = true
    self._lastTick = SDL.getTicks()

    while self._running do
        self:_handleSDLEvents()

        local currentTick = SDL.getTicks()
        local dt = (currentTick - self._lastTick) / 1000
        self._lastTick = currentTick

        self._pluginManager:notify("onUpdate", dt)

        self._pluginManager:notify("onPreRender")
        self._pluginManager:notify("onRender")
        self._pluginManager:notify("onPostRender")
    end

    self._pluginManager:notify("onShutdown")
    SDL.quit()
end

return Engine