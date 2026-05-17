# Gaming notes

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

