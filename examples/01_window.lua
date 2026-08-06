local gq = require("gqengine")

local window = gq.createWindow("My Game", 800, 600)

window.setTitle("My First Game")
window.setSize(1024, 768)

local width, height = window:getSize()
print("Size: " .. width, height)

gq.run()