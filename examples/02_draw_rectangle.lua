local gq = require("gqengine")

local graphicsPlugin = require("gqengine.plugins.graphics")

gq.enablePlugin(graphicsPlugin)

local window = gq.createWindow("Draw Rectangle", 640, 480)
local canvas = window:getCanvas()

function canvas:onRender(graphics)
    graphics.setColor(80, 80, 120)
    graphics.clear()

    graphics.setColor(255, 255, 255)
    graphics.fillRect(canvas.width / 2 - 60, canvas.height / 2 - 60, 120, 120)
end

gq.run()