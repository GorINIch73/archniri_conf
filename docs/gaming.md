# Gaming notes

## Steam troubleshooting

If Steam behaves strangely after `niri` config changes, verify the active output profile first:

- `niri msg outputs` should show the real connector name, such as `DP-5`
- machine-local settings in `config/niri/local.kdl` must target that active connector
- a stale output block like `eDP-1` is silently ignored when no such monitor exists

On this setup, the working profile is `DP-5` with `3440x1440@144.000`, `scale 1`, and `position x=1280 y=0`.

## Baseline Steam launch options

Use this when you want GameMode without an overlay:

```text
gamemoderun %command%
```

Use this when you also want MangoHud:

```text
MANGOHUD=1 gamemoderun %command%
```

MangoHud can be toggled with `Right Shift + F12`.

## Gamescope profile

Use Gamescope per-game when you want a controlled fullscreen session, scaling, or compositor isolation:

```text
gamemoderun gamescope -f -- %command%
```

With MangoHud:

```text
MANGOHUD=1 gamemoderun gamescope -f -- %command%
```

Gamescope is intentionally not enabled globally because some games behave better without it.
