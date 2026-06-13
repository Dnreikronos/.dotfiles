# monitor-keybinds

Global hotkeys (Windows) to switch the primary monitor between resolution +
refresh-rate presets, via AutoHotkey v2.

| Hotkey | Preset |
| --- | --- |
| `Ctrl+Shift+1` | 3440×1440 @ 84.96 Hz |
| `Ctrl+Shift+2` | 2560×1080 @ 119.88 Hz |
| `Ctrl+Shift+3` | 1280×720 @ 120 Hz (scaled: 2560×1440 @ 120 signal) |
| `Ctrl+Shift+Alt+1/2/3` | **Record** the monitor's current mode into that preset |

## How it works

Two apply paths:

- **Recorded preset** (`slotN.dat` present): replays the exact display config
  through the modern CCD API (`QueryDisplayConfig` / `SetDisplayConfig`) — the
  same path Windows Settings uses. Required for GPU-scaled modes.
- **Fallback** (no `slotN.dat`): matches by width/height/refresh and applies via
  the legacy `ChangeDisplaySettingsEx`.

To pin a preset exactly: set the monitor how you want it in Windows, then press
`Ctrl+Shift+Alt+N` to record it. `Ctrl+Shift+N` then replays it verbatim.

## Setup

1. Get AutoHotkey v2 (portable `AutoHotkey64.exe`) and place it next to the
   scripts (the launchers call `%~dp0AutoHotkey64.exe`). Portable download:
   <https://www.autohotkey.com/>.
2. Run `Start Keybinds.cmd` — a green **H** tray icon means it's active.
3. To start on login, drop a shortcut to `Start Keybinds.cmd` in
   `shell:startup`.

`Dump Modes.cmd` runs `dump-modes.ahk`, which writes every display mode of the
primary monitor to `modes.txt` (useful for diagnosing which rates exist).

## Notes / gotchas

- **`slotN.dat` is machine- and monitor-specific** — it encodes a signal timing
  for this exact display. On another machine, delete it and re-record.
- Refresh rates Windows stores are truncated integers (119.88 → 119), so the
  fallback targets the floor and falls back to the closest available rate.
- `1280×720 @ 120` is a **raw, GPU-scaled** mode: the desktop is 720p but the
  signal is 2560×1440 @ 120. The legacy `ChangeDisplaySettings` rejects it
  (`DISP_CHANGE_FAILED` / -2) — hence the CCD path.
- The apply intentionally omits **`SDC_ALLOW_CHANGES`**. With that flag Windows
  silently downgrades the scaled 720p@120 config to native 720p@85; without it,
  the supplied config is applied exactly or the call fails.
