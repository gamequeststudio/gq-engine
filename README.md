🇺🇸 English | [🇧🇷 Português](README.pt-br.md)

<p align="center">
  <img src="assets/logo.png" alt="GQEngine Logo"/>
</p>

GQEngine is a 2D game engine focused on simplicity, modularity, and code-driven development. The project does not include a visual editor, encouraging developers to structure their games and understand their architecture from the very beginning.

Internally, the engine is built on **LuaJIT** and **SDL2**, providing a simple and consistent API for 2D game development.

## Philosophy
---
GQEngine was created with the following goals:

- A simple and easy-to-learn API;
- A modular plugin-based architecture;
- Fully code-driven development;
- Minimal setup to start a new project;
- Encourage good project organization without hiding how the engine works.

## Plugin System
---
Most of the engine's functionality is provided through independent plugins. They can be enabled only when needed, keeping each project lightweight and modular.

Planned plugins include:

- State Machine
- Scene Management
- Asset Management
- Event System (Signals)
- Save/Load
- Configurable Input System
- Timers
- Camera

Some plugins may use licenses different from the engine's main license. See the `LICENSE` file for more information.

The plugin system is still under development, and its API may change during the early releases.

## Platforms
---
GQEngine is officially developed and tested on Linux, which is the project's primary development platform.

Since LuaJIT and SDL2 are cross-platform, support for Windows and other platforms is planned for the future. However, at this stage of development, only Linux is officially supported.

## Contributing
---
The project is still in its early stages of development, and its architecture is actively evolving.

Suggestions, questions, and discussions are welcome through the repository's **Issues** and **Discussions**.

Code contributions are not being accepted yet, but this is expected to change as the engine matures.
