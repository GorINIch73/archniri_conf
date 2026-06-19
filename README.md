# archniri

Reproducible Arch Linux + niri workstation setup for:

- C++ development in Neovim
- everyday web use
- Steam gaming
- a calm Catppuccin-like dark desktop

This repository is meant to be both a readable record of the system design and a fast rebuild kit after a fresh install.

## What is included

| Area | Stack |
| --- | --- |
| Compositor | `niri` |
| Shell | `zsh`, Oh My Zsh, Powerlevel10k |
| Editor | `neovim`, `clangd`, Treesitter, Telescope, completion, DAP base |
| Desktop UI | `waybar`, `fuzzel`, `mako`, `kitty`, `wlogout`, `swaylock` |
| Appearance | Catppuccin-like palette, `adw-gtk3-dark`, `Papirus-Dark`, `Adwaita` cursors |
| Utilities | `lf`, `mc`, clipboard history, screenshots, wallpaper rotation |
| Gaming | Steam, GameMode, MangoHud, Gamescope helpers |
| Optional laptop extras | Battery status, UPower, power profile control |

## Repository layout

```text
.
├── config/          # linked into ~/.config
├── docs/            # focused notes such as gaming launch options
├── home/            # linked directly into ~
├── packages/        # package manifests
├── scripts/         # bootstrap and maintenance helpers
└── templates/       # optional starter files for new projects
```

## Fresh install flow

Run from the repository root:

```bash
./setup.sh
```

The root setup script runs the full initial flow:

| Script | Purpose |
| --- | --- |
| `bootstrap.sh` | Installs packages from `packages/pacman.txt` |
| `install-zsh-extras.sh` | Installs Powerlevel10k and Oh My Zsh plugins |
| `link-dotfiles.sh` | Links repo-managed files into `$HOME`, backing up conflicts first |
| `apply-appearance.sh` | Applies GTK, icon, cursor, and font preferences via `gsettings` |
| `check-setup.sh` | Prints a quick health report for the configured workstation |

It also creates `~/Downloads/Wallpapers`, reloads user systemd units, and enables `wallpaper-rotate.timer`.
It also enables the per-user `syncthing.service`, so Syncthing starts automatically after login. Open the local web UI at `http://127.0.0.1:8384`.

Packages that are not available in the enabled pacman repositories are tracked separately in `packages/aur.txt`.

During setup, the script asks whether to install optional laptop extras. If selected, it runs `scripts/setup-laptop.sh`, installs laptop-specific packages, switches Waybar to the laptop profile, and enables `power-profiles-daemon`.

## First login checklist

After linking configs and logging into niri:

1. Put wallpapers into `~/Downloads/Wallpapers`.
2. Restart the shell or open a new terminal so Powerlevel10k loads.
3. Open Neovim once and let plugins install.
4. In Steam, add per-game launch options as needed from [`docs/gaming.md`](docs/gaming.md).

## Optional laptop profile

For a laptop install, answer `y` when `setup.sh` asks about laptop extras, or run this later:

```bash
./scripts/setup-laptop.sh
```

That profile:

- installs `power-profiles-daemon` and `upower`
- switches Waybar from `config.jsonc` to `config.laptop.jsonc`
- adds battery status and the active power profile to the bar
- enables the system power-profile service

Inspect or change the active profile with:

```bash
powerprofilesctl
powerprofilesctl set power-saver
```
## Daily key bindings

| Binding | Action |
| --- | --- |
| `Super+Return` | Open terminal |
| `Super+D` | Open launcher |
| `Super+B` | Open Firefox |
| `Super+Shift+B` | Open Chrome |
| `Super+Shift+D` | Open Discord |
| `Super+Alt+B` | Focus browser workspace |
| `Super+Alt+D` | Focus chat workspace |
| `Super+Alt+G` | Focus games workspace |
| `Super+T` | Next wallpaper |
| `Super+Shift+T` | Theme picker |
| `Super+P` | Clipboard history |
| `Super+Shift+E` | Logout menu |
| `Super+Alt+L` | Lock screen |
| `Pause` / mic mute key | Toggle microphone |
| `Print` | Full screenshot |
| `Shift+Print` | Area screenshot |
| `Ctrl+Print` | Area screenshot to clipboard |

## Themes

The desktop theme can be switched without editing individual config files:

```bash
theme-switch mocha
theme-switch dracula colorful
```

Available themes: `mocha`, `graphite`, `rose`, `forest`, `nord`, `dracula`, `tokyo`, `gruvbox`, `solarized`.

Waybar applets can stay calm or become more colorful:

```bash
theme-switch mocha calm
theme-switch mocha colorful
theme-switch graphite colorful
```

There is also a graphical picker:

```bash
theme-menu
```

In niri, open it with `Super+Shift+T`.

The switcher updates Waybar, Kitty, fuzzel, mako, wlogout, swaylock, and GTK settings. `scripts/apply-appearance.sh` accepts the same theme name and defaults to `mocha calm`.

## Wallpaper rotation

Wallpapers are read from:

```text
~/Downloads/Wallpapers
```

Rotation is handled by `awww` and a user systemd timer. The timer changes wallpaper every 5 minutes; `Super+T` triggers the same script immediately.

Idle behavior is intentionally simple: the session locks after 10 minutes of inactivity, and no automatic suspend is configured.

## Machine-specific configuration

The checked-in `config/niri/config.kdl` is intentionally generic and includes an optional local override file:

```text
~/.config/niri/local.kdl
```

Start from `config/niri/local.kdl.example` when needed. Good candidates for machine-local config:

- monitor names, positions, scales, refresh rates
- laptop-only input tweaks
- per-machine autostart commands

### Monitor setup

Keep monitor-specific `output` blocks in `~/.config/niri/local.kdl`, not in the shared `config.kdl`.

1. Run `niri msg outputs` and note the real connector name, current mode, scale, transform, and position.
2. Copy `config/niri/local.kdl.example` to `~/.config/niri/local.kdl`.
3. Replace the example connector and values with the ones for this machine.
4. Reload niri with `niri msg action load-config-file`.
5. Run `niri msg outputs` again and confirm that the active output shows the expected connector, mode, scale, transform, and position.

If an `output` block targets the wrong connector name, niri simply does not apply it, so checking the second `niri msg outputs` result is part of the setup rather than optional cleanup.

## Current intentional choices

- The desktop is **Catppuccin-like**, not a strict full Catppuccin port everywhere.
- GTK uses `adw-gtk3-dark` for stability rather than a fragile themed override stack.
- Gamescope is available through helpers and documented launch options, but is **not** forced globally for every Steam game.
- The Neovim config is intentionally compact: IDE-grade basics first, personal refinements later.

## Desktop app workarounds

### Frozen Electron apps

Discord is launched through:

```text
~/.local/bin/discord-stable
```

That wrapper starts Discord with GPU rendering disabled. It is intended for the common failure mode where Discord keeps running but the visible window stops repainting until it is closed and reopened from the tray.

If the problem disappears permanently after upstream Electron/Discord/NVIDIA updates, switch `config/niri/config.kdl` back from `discord-stable` to `discord`.

## Steam bugs

### Steam crashes on startup in `libaudio.so`

Symptom:

- Steam verifies the installation, starts `steamwebhelper`, then exits.
- `journalctl --user -b` shows `steam` dumping core in `steamui.so`.
- `coredumpctl info <pid>` shows a stack through `libaudio.so` and `libpulse.so.0`.
- `journalctl --user -b` may also show PipeWire/Pulse messages like:

```text
card 50 port 0 profiles inconsistent
card 50 port 1 profiles inconsistent
card 50 port 2 profiles inconsistent
card 50 port 3 profiles inconsistent
```

On this machine, the bad card is NVIDIA HDMI audio:

```text
alsa_card.pci-0000_01_00.1
GA104 High Definition Audio Controller
```

Fix: disable only that HDMI-audio card in WirePlumber. This repo ships the rule at:

```text
config/wireplumber/wireplumber.conf.d/51-disable-nvidia-hdmi-audio.conf
```

Apply linked configs and restart the user audio stack:

```bash
./scripts/link-dotfiles.sh
systemctl --user restart wireplumber pipewire-pulse
```

Verify that the NVIDIA HDMI audio device is gone while USB audio remains:

```bash
wpctl status
```

Then launch Steam again:

```bash
steam
```

## Next likely refinements

- deeper Neovim C++ workflow tuning
- see [`docs/cpp-workflow.md`](docs/cpp-workflow.md) for the current Neovim/C++ workflow
- see [`docs/lf.md`](docs/lf.md) for the terminal file-manager workflow
- see [`docs/desktop-workflow.md`](docs/desktop-workflow.md) for app shortcuts and window behavior
- Qt theming if Qt apps become part of the daily workflow
