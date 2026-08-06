local gq = require("gqengine")

gq.enablePlugin(require("gqengine.plugins.GraphicsPlugin"))
gq.enablePlugin(require("gqengine.plugins.ScenesPlugin"))

gq.createWindow("Scenes", 800, 600)

local scene = gq.createScene("Game")

function scene:onEnter()
    print("Scene started")
end

function scene:onUpdate(dt)
    -- Update the scene
end

function scene:onRender(graphics)
    -- Render the scene
end

function scene:onLeave()
    print("Scene ended")
end

gq.registerScene(scene)

gq.run()