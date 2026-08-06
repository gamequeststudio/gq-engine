local Canvas = {}
Canvas.__index = Canvas

-- Constructor

function Canvas.new(width, height)
    assert(width and height, "[ERROR] The canvas needs to be a certain size.")

    local self = setmetatable({}, Canvas)

    self.width = width
    self.height = height

    return self
end

-- Getters

function Canvas:getSize()
    return self.width, self.height
end

return Canvas