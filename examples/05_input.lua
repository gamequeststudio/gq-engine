local gq = require("gqengine")

gq.enablePlugin(require("gqengine.plugins.ScenesPlugin"))
gq.enablePlugin(require("gqengine.plugins.InputPlugin"))

gq.addInputAction("move_left", {"A"}, gq.devices.Keyboard)
gq.addInputAction("move_right", {"D"}, gq.devices.Keyboard)
gq.addInputAction("jump", {"Space"}, gq.devices.Keyboard)

gq.createWindow("Input", 800, 600)

local scene = gq.createScene("Game")

function scene:onUpdate(dt)
    if gq.isActionPressed("move_left") then
        print("Moving left")
    end

    if gq.isActionPressed("move_right") then
        print("Moving right")
    end

    if gq.isActionJustPressed("jump") then
        print("Jump")
    end

    if gq.isActionReleased("jump") then
        print("He released the jump button.")
    end
end

gq.registerScene(scene)
gq.run()