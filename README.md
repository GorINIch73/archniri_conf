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
| Compositors / WM | `niri`, `Hyprland`, minimal `i3` fallback |
| Shell | `zsh`, Oh My Zsh, Powerlevel10k |
| Editor | `neovim`, `clangd`, Treesitter, Telescope, completion, DAP base |
| Desktop UI | `waybar`, `fuzzel`, `mako`, `kitty`, `zellij`, `wlogout`, `swaylock` |
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

Before running this repo's installer, the fresh Arch system needs the small bootstrap set that the installer itself depends on:

```bash
sudo pacman -Syu --needed git base-devel sudo
```

Required before `./setup.sh`:

- `git` to clone this repository, Oh My Zsh, plugins, and `yay-bin` when needed
- `base-devel` to provide `makepkg` and build AUR packages
- `sudo` because the scripts install system packages and enable system services

Steam is installed from Arch's `multilib` repository, so `./setup.sh` will fail on `steam` and `steam-devices` if `multilib` is disabled.
Before running setup, uncomment this block in `/etc/pacman.conf`:

```ini
[multilib]
Include = /etc/pacman.d/mirrorlist
```

Then refresh package databases:

```bash
sudo pacman -Syu
```

Run from the repository root:

```bash
./setup.sh
```

The root setup script runs the full initial flow:

| Script | Purpose |
| --- | --- |
| `bootstrap.sh` | Installs packages from `packages/pacman.txt` |
| `install-aur.sh` | Installs packages from `packages/aur.txt` with `yay`/`paru` |
| `install-zsh-extras.sh` | Installs Powerlevel10k and Oh My Zsh plugins |
| `link-dotfiles.sh` | Links repo-managed files into `$HOME`, backing up conflicts first |
| `apply-appearance.sh` | Applies GTK, icon, cursor, and font preferences via `gsettings` |
| `check-setup.sh` | Prints a quick health report for the configured workstation |

It also creates `~/Downloads/Wallpapers`, reloads user systemd units, and enables `wallpaper-rotate.timer`.
It also enables the per-user `syncthing.service`, so Syncthing starts automatically after login. Open the local web UI at `http://127.0.0.1:8384`.

Packages that are not available in the enabled pacman repositories are tracked separately in `packages/aur.txt`.
If neither `yay` nor `paru` is installed, `install-aur.sh` bootstraps `yay-bin` first.

To apply configs without reinstalling packages, run `./scripts/link-dotfiles.sh`.
Existing managed files are moved to `~/.dotfiles-backup/<timestamp>/` before
being replaced with symlinks. Waybar's legacy `config` file is also backed up
and linked to `config.jsonc`, so it cannot override the selected profile.
Niri's machine-local `~/.config/niri/local.kdl` is preserved. Log out and back
into the desktop session to ensure all running components use the new configs.

> [!WARNING]
> **Already have a Neovim configuration?** Normal setup replaces matching files
> but leaves other files in place. An old `init.vim`, plugin scripts, or Lua
> modules can conflict with this configuration and prevent lazy.nvim from loading.
> One symptom is `E492: Not an editor command: Lazy sync`.

To migrate from an old configuration, close Neovim and run from the repository root:

```bash
./scripts/link-dotfiles.sh --reset-nvim-config
```

This moves the entire existing `~/.config/nvim` directory (or its symlink) to
`~/.dotfiles-backup/<timestamp>/.config/nvim` before linking our files. Installed
plugin data and editor state are preserved; no manual deletion is needed.
Then start `nvim` normally, without `sudo` or `--clean`, and run:

```vim
:Lazy sync
```

Wait for plugin installation to finish and restart Neovim. If `E492` persists,
check `:messages` for startup errors and `:echo $MYVIMRC` for the loaded config
path; an old configuration is only one possible cause.

During setup, the script asks whether to install optional laptop extras, Samba,
and printer support. Each is opt-in; selecting one runs its corresponding
helper script.

## Optional Samba and printer setup

Samba file sharing and CUPS printing are optional and are not installed by the
desktop bootstrap. Run the relevant helper from the repository root:

```bash
./scripts/setup-samba.sh
./scripts/setup-printers.sh
```

The Samba helper installs Samba and starts `smb.service`; it prints the steps
for defining shares and adding Samba credentials. The printer helper installs
CUPS, its filters, the printer setup GUI, and Avahi for local network discovery,
then starts the corresponding services. Both helpers leave system configuration
and firewall rules for you to review and configure.

## First login checklist

After linking configs and logging into niri:

1. Put wallpapers into `~/Downloads/Wallpapers`.
2. Restart the shell or open a new terminal so Powerlevel10k loads.
3. Open Neovim once and let plugins install.
4. In Steam, add per-game launch options as needed from [`docs/gaming.md`](docs/gaming.md).

### Calendar locale

Clicking the clock in Waybar opens `gsimplecal`. Its checked-in configuration uses
`ru_RU.utf8`, so weeks start on Monday and day and month names are shown in Russian.
The Waybar launcher runs the calendar at 2× GTK scale so it is easier to read;
the scale is limited to the calendar window.

On a fresh system, uncomment this line in `/etc/locale.gen`:

```text
ru_RU.UTF-8 UTF-8
```

Then generate the locale:

```bash
sudo locale-gen
```

Confirm that it is available before opening the calendar:

```bash
locale -a | grep -i '^ru_RU'
```

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

## Desktop sessions

The package manifest installs three independent sessions. Select one in the
display manager before logging in, or start it from a TTY if no display manager
is installed:

| Session | Type | Purpose |
| --- | --- | --- |
| Niri | Wayland | Primary scrolling desktop |
| Hyprland | Wayland | Fully configured tiling alternative using Waybar |
| i3 | X11 | Minimal fallback with Kitty and Rofi |

From a TTY, start Hyprland with `start-hyprland` and the minimal i3 session with
`startx`.

The Hyprland profile starts Waybar, Mako, wallpaper rotation, clipboard history,
idle locking, NetworkManager's tray applet, and the polkit agent. Its main
bindings mirror the Niri profile: `Super+Return` opens Kitty, `Super+D` opens
Fuzzel, `Super+Q` closes a window, and `Super+Shift+E` opens the logout menu.

Hyprland uses automatic monitor configuration by default. For a fixed layout,
copy `~/.config/hypr/local.conf.example` to `~/.config/hypr/local.conf`, add this
line to `~/.config/hypr/hyprland.conf`, and then edit the copied monitor rules:

```ini
source = ~/.config/hypr/local.conf
```

The i3 profile is intentionally small. `Super+Return` opens Kitty, `Super+D`
opens Rofi, `Super+Q` closes the focused window, and `Super+Shift+E` exits the
session. Use `Super+1` through `Super+5` to switch workspaces.
## Kitty tabs and Zellij sessions

Kitty is the terminal emulator; its tabs keep separate terminal windows inside
one Kitty window. The config provides these tab shortcuts:

| Shortcut | Action |
| --- | --- |
| `Ctrl+Shift+T` | Open a tab in the current directory |
| `Ctrl+Shift+W` | Close the current tab |
| `Ctrl+Shift+Left/Right` | Move between tabs |
| `Alt+1` … `Alt+9` | Select tab 1 … 9 |

Zellij runs inside a Kitty tab and adds persistent sessions, panes, and its own
tabs. Start it with `zellij`; it creates a session and shows available shortcuts
in its status bar. Common defaults:

| Keys | Action |
| --- | --- |
| `Ctrl+P`, then `N` | Open a pane |
| `Ctrl+P`, then arrow key | Move focus between panes |
| `Ctrl+P`, then `D` | Close the focused pane |
| `Ctrl+T`, then `N` | Open a Zellij tab |
| `Ctrl+T`, then `1`–`9` | Switch to a Zellij tab |
| `Ctrl+O`, then `D` | Detach and keep the session running |
| `zellij attach` | Reopen the most recent detached session |

Zellij uses the default keybinding preset, so press the mode key first, then the
action key. Its config uses `wl-copy` for clipboard copying and Neovim to inspect
scrollback. The checked-in configs are linked by `./scripts/link-dotfiles.sh`.

### tmux

tmux is another terminal multiplexer, with a long-running session model that is
useful over SSH and on servers. Start it with `tmux`; detach with `Ctrl+B`, then
`D`, and reconnect with `tmux attach`. This config keeps the standard `Ctrl+B`
prefix. Press the prefix and then:

| Keys | Action |
| --- | --- |
| `C` | Open a window in the current directory |
| `%` | Split the current pane left and right |
| `-` | Split the current pane top and bottom |
| Arrow key | Move between panes (mouse clicks also work) |
| `R` | Reload `~/.tmux.conf` |

Each action follows `Ctrl+B`; for example, split vertically with `Ctrl+B`, then
`%`. Run `tmux ls` to list sessions and `tmux attach -t NAME` to attach to one.
The config is tracked at [`home/.tmux.conf`](home/.tmux.conf) and linked by the
dotfiles linker.

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
| `Super+Up/Down` | Switch to the workspace above/below |
| `Super+Ctrl+Up/Down` | Move the focused window to the workspace above/below |
| `Super+K/J` | Focus the window above/below within a column |
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

### Monitor setup: resolution and scaling

Keep monitor-specific `output` blocks in `~/.config/niri/local.kdl`, not in the shared `config.kdl`.

In a terminal inside the Niri session, list the connected displays and available modes:

```bash
niri msg outputs
```

Use the actual connector name (for example, `eDP-1` or `DP-1`) and a listed mode.
Copy refresh rates exactly, including decimal digits: `59.951` is not `60.000`.
With a resolution alone, such as `mode "2560x1440"`, Niri chooses its highest
available refresh rate. See the [Niri output documentation](https://github.com/niri-wm/niri/wiki/Configuration:-Outputs).

Start with the panel's native resolution, then adjust `scale` for comfortable
text and controls. Increase scale if everything looks too small; decrease it
if windows take up too much space. Try these starting points and compare your
terminal, browser, and Waybar at your normal viewing distance:

| Scale | Interface size | Suggested use when experimenting |
| --- | --- | --- |
| `1` | 100% | Start here on a regular desktop display |
| `1.25` | 125% | Slightly larger text and controls |
| `1.5` | 150% | Try on a dense laptop display |
| `2` | 200% | Try on a high-density 4K display |

Test a scale without editing files (replace `eDP-1` with your connector):

```bash
niri msg output eDP-1 scale 1.25
```

This is temporary; save the chosen value in `local.kdl` to keep it across sessions.
Use `niri msg output eDP-1 scale auto` to return to automatic scaling while testing.

If `local.kdl` does not exist, copy `config/niri/local.kdl.example` there from the
repository. If it already exists, edit its monitor block and preserve other local
settings. Use a regular file for `local.kdl`, not a symlink to the shared example.
Example only — replace the connector and mode with values reported by your display:

```kdl
output "eDP-1" {
    mode "2560x1440@59.951"
    scale 1.25
}
```

Validate the full configuration, then reload it if validation succeeds:

```bash
niri validate -c ~/.config/niri/config.kdl
niri msg action load-config-file
niri msg outputs
```

Confirm the active mode and scale in the final output. A block with the wrong
connector name will not configure your display. If the result is uncomfortable,
restore the previous `mode` and `scale`, then reload again.

For multiple monitors, use one block per display. Positions use logical pixels:
a 3840×2160 display at scale `2` occupies 1920×1080 logical pixels, so an adjacent
display on its right starts at `position x=1920 y=0`. You can omit `position`
and let Niri arrange the displays automatically.

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
