local Plugin = require("gqengine.core.Plugin")

local ScenesPlugin = Plugin.new("ScenesPlugin", Plugin.types.External)

local data = setmetatable({}, { __mode = "k" })

function ScenesPlugin:onAttach(engine)
    data[self] = {
        scenes = {},
        currentScene = nil
    }

    engine:registerAPI("createScene", function(name)
        return self:createScene(name)
    end)

    engine:registerAPI("registerScene", function(scene)
        self:registerScene(scene)
    end)

    engine:registerAPI("getCurrentScene", function()
        return self:getCurrentScene()
    end)

    engine:registerAPI("changeScene", function(name)
        self:changeScene(name)
    end)
end

function ScenesPlugin:onUpdate(dt)
    local state = data[self]

    if state.currentScene.onUpdate then
        state.currentScene:onUpdate(dt)
    end
end

-- Scene management

function ScenesPlugin:createScene(name)
    local scene = {name = name}
    return scene
end

function ScenesPlugin:registerScene(scene)
    local state = data[self]

    assert(not state.scenes[scene.name], string.format("Scene '%s' already exists", scene.name))

    state.scenes[scene.name] = scene
    if not state.currentScene then 
        state.currentScene = scene
        if state.currentScene.onEnter then state.currentScene:onEnter() end
    end
end

function ScenesPlugin:getCurrentScene()
    return data[self].currentScene
end

function ScenesPlugin:changeScene(name)
    local state = data[self]

    local nextScene = state.scenes[name]
    assert(nextScene, string.format("[ERROR] Scene named '%s' does not exist.", name))

    if state.currentScene and state.currentScene.onLeave then
        state.currentScene:onLeave()
    end

    state.currentScene = nextScene

    if state.currentScene.onEnter then
        state.currentScene:onEnter()
    end
end

return ScenesPlugin