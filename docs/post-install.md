# Post-install checklist

## Desktop

- [ ] Log into the `niri` session rather than starting a nested compositor.
- [ ] Confirm `waybar`, `mako`, and `awww-daemon` start automatically.
- [ ] Confirm the Waybar microphone module updates and that `Pause` toggles the default input device.
- [ ] Confirm screen sharing works in the browser.
- [ ] Put wallpapers into `~/Downloads/Wallpapers`.

## Laptop extras

- [ ] If this is a laptop, confirm the laptop profile was selected during setup or run `./scripts/setup-laptop.sh`.
- [ ] Confirm Waybar shows battery status and the active power profile.
- [ ] Confirm `powerprofilesctl` reports the expected active profile.

## Shell

- [ ] Open a fresh terminal and confirm Powerlevel10k loads.
- [ ] Confirm autosuggestions and syntax highlighting work.

## Neovim

- [ ] Open Neovim once and let plugins install.
- [ ] Open a C++ project with `compile_commands.json`.
- [ ] Confirm `clangd` attaches.
- [ ] Confirm Telescope, Treesitter, and completion work.

## Gaming

- [ ] Launch Steam once.
- [ ] Use `gamemoderun %command%` on games that benefit from GameMode.
- [ ] Use `MANGOHUD=1 gamemoderun %command%` when debugging performance.
- [ ] Use Gamescope per-game only where it improves behavior.
