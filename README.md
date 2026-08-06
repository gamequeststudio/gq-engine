🇺🇸 English | [🇧🇷 Português](README.pt-br.md)

<p align="center">
  <img src="assets/logo.png" alt="GQEngine Logo"/>
</p>

# GQEngine

GQEngine is a 2D game engine focused on **simplicity, modularity, and code-driven development**.

The engine does not provide a visual editor. Development is performed directly through Lua code, allowing developers to have explicit control over the structure and behavior of their game.

Internally, GQEngine uses **LuaJIT** and **SDL2**, providing a high-level API for engine functionality without directly exposing the implementation details of these libraries.

## Philosophy

GQEngine was designed with the following objectives:

* Simple and easy-to-learn API;
* Plugin-based modular architecture;
* Fully code-driven development;
* Minimal initial configuration;
* Separation between public API and internal implementation;
* Abstraction of the libraries used by the engine without hiding fundamental game development concepts;
* Ability to enable additional functionality only when needed.

## Basic Example

The following example creates a window and starts the engine's game loop:

```lua
local gq = require("gqengine")

local window = gq.createWindow("My Game", 800, 600)

gq.run()
```

Additional functionality, such as rendering and input management, is provided through external plugins.

## Architecture

GQEngine uses a modular architecture based on **plugins**.

The `Engine` is responsible for the application's main loop, while the `PluginManager` manages plugins and dispatches lifecycle events to registered systems.

Simplified:

```text
Engine
  │
  ├── PluginManager
  │      │
  │      ├── Internal Plugins
  │      │
  │      └── External Plugins
  │
  └── Public API
```

Plugins can keep their internal state separated from the public API, preventing implementation details from being directly exposed to game code.

### Plugins

The currently available external plugins include:

* **GraphicsPlugin** — 2D rendering, geometric shapes, Canvas, and transformations;
* **InputPlugin** — action-based input system with keyboard support;
* **ScenesPlugin** — scene management and lifecycle.

The engine also contains internal plugins used to provide essential functionality, such as SDL2 window management.

External plugins can be enabled only when needed, keeping the project structure modular.

The plugin system is still under development, and its API may change during the early versions.

## Rendering

The `GraphicsPlugin` provides a 2D rendering API independent of the API directly exposed by SDL2.

Available features include:

* Rectangle drawing;
* Line drawing;
* Polygon drawing and filling;
* Circle drawing and filling;
* Translation, rotation, and scaling transformations;
* Transformation stack with `push` and `pop`;
* Canvas;
* Scaled Canvas drawing.

Rendering uses SDL2 internally, but the objects and operations available to the game are abstracted through the GQEngine API.

## Input

The `InputPlugin` provides an action-based input system.

Actions can be associated with keys and queried through different states:

```lua
gq.isActionPressed("jump")
gq.isActionJustPressed("jump")
gq.isActionReleased("jump")
```

The system currently supports keyboard input, with support for other devices planned for future versions.

## Scenes

The `ScenesPlugin` provides a basic scene management system.

A scene can implement lifecycle callbacks such as:

```lua
function scene:onEnter()
end

function scene:onUpdate(dt)
end

function scene:onRender(graphics)
end

function scene:onLeave()
end
```

Scenes are responsible for organizing the logic and rendering of different parts of the game.

## Platforms

GQEngine is officially developed and tested on **Linux**, which is currently the project's primary platform.

Since the engine uses LuaJIT and SDL2, its architecture is not conceptually limited to Linux. Official support for Windows and other platforms may be added in the future.

At this stage, **Linux is the only officially supported platform**.

## Dependencies

The main dependencies used by the engine are:

* [LuaJIT](https://luajit.org/)
* [SDL2](https://www.libsdl.org/)

Communication with SDL2 is performed through the binding used by the engine.

## Project Status

The initial architecture of GQEngine has been defined, and a first functional version of the main systems is under development.

The engine is still in an early stage, and APIs, internal structures, and existing systems may change as the project evolves.

## Contributing

Suggestions, questions, and discussions are welcome through the repository's **Issues** and **Discussions**.

Code contributions are not currently being accepted. This policy may change as the engine matures and its APIs become more stable.

## License

See the `LICENSE` file for information about the terms governing the distribution and use of GQEngine.

Plugins currently included in the repository are part of the engine project and are subject to the license defined for this project.

Plugins developed and distributed separately may have their own licensing terms. In such cases, refer to the documentation and license files provided with the respective plugin.
