local SDL = require("SDL")
local Canvas = require("gqengine.core.graphics.Canvas")
local InternalCanvas = require("gqengine.core.graphics.internal.InternalCanvas")
local WindowPlugin = require("gqengine.plugins.internal.WindowPlugin")
local Plugin = require("gqengine.core.Plugin")

local data = setmetatable({}, { __mode = "k" })

local GraphicsPlugin = Plugin.new("GraphicsPlugin", Plugin.types.External)

function GraphicsPlugin:onAttach(engine)
    local state = {
        engine = engine,
        renderer = nil,
        transform = {
            x = 0, y = 0,
            rotation = 0,
            scaleX = 1,
            scaleY = 1
        },
        stack = {},
        api = nil
    }

    data[self] = state
    state.api = self:generateAPI()

    engine:registerAPI("createCanvas", function(width, height) return self:_createCanvas(width, height) end)
end

function GraphicsPlugin:_createCanvas(width, height)
    local state = data[self]

    local canvas = Canvas.new(width, height)
    if state.renderer then
        self:_ensureCanvasTexture(canvas)
    end
    return canvas
end

function GraphicsPlugin:_ensureCanvasTexture(canvas)
    local state = data[self]

    local sdlTexture = InternalCanvas.getSDLTexture(canvas)
    if not sdlTexture then
        local width, height = canvas:getSize()
        sdlTexture = state.renderer:createTexture(SDL.pixelFormat.RGBA8888, SDL.textureAccess.Target, width, height)
        InternalCanvas.setSDLTexture(canvas, sdlTexture)
    end
    return sdlTexture
end

function GraphicsPlugin:onCreateWindow()
    local state = data[self]

    local sdlWindow = WindowPlugin:getSDLWindow()
    state.renderer = SDL.createRenderer(sdlWindow, -1, SDL.rendererFlags.Accelerated)
    state.renderer:setDrawBlendMode(SDL.blendMode.Blend)
end

function GraphicsPlugin:onPreRender()
    local state = data[self]

    state.renderer:setDrawColor({r = 0, g = 0, b = 0, a = 0})
    state.renderer:clear()
end

function GraphicsPlugin:onRender()
    local state = data[self]

    local engineAPI = state.engine:getAPI()
    if engineAPI.getCurrentScene then
        local scene = engineAPI.getCurrentScene()
        if scene then
            if scene.onRender then scene:onRender(state.api) end
        end
    end
end

function GraphicsPlugin:onPostRender()
    data[self].renderer:present()
end

function GraphicsPlugin:push()
    local state = data[self]

    table.insert(state.stack, {
        x = state.transform.x,
        y = state.transform.y,
        rotation = state.transform.rotation,
        scaleX = state.transform.scaleX,
        scaleY = state.transform.scaleY
    })
end

function GraphicsPlugin:pop()
    local state = data[self]

    assert(#state.stack > 0, "[ERROR] Cannot pop an empty transform stack")
    state.transform = table.remove(state.stack)
end

function GraphicsPlugin:_transformPoint(x, y)
    local state = data[self]

    local scaledX = x * state.transform.scaleX
    local scaledY = y * state.transform.scaleY

    local rotatedX = scaledX * math.cos(state.transform.rotation) - scaledY * math.sin(state.transform.rotation)
    local rotatedY = scaledX * math.sin(state.transform.rotation) + scaledY * math.cos(state.transform.rotation)

    local finalX = rotatedX + state.transform.x
    local finalY = rotatedY + state.transform.y

    return finalX, finalY
end

function GraphicsPlugin:_hasTransform()
    local state = data[self]

    return state.transform.x ~= 0
    or state.transform.y ~= 0
    or state.transform.rotation ~= 0
    or state.transform.scaleX ~= 1
    or state.transform.scaleY ~= 1
end

function GraphicsPlugin:_transformPolygon(points)
    local transformed = {}

    for i = 1, #points, 2 do
        local x, y = self:_transformPoint(points[i], points[i + 1])
        transformed[i] = x
        transformed[i + 1] = y
    end

    return transformed
end

function GraphicsPlugin:_transformRect(x, y, width, height)
    return self:_transformPolygon({
        x, y,
        x + width, y,
        x + width, y + height,
        x, y + height
    })
end

function GraphicsPlugin:_fillTransformedRect(x, y, width, height)
    self:_fillPolygon(self:_transformRect(x, y, width, height))
end

function GraphicsPlugin:_drawTransformedRect(x, y, width, height)
    self:_drawPolygon(self:_transformRect(x, y, width, height))
end

function GraphicsPlugin:_drawTransformedLine(x1, y1, x2, y2)
    local state = data[self]

    local x1, y1 = self:_transformPoint(x1, y1)
    local x2, y2 = self:_transformPoint(x2, y2)

    state.renderer:drawLine({x1 = x1, y1 = y1, x2 = x2, y2 = y2})
end

function GraphicsPlugin:_fillCircle(centerX, centerY, radius)
    local segments = 32
    local step = (math.pi * 2) / segments
    local points = {}

    for i = 0, segments - 1 do
        local angle = i * step

        points[#points+1] = centerX + math.cos(angle) * angle
        points[#points+1] = centerY + math.sin(angle) * angle
    end

    if self:_hasTransform() then
        points = self:_transformPolygon(points)
    end

    self._fillPolygon(points)
end

function GraphicsPlugin:_drawPolygon(points)
    local state = data[self]

    local pointCount = #points / 2
    if pointCount < 2 then return end

    for i=1, pointCount do
        local next = i + 1
        if next > pointCount then next = 1 end

        local x1 = points[i * 2 - 1]
        local y1 = points[i * 2]

        local x2 = points[next * 2 - 1]
        local y2 = points[next * 2]

        state.renderer:drawLine({x1 = x1, y1 = y1, x2 = x2, y2 = y2})
    end
end

function GraphicsPlugin:_fillPolygon(points)
    local state = data[self]

    local pointCount = #points / 2
    if pointCount < 3 then return end

    local minY = points[2]
    local maxY = points[2]

    for i=2, #points, 2 do
        local y = points[i]
        if y < minY then minY = y end
        if y > maxY then maxY = y end
    end

    minY = math.floor(minY)
    maxY = math.floor(maxY)

    local intersections = {}

    for y = minY, maxY do
        local count = 0

        for i=1, pointCount do
            local next = i + 1
            if next > pointCount then next = 1 end

            local x1 = points[i * 2 - 1]
            local y1 = points[i * 2]

            local x2 = points[next * 2 - 1]
            local y2 = points[next * 2]

            if y1 ~= y2 then
                local minEdgeY = math.min(y1, y2)
                local maxEdgeY = math.max(y1, y2)

                if y >= minEdgeY and y < maxEdgeY then
                    local x = x1 + (y - y1) * (x2 - x1) / (y2 - y1)
                    count = count + 1
                    intersections[count] = x
                end
            end
        end

        table.sort(intersections)

        local i = 1
        while i < count do
            local x1 = math.floor(intersections[i])
            local x2 = math.floor(intersections[i + 1])

            state.renderer:drawLine({x1 = x1, y1 = y, x2 = x2, y2 = y})

            i = i + 2
        end
    end
end

function GraphicsPlugin:generateAPI()
    local state = data[self]

    return {
        setColor = function(r, g, b, a)
            state.renderer:setDrawColor({r = r, g = g, b = b, a = a or 255})
        end,
        clear = function()
            state.renderer:clear()
        end,
        setCanvas = function(canvas)
            if canvas then
                assert(getmetatable(canvas) == Canvas, "[ERROR] Function 'setCanvas' requires a Canvas object")
                self:_ensureCanvasTexture(canvas)
                state.renderer:setTarget(InternalCanvas.getSDLTexture(canvas))
            else
                state.renderer:setTarget(nil)
            end
        end,
        drawCanvas = function(texture, x, y, scaleX, scaleY)
            local mt = getmetatable(texture)
            assert(mt == Canvas, "[ERROR] Function 'drawTexture' requires a Canvas object")

            self:_ensureCanvasTexture(texture)

            local sdlTexture = InternalCanvas.getSDLTexture(texture)
            local sx, sy = scaleX or 1, scaleY or (scaleX or 1)
            local width, height = texture:getSize()
            state.renderer:copy(sdlTexture, nil, {x = x or 0, y = y or 0, w = width * sx, h = height * sy})
        end,
        fillRect = function(x, y, width, height)
            assert(width and height, "[ERROR] The funciton 'fillRect' expects a width and a height")

            if self:_hasTransform() then
                self:_fillTransformedRect(x, y, width, height)
            else
                state.renderer:fillRect({x = x or 0, y = y or 0, w = width, h = height})
            end
        end,
        drawRect = function(x, y, width, height)
            assert(width and height, "[ERROR] The funciton 'lineRect' expects a width and a height")

            if self:_hasTransform() then
                self:_drawTransformedRect(x, y, width, height)
            else
                state.renderer:drawRect({x = x or 0, y = y or 0, w = width, h = height})
            end
        end,
        drawLine = function(x1, y1, x2, y2)
            if self:_hasTransform() then
                self:_drawTransformedLine(x1, y1, x2, y2)
            else
                state.renderer:drawLine({x1 = x1, y1 = y1, x2 = x2, y2 = y2})
            end
        end,
        drawCircle = function(centerX, centerY, radius)
            local segments = 32
            local step = (math.pi * 2) / segments
            local points = {}

            for i=1, segments do
                local angle = i * step

                points[#points+1] = centerX + math.cos(angle) * radius
                points[#points+1] = centerY + math.sin(angle) * radius
            end

            if self:_hasTransform() then
                points = self:_transformPolygon(points)
            end

            self:_drawPolygon(points)
        end,
        fillCircle = function(centerX, centerY, radius)
            self:_fillCircle(centerX, centerY, radius)
        end,
        drawPolygon = function(points)
            assert(type(points) == "table" and #points >= 4 and #points % 2 == 0, 
            "[ERROR] Function 'drawPolygon' expects a table containing at least two points.")

            if self:_hasTransform() then
                points = self:_transformPolygon(points)
            end

            self:_drawPolygon(points)
        end,
        fillPolygon = function(points)
            assert(#points >= 6, "[ERROR] The function 'fillPolygon' expects at least three points")

            if self:_hasTransform() then
                points = self:_transformPolygon(points)
            end

            self:_fillPolygon(points)
        end,
        push = function() self:push() end,
        pop = function() self:pop() end,
        translate = function(x, y)
            state.transform.x = state.transform.x + (x or 0)
            state.transform.y = state.transform.y + (y or 0)
        end,
        rotate = function(angle)
            state.transform.rotation = state.transform.rotation + angle
        end,
        scale = function(sx, sy)
            state.transform.scaleX = state.transform.scaleX * sx
            state.transform.scaleY = state.transform.scaleY * sy
        end
    }
end

return GraphicsPlugin
