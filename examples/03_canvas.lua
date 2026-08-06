local gq = require("gqengine")

gq.enablePlugin(require("gqengine.plugins.GraphicsPlugin"))
gq.enablePlugin(require("gqengine.plugins.ScenesPlugin"))

gq.createWindow("Canvas", 800, 600)

local canvas = gq.createCanvas(300, 300)

local scene = gq.createScene("Game")

function scene:onRender(graphics)
    graphics.setCanvas(canvas)

    graphics.setColor(255, 0, 0)
    graphics.fillRect(50, 50, 200, 200)

    graphics.setCanvas()
    graphics.drawCanvas(canvas, 250, 150)
end

gq.registerScene(scene)

gq.run()