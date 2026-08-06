local InternalCanvas = {}

-- Maps public Canvas objects to their internal SDL texture.
local data = setmetatable({}, { __mode = "k" })

function InternalCanvas.getSDLTexture(canvas)
    local entry = data[canvas]

    return entry and entry.sdlTexture
end

function InternalCanvas.setSDLTexture(canvas, sdlTexture)
    data[canvas] = data[canvas] or {}
    data[canvas].sdlTexture = sdlTexture
end

return InternalCanvas