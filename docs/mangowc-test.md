# MangoWC test profile

This is an optional, isolated MangoWC + Noctalia trial. It does not replace or
edit the active Niri configuration. All trial compositor files and helper
scripts live in [`../mangowc/`](../mangowc/).

## Resume checkpoint — 2026-10-22

**Status: paused as an experiment.** Keep MangoWC + Noctalia in this separate
test profile; do not merge its appearance or settings into the main Niri setup.
The visual style may be more decorative than desired, so leave it as-is for
now rather than continuing to tune it.

- [x] Installed Arch packages `mangowm` (MangoWC 0.18.2) and `noctalia`
  (Noctalia 5.3.0).
- [x] Linked the repository's `mangowc/` directory to `~/.config/mango` and
  the trial Noctalia TOML to `~/.config/noctalia/mangowc-test.toml`.
- [x] Ly exposes Mango at `/usr/share/wayland-sessions/mango.desktop`; Niri
  remains available as its own session.
- [x] Copied the active Niri output settings into `mangowc/local.conf`:
  DP-5, 3440×1440 at 144 Hz, scale 1, normal transform, position 0,0.
- [x] Disabled `mangowc-wallpaper-rotate.timer` so Noctalia does not change
  wallpapers outside the Mango trial.
- [x] Restored Niri's `wallpaper-rotate.timer`, which changes wallpapers via
  awww every 5 minutes. Its service works when Niri's `awww-daemon` is running.
- [x] `mango -c mangowc/config.conf -p` passes.
- [x] `noctalia config validate mangowc/config/noctalia/config.toml` passes
  without warnings; the wallpaper helper and Zsh theme pass syntax checks.
- [x] Selected **Mango** in Ly and tried the monitor, Noctalia bar, wallpaper,
  palette, blur, and key bindings.
- [x] Kept static wallpapers under Noctalia control; no Awwwall or video plugin
  is enabled.
- [ ] Decide whether to activate the optional pastel Zsh theme.

The trial remains separate from Niri and can be resumed from this checkpoint.
Niri's awww timer is active; the Mango/Noctalia timer is disabled. `Super+T`
still changes the wallpaper manually in either session using that session's
wallpaper method.

## Experiment log — 2026-10-22

- `Super+D` opens the Noctalia launcher. `Super+Space` remains reserved for
  switching the keyboard layout.
- `Super+Up/Down` moves between numbered tags; `Super+H/J/K/L` focuses windows.
- `Super+N` cycles layouts. Scroller uses half-width windows and centers a
  window only when it moves outside the visible area, matching the Niri profile
  more closely. Two half-width windows fit side by side.
- In `tile` and `center_tile`, `new_is_master=0` keeps new windows in the side
  stack instead of replacing the master.
- `Super+F` maximizes to the screen; `Super+Shift+F` is actual fullscreen. In
  maximized-screen mode the right edge of the rounded border is still clipped.
  Setting the maximized border color to the focus color did not fix the clip.
- Setting `animation_duration_move=0` stopped the focus-border artifact after
  fullscreen transitions, but also removed Scroller movement animation. It is
  currently `250` ms to keep Scroller animated; the right-edge clipping issue
  remains unresolved.
- The pastel colors, blur, rounded corners, and Noctalia capsules may be too
  decorative. Keep the current look only in this trial until deciding whether
  to simplify it.
- Wallpaper rotation was switched back to Niri/awww: the Niri timer is active
  every 5 minutes and the Mango/Noctalia timer is disabled. Starting the Niri
  timer service while still in Mango fails because `awww-daemon` is not running
  there; this is expected and the service will work in the Niri session.

## Stack

- MangoWC for tiling, keyboard input, blur, and window movement.
- Noctalia for the top bar, quick settings, launcher/settings UI, and wallpaper
  palette generation.
- Noctalia's built-in wallpaper picker for static images and wallpaper palettes.
- Optional Noctalia `mpvpaper` plugin for occasional video wallpapers.
- Optional Awwwall plugin if you want awww transitions or animated GIFs.
- An optional Oh My Zsh pastel prompt in `mangowc/zsh/`.

## Packages and Ly session

The current Arch package names for the two required additions are `mangowm` and
`noctalia` (both in the official Extra repository):

```bash
sudo pacman -S mangowm noctalia
```

For optional video wallpapers, install `mpvpaper` from the AUR; `mpv` is
already in this repo's package manifest:

```bash
yay -S mpvpaper
```

Ly is already your login manager; it needs no replacement or reconfiguration.
The profile also uses dependencies already listed in this repo:
`mmsg`, `kitty`, `fuzzel`, `mako`,
`wlogout`, `swaylock`, `swayidle`, `wl-clipboard`, `cliphist`,
`brightnessctl`, `playerctl`, `grim`, `slurp`, and `polkit-gnome`.

Ly lists installed Wayland sessions from `/usr/share/wayland-sessions/`.
MangoWC normally installs `mango.desktop` there. At Ly, select **Mango** for
this trial; select **Niri** to return to the current desktop. If Mango is not
listed, confirm the MangoWC package installed its desktop entry before making a
custom one.

## Install the profile

The steps below describe the initial setup for another checkout. They have
already been completed for this machine; do not repeat the `ln -s` commands
unless you have removed the links.

Back up any existing Mango config first, then link this repo's folder so Mango
loads the split files and scripts from the `mangowc/` directory:

```bash
mv ~/.config/mango ~/.config/mango.backup.$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
ln -s "$PWD/mangowc" ~/.config/mango
```

For Noctalia's separate config directory, link only the provided trial config:

```bash
mkdir -p ~/.config/noctalia
ln -s "$PWD/mangowc/config/noctalia/config.toml" ~/.config/noctalia/mangowc-test.toml
```

If your checkout is not the current directory, replace `$PWD` with its absolute
path. `mangowc/local.conf` matches the active Niri output: DP-5 at
3440×1440/144 Hz, scale 1, normal transform, position 0,0. Edit that file if
the monitor setup changes.

Before logging out of Niri, validate Mango's config without starting a second
compositor:

```bash
mango -c ~/.config/mango/config.conf -p
```

Log out, choose **Mango** in Ly, and test the shortcuts below. The existing Niri
config and session remain unchanged and selectable from Ly.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| `Super+Return` | Kitty terminal |
| `Super+D` | Noctalia launcher |
| `Super+H/J/K/L` | Focus window by direction |
| `Super+Ctrl+H/J/K/L` or arrows | Move focused window |
| `Super+1…9` | Select Mango tag |
| `Super+↑/↓` | Move between numbered tags |
| `Super+Shift+1…9` | Move window to tag |
| `Super+PageUp/PageDown` | Previous/next tag |
| `Super+Q` | Close window |
| `Super+V` | Toggle floating |
| `Super+F` / `Super+Shift+F` | Maximize / fullscreen |
| `Super+O` | Overview |
| `Super+N` | Cycle layouts |
| `Super+P` | Clipboard history |
| `Super+S` | Noctalia quick settings |
| `Super+,` | Noctalia settings |
| `Super+T` | Randomly change wallpaper and update palette |
| `Super+Shift+E` | Logout menu |

## Wallpaper palette and rotation

The config uses Noctalia's `wallpaper` palette source with the saturated
`vibrant` scheme. Open Noctalia's settings and choose
**Appearance → Theme → Wallpaper** if you want a softer palette instead. Set
the wallpaper directory to `~/Downloads/Wallpapers` in Noctalia's wallpaper
settings, then use its picker or `Super+T`. Noctalia owns the image and updates
the generated palette on each change. No awww daemon is needed for this path.

If you later want animated GIF backgrounds or awww's transitions, enable the
optional `0lucasmatheus/awwwall` plugin from Noctalia's Plugin Store and add its
toggle widget to the bar.

### Compare the wallpaper modes

Use the same image folder and try these in order:

1. **Noctalia only:** leave Awwwall off, choose an image in Noctalia, and press
   `Super+T` once. Check the wallpaper transition and whether the new palette
   fits the image.
2. **Noctalia + awww:** enable Awwwall, turn its bar widget on, then change to
   another still image. Compare transition smoothness and resource use. The
   selected image still goes through Noctalia, so palette changes stay linked.
3. **GIF:** with Awwwall on, select a GIF from the same library and see whether
   the animation is worth keeping in the setup.
4. **Video:** turn Awwwall off, then enable the `mpvpaper` plugin and try one
   short muted clip. Keep the video mode separate from the static wallpaper
   rotation.

The comparison steps above are optional ideas for a later session. The current
setup uses Niri's awww timer; the Mango/Noctalia timer is disabled. No Awwwall
or video plugin is active.

The repository's existing `wallpaper-rotate.timer` invokes the Niri-oriented
`~/.local/bin/next-wallpaper`, which changes awww directly. Disable it while
testing Mango so it cannot desynchronize the palette:

```bash
systemctl --user disable --now wallpaper-rotate.timer
```

To opt in to Mango's Noctalia-aware automatic rotation, install and enable the
separate units after linking the profile:

```bash
mkdir -p ~/.config/systemd/user
ln -s ~/.config/mango/systemd/mangowc-wallpaper-rotate.service ~/.config/systemd/user/
ln -s ~/.config/mango/systemd/mangowc-wallpaper-rotate.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now mangowc-wallpaper-rotate.timer
```

The Mango timer asks Noctalia to pick a random image every 10 minutes. To stop
it, run `systemctl --user disable --now mangowc-wallpaper-rotate.timer`.

## Switching window layouts

Press `Super+N` to cycle through the layouts listed by `circle_layout` in
`mangowc/appearance.conf`: dwindle, scroller, tile, centered tile, and grid.
The scroller layout is one option in that cycle. `Super+R` zooms the focused
window in layouts that support it. Mango reads the bindings and layout list at
startup; reload with `Super+Shift+R` after editing them.

In master-stack layouts, new windows now join the side stack and leave the
current master window in place (`new_is_master=0`). Dwindle and scroller already
place new windows alongside existing ones according to their layout rules.

The Scroller layout uses half-width columns, like the Niri profile. Two windows
can fit side by side; focusing an off-screen column scrolls it into view.

## Video wallpapers

Install/enable Noctalia's official `noctalia/mpvpaper` plugin only when you
want to try video. Pick a short, muted `mp4` or `webm` in its panel and set
auto-pause for fullscreen windows. Video playback consumes more GPU/CPU than a
still image, so keep it as an occasional mode.

## Blur and appearance

Window blur is enabled with Mango's optimized wallpaper-backed mode. This is
the lower-load option; it blurs against the wallpaper, not the actual pixels of
windows behind the transparent area. If rendering stutters, change
`blur=1` to `blur=0` in `mangowc/appearance.conf`. Tune blur, border radius,
gaps, and pastel colors there without touching the Niri theme.

## Optional Zsh prompt

To try the pastel prompt without editing the tracked `.zshrc`, symlink
`mangowc/zsh/mango-kawaii.zsh-theme` into Oh My Zsh's custom themes directory,
then temporarily set `ZSH_THEME="mango-kawaii"` in `~/.zshrc`. Restore
`powerlevel10k/powerlevel10k` to return to the existing prompt. A Nerd Font is
recommended for the flower and heart glyphs.

## Roll back

At Ly, choose Niri. Then remove the Mango and Noctalia test symlinks and restore
the backup directory if one existed. Disable the Mango rotation timer first if
you enabled it. Re-enable the original wallpaper timer if you want Niri's
five-minute rotation again:

```bash
systemctl --user disable --now mangowc-wallpaper-rotate.timer
systemctl --user enable --now wallpaper-rotate.timer
```

## Upstream references

- [MangoWC configuration](https://mangowm.github.io/docs/configuration/)
- [MangoWC monitor rules](https://mangowm.github.io/docs/configuration/monitors/)
- [MangoWC key bindings](https://mangowm.github.io/docs/bindings/keys/)
- [MangoWC effects and blur](https://mangowm.github.io/docs/visuals/effects/)
- [MangoWC + Noctalia integration](https://docs.noctalia.dev/noctalia/compositor-settings/mango/)
- [Noctalia wallpaper palettes](https://docs.noctalia.dev/noctalia/theming/)
- [Awwwall plugin](https://noctalia.dev/plugins/community/awwwall)
- [Noctalia video wallpaper plugin](https://noctalia.dev/plugins/official/mpvpaper)
- [Ly session discovery](https://github.com/fairyglade/ly#readme)
