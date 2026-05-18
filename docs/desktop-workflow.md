# Desktop workflow

## Daily app shortcuts

| Key | App |
| --- | --- |
| `Super+B` | Firefox |
| `Super+Shift+B` | Google Chrome |
| `Super+Shift+D` | Discord |
| `Super+Alt+B` | Focus `browser` workspace |
| `Super+Alt+D` | Focus `chat` workspace |
| `Super+Alt+G` | Focus `games` workspace |

## Window behavior

- Firefox picture-in-picture opens floating.
- `pavucontrol` opens floating.
- Nautilus and Thunar default to a narrower column width.
- Discord defaults to a half-width column.
- Steam opens maximized.
- Firefox and Discord auto-start into named `browser` and `chat` workspaces on login.
- Steam uses a named `games` workspace when launched during startup.

## Waybar choices

- The desktop Waybar profile intentionally omits battery and power-profile modules.
- The optional laptop profile adds battery status and the active power profile.
- Clicking the volume module opens `pavucontrol`.
- The microphone module shows `live` / `muted`; clicking it toggles the default input device.
- The public-IP module shows the current external IP; its tooltip includes approximate location/provider data from `ipapi.co`, and clicking it refreshes the lookup.
- The AmneziaWG module shows whether the `gor2` interface is connected.
- CPU and GPU temperature are shown separately.
- Root filesystem usage is shown as a compact percentage.
- The power button opens `wlogout`.

## Audio controls

- `XF86AudioMicMute` toggles the default microphone when the keyboard exposes that key.
- `Pause` is kept as a convenient fallback toggle on keyboards without a dedicated mic-mute key.
- Enabling the microphone is styled as a more visible warning notification; muting it stays visually calmer.

## Session services

- `nm-applet` starts with the session and lives in the tray.
- `swayidle` locks the screen after 10 minutes of inactivity.
- Suspend is intentionally not configured.
