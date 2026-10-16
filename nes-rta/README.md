# NES RTA Web Emulator

A custom browser interface for real-time NES gameplay, using an existing JavaScript NES emulation engine.

**Live site:** https://frozican.github.io/emulator-hub/nes-rta/

## Features
- Load a local .nes ROM file
- Canvas-based 256 × 240 game screen with pixelated scaling
- Keyboard controls and standard browser gamepad input
- Pause/resume, restart, and fullscreen controls
- Responsive mobile-friendly layout
- ROM files are read locally in the browser; the site does not upload them

## Controls
| Key | NES input |
|---|---|
| Arrow keys | D-pad |
| Z | A |
| X | B |
| Enter | Start |
| Right Shift | Select |

## Limitations
This is an early prototype. ROM compatibility varies. The initial version focuses on a basic NES game loop and controls; audio output and advanced timing tools are not implemented yet. It is not a frame-accurate TAS tool and does not guarantee deterministic playback.

## Run locally
Serve the repository over HTTP (for example, with VS Code Live Server) and open index.html. The emulation library is loaded from a public CDN, so an internet connection is required.

No ROMs are included. Only use ROM files you are legally entitled to use.
