![Lua](https://img.shields.io/badge/Lua-5.1+-blue) ![LuaJIT](https://img.shields.io/badge/LuaJIT-2.1-brightgreen) ![SDL3](https://img.shields.io/badge/SDL3-Latest-orange) ![License](https://img.shields.io/badge/license-MIT-green)

<img src="assets/banner.png" width="890" alt="GQEngine - Minimalist Game Engine">

## Overview

GQEngine is an ultra-minimalist game engine built with:

- <b>Lua/LuaJIT</b> for scripting and game logic
- Direct <b>FFI bindings</b> to SDL3
- A <b>plugin system</b> for extensibility
- <b>Event-driven architecture</b> for decoupling

Ideal for rapid prototyping, simple 2D games, and experimenting with engine design.

## Features

| Feature         | Status  | Description                                       |
| --------------- | ------- | ------------------------------------------------- |
| Event Bus       | Planned | Event system: `on_load`, `on_update`, `on_render` |
| Plugin Manager  | Planned | Dynamic loading of Lua plugins                    |
| Graphics Plugin | Planned | Rendering of images, primitives, and text         |
| Window Plugin   | Planned | Single-window support via SDL3                    |
| Input Plugin    | Planned | Keyboard, mouse (controllers: future)             |
| Audio Plugin    | Planned | Sound and music support                           |
