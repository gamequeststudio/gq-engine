local gq = require("gqengine")

gq.enablePlugin(require("gqengine.plugins.GraphicsPlugin"))
gq.enablePlugin(require("gqengine.plugins.ScenesPlugin"))

gq.createWindow("Transformations", 800, 600)

local scene = gq.createScene("Game")

function scene:onRender(graphics)
    graphics.setColor(255, 255, 255)

    graphics.push()

    graphics.translate(400, 300)
    graphics.rotate(math.pi / 4)
    graphics.scale(1.5, 1.5)

    graphics.fillRect(-50, -50, 100, 100)
    graphics.pop()
end

gq.registerScene(scene)

gq.run()