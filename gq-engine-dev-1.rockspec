package = "gq-engine"
version = "0.1.0"

source = {
   url = "https://github.com/gamequeststudio/gq-engine.git"
}

description = {
   summary = "A simple game engine framework built with LuaJIT and SDL2.",
   detailed = [[
GQEngine is a litewheight game engine framework focused on learning 
game development concepts using LuaJIT.

The engine provides a simple abstraction layer over SDL2, allowing 
developers to create game without dealing with low-level APIs.
   ]],
   homepage = "https://github.com/gamequeststudio/gq-engine",
   license = "MIT"
}

dependencies = {
   "luajit >= 2.1",
   "lua-sdl2"
}

build = {
   type = "builtin",
   modules = {
      ["gqengine.init"] = "gqengine/init.lua",
      
      ["gqengine.internal.class"] = "gqengine/internal/class.lua",
      ["gqengine.internal.renderer"] = "gqengine/internal/renderer.lua",
      ["gqengine.internal.sdl"] = "gqengine/internal/sdl.lua",
      ["gqengine.internal.window"] = "gqengine/internal/window.lua",
   }
}
