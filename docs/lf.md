# lf workflow

`lf` is the terminal file manager in this setup.

## Useful bindings

| Key | Action |
| --- | --- |
| `l` | Launch `lf` from the shell |
| `lfcd` | Launch `lf`, then `cd` into the directory you exited from |
| `ee` | Edit selected file in Neovim |
| `md` | Create directory |
| `gh` | Go home |
| `gd` | Go to Downloads |
| `gp` | Go to Pictures |
| `gc` | Go to `~/.config` |

## Opening behavior

- executable files run directly
- text files open in Neovim
- images open in `imv`
- audio/video open in `mpv`
- PDFs and unknown files fall back to `xdg-open`

## Preview behavior

- source/text files use `bat`
- media files show metadata through `mediainfo`
- images show metadata for now

Inline image previews can be added later if you decide you want a more visual `lf` workflow inside Kitty.
