# Touch Controls Pro for Godot 4.x

A battle-tested mobile input system for Godot 4.x featuring dynamic floating joysticks, multi-touch buttons, deadzone curves, and automatic hardware keyboard detection.

## Features

- **Three Joystick Modes**:
  - `DYNAMIC`: Appears right beneath the player's thumb anywhere on the touch zone.
  - `FLOATING`: Dynamically glides with the player's drag beyond clamp radius.
  - `FIXED`: Traditional stationary analog stick.
- **Multi-Touch Support**: Independent touch index tracking avoids input conflict between movement and action buttons.
- **InputMap Integration**: Emulates standard Godot `Input.action_press()` and `Input.action_release()` directly.
- **Zero Dependencies**: Pure GDScript compatible with Forward+, Mobile, and Compatibility rendering pipelines.

## Usage in any Godot 4 project

1. Enable the plugin in **Project Settings -> Plugins**.
2. Add a `CanvasLayer` to your scene.
3. Instantiate `VirtualJoystick` or `TouchActionButton` into the canvas.
4. Set the `action_left`, `action_right`, `action_up`, `action_down` export properties to match your Project Input Map.

## ⚖️ Licencia y Uso Comercial
Este plugin está licenciado bajo la **Mozilla Public License 2.0 (MPL-2.0)** por **Estudio Eclipse**.

### ¿Puedo usar este plugin en mi videojuego comercial cerrado (Steam, Consolas, Móviles)?
**SÍ.** La licencia MPL-2.0 permite explícitamente compilar e integrar este plugin dentro de obras comerciales propietarias (*Larger Works*) sin que tengas que liberar el código de tu juego ni tus recursos artísticos.

### ¿Qué obligaciones tengo?
1. Si realizas cambios o mejoras directamente sobre los archivos de este plugin (por ejemplo, optimizaciones o correcciones de bugs en sus scripts), debes poner a disposición de la comunidad esas modificaciones bajo la misma licencia MPL-2.0.
2. Mantener los avisos de copyright y autoría original de **Estudio Eclipse**.
