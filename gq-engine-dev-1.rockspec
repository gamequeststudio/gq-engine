package = "gq-engine"
version = "0.1.0"

source = {
    url = "https://github.com/gamequeststudio/gq-engine.git"
}

description = {
    summary = "A simple and modular 2D game engine framework built with LuaJIT and SDL2.",
    detailed = [[
GQEngine is a simple and modular 2D game engine framework built with LuaJIT
and SDL2.

The engine uses a plugin-based architecture and provides a high-level API
for common game development systems while keeping fundamental game
development concepts accessible to developers.
]],
    homepage = "https://github.com/gamequeststudio/gq-engine",
    license = "MIT"
}

dependencies = {
    "luajit >= 2.1",
    "lua-sdl2"
}
