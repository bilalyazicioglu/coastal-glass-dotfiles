# Coastal Glass dotfiles

My personal Arch Linux desktop: a floating bar, an edge-reveal dock, translucent panels and peach/turquoise accents. Ghostty uses Monaspace Neon and a dark translucent background.

A small configuration snapshot, not a distribution or a fresh-machine installer. **HyDE's Lua setup is required by the Hyprland entry point.** These files do not replace Hyprland, HyDE or Noctalia.

## Included

- Noctalia bar, dock, control center, desktop clock/calendar/media widgets and one palette.
- Hyprland Lua overrides, Ghostty and Rofi appearance.
- A single external lock path: hypridle → coastal-lock → hyprlock. Noctalia native locking/idle actions are disabled to avoid competing lockers.
- A small Main wallpaper startup script, with previous-session wallpaper caching disabled.

The private theme catalogue, password-gated theme picker, other wallpapers, account data and personal desktop screenshots are **not included**. This snapshot uses Main only. The Porsche animation and wallpapers live in [coastal-drive](https://github.com/bilalyazicioglu/coastal-drive).

## Use

Tested on an existing Arch/HyDE setup, Noctalia 5.4.1 and Ghostty 1.4.0. Requires the matching Hyprland Lua API; these are not legacy `hyprland.conf` settings. You also need hypridle, hyprlock, awww, Python 3, hyprpolkitagent, wl-clipboard, cliphist, Rofi and grimblast. The example app shortcuts use Firefox, Dolphin and Spotify Launcher; adjust them to your apps. Fonts: Monaspace Neon and JetBrainsMono Nerd Font.

```sh
python3 prepare.py
```

This creates **only** `prepared/`, replacing `__HOME__` placeholders with your home directory. It does not change your desktop, install packages or start services. It refuses to overwrite an existing output directory.

Review `prepared/.config` and `prepared/.local/bin`, back up your current files, then copy only what you want. Do not blindly replace a working HyDE configuration. The Hyprland entry point starts Noctalia and the clipboard watcher: keep only one startup location for each. Copy the helpers too if you use the supplied lock/wallpaper commands.

For the wallpaper, download `wallpapers/coastal-drive-desktop.png` from the Coastal Drive repo and save it as `~/.local/share/backgrounds/coastal-glass/coastal-drive-main.png`. No wallpaper download is performed automatically. Install Coastal Drive separately if you want the animated terminal greeting.

Personal defaults to review: Turkish keyboard layout (`tr`), monitor scale 1, `eDP-1` desktop widget output and fixed widget coordinates. Adjust widget coordinates for your display; there is no automatic layout migration. Your HyDE installation supplies the base hardware keys, gestures and services.

| Shortcut | Action |
|---|---|
| Super+Enter | Ghostty |
| Super+Space | Launcher |
| Super+, | Control center |
| Super+L | Lock |
| Print | Save/copy screenshot |
| Super+P | Select screenshot area |

## Check

```sh
python3 -m unittest discover -s tests -v
```

The lock tests mock system calls and never lock the screen. The live setup was checked through a real lock/unlock cycle; the bar, dock and launcher recovered normally. This is a personal snapshot, not a guarantee across all hardware or shell versions.

Code and original configuration changes: MIT. HyDE, Noctalia and the other dependencies retain their own licenses and are not bundled. The Arch logo remains the property of its owner and is used as a distro identifier; it is excluded from the code license. No affiliation is implied.
