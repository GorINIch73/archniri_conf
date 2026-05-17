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
| Utilities | clipboard history, screenshots, wallpaper rotation |
| Gaming | Steam, GameMode, MangoHud, Gamescope helpers |

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

## First login checklist

After linking configs and logging into niri:

1. Put wallpapers into `~/Downloads/Wallpapers`.
2. Restart the shell or open a new terminal so Powerlevel10k loads.
3. Open Neovim once and let plugins install.
4. In Steam, add per-game launch options as needed from [`docs/gaming.md`](docs/gaming.md).
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
| `Super+P` | Clipboard history |
| `Super+Shift+E` | Logout menu |
| `Super+Alt+L` | Lock screen |
| `Pause` / mic mute key | Toggle microphone |
| `Print` | Full screenshot |
| `Shift+Print` | Area screenshot |
| `Ctrl+Print` | Area screenshot to clipboard |

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

## Current intentional choices

- The desktop is **Catppuccin-like**, not a strict full Catppuccin port everywhere.
- GTK uses `adw-gtk3-dark` for stability rather than a fragile themed override stack.
- Gamescope is available through helpers and documented launch options, but is **not** forced globally for every Steam game.
- The Neovim config is intentionally compact: IDE-grade basics first, personal refinements later.

## Next likely refinements

- deeper Neovim C++ workflow tuning
- see [`docs/cpp-workflow.md`](docs/cpp-workflow.md) for the current Neovim/C++ workflow
- see [`docs/lf.md`](docs/lf.md) for the terminal file-manager workflow
- see [`docs/desktop-workflow.md`](docs/desktop-workflow.md) for app shortcuts and window behavior
- Qt theming if Qt apps become part of the daily workflow
