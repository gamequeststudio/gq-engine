local class = require("gqengine.core.class")

--- Performance monitoring utility responsible for calculating smoothed FPS over time windows.
---@class FPSCounter : Class
---@field private fps integer The last calculated frames per second value.
---@field private frameCount integer Number of frames accumulated during the current time interval.
---@field private timer number Accumulated elapsed time in seconds for the current interval.
---@field private interval number Update sampling interval in seconds (default: 0.5s).
local FPSCounter = class()

--- Initializes the FPS counter state and default sampling window.
function FPSCounter:init()
    self.fps = 0
    self.frameCount = 0
    self.timer = 0
    self.interval = 0.5
end

--- Accumulates frame ticks and recalculates the average FPS when the sampling interval is reached.
---@param dt number Delta time in seconds since the previous frame.
function FPSCounter:update(dt)
    self.frameCount = self.frameCount + 1
    self.timer = self.timer + dt

    if self.timer >= self.interval then
        self.fps = math.floor(self.frameCount / self.timer)
        self.frameCount = 0
        self.timer = self.timer - self.interval
    end
end

--- Returns the current calculated FPS value.
---@return integer fps The current frames per second value.
function FPSCounter:getFPS()
    return self.fps
end

return FPSCounter