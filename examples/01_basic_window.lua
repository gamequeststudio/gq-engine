--------------------------------------------------------------------------------
-- GQEngine - Example: Basic Window Setup
-- 
-- Demonstrates the bare minimum code required to initialize the engine,
-- create a native application window, and start the main loop.
--------------------------------------------------------------------------------

local gq = require("gqengine")

--------------------------------------------------------------------------------
-- 1. WINDOW INITIALIZATION
--------------------------------------------------------------------------------

-- Create the primary application window (640x480 pixels)
local window = gq.createWindow("Basic Window", 640, 480)

--------------------------------------------------------------------------------
-- 2. ENGINE EXECUTION
--------------------------------------------------------------------------------

-- Start the main engine loop (polls input events, updates ticks, and keeps window open)
gq.run()