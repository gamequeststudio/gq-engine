--------------------------------------------------------------------------------
-- GQEngine - Example: Drawing Shapes on Canvas
-- 
-- Demonstrates how to enable the graphics plugin, retrieve the window canvas, 
-- set draw colors, clear the backbuffer, and render a centered rectangle.
--------------------------------------------------------------------------------

local gq = require("gqengine")
local GraphicsPlugin = require("gqengine.plugins.graphics")

--------------------------------------------------------------------------------
-- 1. PLUGIN & WINDOW SETUP
--------------------------------------------------------------------------------

-- Enable the 2D hardware-accelerated rendering plugin
gq.enablePlugin(GraphicsPlugin())

-- Create the primary window (640x480 pixels)
local window = gq.createWindow("Draw Rectangle", 640, 480)

-- Retrieve the active drawing canvas bound to the window
local canvas = window:getCanvas()

--------------------------------------------------------------------------------
-- 2. CANVAS RENDER CALLBACK
--------------------------------------------------------------------------------

-- Callback invoked on every render pass
function canvas:onRender(graphics)
    -- Set background color to Slate Blue (RGB) and clear the screen
    graphics.setColor(80, 80, 120)
    graphics.clear()

    -- Set active draw color to Solid White (RGB)
    graphics.setColor(255, 255, 255)

    -- Render a 120x120 filled rectangle centered on the canvas
    local rectSize = 120
    graphics.fillRect(
        self.width / 2 - rectSize / 2, 
        self.height / 2 - rectSize / 2, 
        rectSize, 
        rectSize
    )
end

--------------------------------------------------------------------------------
-- 3. ENGINE EXECUTION
--------------------------------------------------------------------------------

-- Start the main application event loop
gq.run()