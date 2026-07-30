local Plugin = require("gqengine.core.plugin")
local class = require("gqengine.core.class")

local Scene = require("gqengine.scene")

--- Scene management plugin responsible for scene lifecycles, deferred transitions, and state isolation.
---@class SceneManagerPlugin : Plugin
---@field private core CoreEngine Reference to the core engine instance.
---@field private registeredScenes table<string, Scene> Map of registered scenes indexed by their string IDs.
---@field private currentScene? Scene The currently active scene instance.
---@field private nextSceneId? string Identifier of the scene scheduled for transition on the next frame.
---@field private nextSceneData? any Optional payload data to be passed into the next scene's onLoad handler.
local SceneManagerPlugin = class(Plugin)

--- Attaches the plugin to the engine core and exposes its public facade (`gq.scenes`).
---@param engineCore CoreEngine The core engine instance.
function SceneManagerPlugin:onAttach(engineCore)
    SceneManagerPlugin.super.init(self, "SceneManagerPlugin")
    self.core = engineCore

    self.registeredScenes = {}
    self.currentScene = nil

    self.nextSceneId = nil
    self.nextSceneData = nil

    local corePublicAPI = self.core.publicAPI
    corePublicAPI.scenes = self:getPublicAPI()
end

--- Registers a new scene instance under a unique string identifier.
---@param id string Unique identifier for the scene.
---@param scene Scene Instance inheriting from the Scene base class.
function SceneManagerPlugin:registerScene(id, scene)
    assert(scene.is and scene:is(Scene), "[SceneManager Error] Provided scene must inherit from Scene base class.")
    self.registeredScenes[id] = scene
    if not self.currentScene then
        self.currentScene = scene
    end
end

--- Unregisters a scene by its identifier.
---@param id string Unique identifier of the scene to remove.
function SceneManagerPlugin:removeScene(id)
    if not self.registeredScenes[id] then return end
    self.registeredScenes[id] = nil
end

--- Schedules a deferred scene switch to be executed safely at the start of the next update cycle.
---@param id string Identifier of the target scene to switch to.
---@param data? any Optional context data to pass to the target scene's `onLoad(data)` callback.
function SceneManagerPlugin:changeScene(id, data)
    self.nextSceneId = id
    self.nextSceneData = data
end

--- Internal engine update callback. Processes deferred scene switches and updates the active scene.
---@param dt number Delta time in seconds since the previous frame.
function SceneManagerPlugin:onUpdate(dt)
    -- Process deferred scene transition if scheduled
    if self.nextSceneId then
        local id = self.nextSceneId
        local data = self.nextSceneData

        self.nextSceneId = nil
        self.nextSceneData = nil

        local scene = self.registeredScenes[id]
        if not scene then
            error(string.format("[SceneManager] A cena '%s' não foi registrada com addScene!", tostring(id)))
            return
        end

        self.currentScene = scene

        if self.currentScene.onLoad then
            self.currentScene:onLoad(data)
        end
    end

    -- Update active scene state
    if self.currentScene and self.currentScene.onUpdate then
        self.currentScene:onUpdate(dt)
    end
end

--- Returns the currently active scene instance.
---@return Scene? currentScene The current active scene, if set.
function SceneManagerPlugin:getCurrentScene()
    return self.currentScene
end

--- Builds and returns the public API facade table exposed to application space (`gq.scenes`).
---@private
---@return table publicAPI Table containing public scene management functions.
function SceneManagerPlugin:getPublicAPI()
    return {
        Scene = function()
            return Scene()
        end,
        addScene = function(id, scene)
            self:registerScene(id, scene)
        end,
        removeScene = function(id)
            self:removeScene(id)
        end,
        changeTo = function(id, data)
            self:changeScene(id, data)
        end,
        getCurrentScene = function()
            return self:getCurrentScene()
        end
    }
end

return SceneManagerPlugin