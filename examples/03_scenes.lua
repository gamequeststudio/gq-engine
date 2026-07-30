--------------------------------------------------------------------------------
-- GQEngine - Minimal Example: Scene Management and Switching
-- 
-- Demonstrates how to initialize plugins, create two independent scenes,
-- update the window title on each transition, and handle a simple timer.
--------------------------------------------------------------------------------

local gq = require("gqengine")

--------------------------------------------------------------------------------
-- 1. PLUGIN & WINDOW INITIALIZATION
--------------------------------------------------------------------------------

-- Enable 2D rendering and scene management plugins
gq.enablePlugin(require("gqengine.plugins.graphics")())
gq.enablePlugin(require("gqengine.plugins.scene_manager")())

-- Create the main application window (640x480 pixels)
local window = gq.createWindow("Initial Scene", 640, 480)

--------------------------------------------------------------------------------
-- 2. SCENE 1 DEFINITION (Red Background)
--------------------------------------------------------------------------------
local scene1 = gq.scenes.Scene()

-- Callback invoked when loading or transitioning into this scene
function scene1:onLoad()
    window:setTitle("GQEngine - [SCENE 1 ACTIVE]")
    self.timer = 0 -- Reset internal time counter
end

-- Callback invoked every frame to update scene logic
function scene1:onUpdate(dt)
    self.timer = self.timer + dt
    
    -- Transition to 'scene2' after 2 accumulated seconds
    if self.timer >= 2 then 
        gq.scenes.changeTo("scene2") 
    end
end

-- Callback invoked every frame to render visual content
function scene1:onRender(graphics)
    graphics.setColor(180, 50, 50) -- Red color (RGB)
    graphics.clear()                -- Fill screen with the selected color
end

--------------------------------------------------------------------------------
-- 3. SCENE 2 DEFINITION (Green Background)
--------------------------------------------------------------------------------
local scene2 = gq.scenes.Scene()

-- Callback invoked when loading or transitioning into this scene
function scene2:onLoad()
    window:setTitle("GQEngine - [SCENE 2 ACTIVE]")
    self.timer = 0 -- Reset internal time counter
end

-- Callback invoked every frame to update scene logic
function scene2:onUpdate(dt)
    self.timer = self.timer + dt
    
    -- Transition back to 'scene1' after 2 accumulated seconds
    if self.timer >= 2 then 
        gq.scenes.changeTo("scene1") 
    end
end

-- Callback invoked every frame to render visual content
function scene2:onRender(graphics)
    graphics.setColor(50, 180, 50) -- Green color (RGB)
    graphics.clear()                -- Fill screen with the selected color
end

--------------------------------------------------------------------------------
-- 4. REGISTRATION & EXECUTION
--------------------------------------------------------------------------------

-- Register scene instances with unique string IDs in the SceneManager
gq.scenes.addScene("scene1", scene1)
gq.scenes.addScene("scene2", scene2)

-- Set the initial active scene
gq.scenes.changeTo("scene1")

-- Start the main engine loop
gq.run()