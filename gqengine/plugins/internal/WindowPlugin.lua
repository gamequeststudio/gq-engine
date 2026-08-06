local SDL = require("SDL")
local Plugin = require("gqengine.core.Plugin")

local data = setmetatable({}, { __mode = "k" })

local WindowPlugin = Plugin.new("WindowPlugin")

-- SDL window
function WindowPlugin:setupSDLWindow(title, width, height)
    local state = data[self]

    if not SDL.wasInit(SDL.flags.Video) then
        assert(SDL.init { SDL.flags.Video }, "[INTERNAL ERROR] SDL couldn't init video system. SDL_ERROR: " .. SDL.getError())
    end

    if state.window then
        error("[ERROR] GQEngine does not support multiple windows.")
    end

    state.window = SDL.createWindow {
        title = title or "GQEngine",
        width = width or 800,
        height = height or 600,
        flags = { SDL.window.Shown }
    }

    if not state.window then 
        error("[INTERNAL ERROR] The window could not be created. SDL_ERROR: " .. SDL.getError())
    end
end

-- Lifecycle

function WindowPlugin:onAttach()
    data[self] = {
        window = nil,
        api = nil
    }
end

function WindowPlugin:onCreateWindow(title, width, height)
    local state = data[self]
    self:setupSDLWindow(title, width, height)
    state.api = self:generateWindowAPI()
    return state.api
end

-- Internal access

function WindowPlugin:getSDLWindow()
    return data[self].window
end

function WindowPlugin:getAPI()
    return data[self].api
end

function WindowPlugin:getSize()
    return data[self].window:getSize()
end

-- Public API

function WindowPlugin:generateWindowAPI()
    local state = data[self]

    return {
        getTitle = function() return
            state.window:getTitle()
        end,

        getSize = function()
            return state.window:getSize()
        end,

        getPosition = function()
            return state.window:getPosition()
        end,

        setTitle = function(title)
            state.window:setTitle(title or "GQEngine")
        end,

        setSize = function(width, height)
            assert(width and height, "The function 'setSize' expects a width and a height")
            state.window:setSize(width, height)
        end,

        setPosition = function(x, y)
            state.window:setPosition(x or 0, y or 0)
        end
    }
end

return WindowPlugin