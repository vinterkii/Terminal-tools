# Terminal-tools
A collection of scripts and utilities that I use daily.

## Tools
Below is a list of all the tools available in this repo.

### [wall.sh](https://github.com/vinterkii/Terminal-tools/blob/main/Scripts/wall.sh)
A Bash wallpaper changer for GNOME. It scans a wallpaper folder by default: `~/.config/Wallpapers`. It lists supported image files (PNG/JPG/JPEG/GIF), prompts you to pick one, then sets it as both the desktop wallpaper and lock-screen wallpaper using `gsettings`.

After installation, you can use it by running:
- `wall`

### [stheme.sh](https://github.com/vinterkii/Terminal-tools/blob/main/Scripts/stheme.sh)
A Bash Starship theme/config switcher. This utility has 3 modes—run `stheme` and choose one:
- **Custom:** lists available configs in the theme directory (default: `~/.config/Starship`) and prompts you to choose one.
- **Preset:** lists available presets and prompts you to choose one.
- **Backup:** backs up your current Starship configuration (default: `~/Backup/Starship`).

You can also set themes directly:
- `-c` for custom themes (followed by the theme number)
- `-p` for presets (followed by the theme number)

After installation, you can use it by running:
- `stheme`

For help, use:
- `stheme -h` or `stheme -help`

## Installation

### Automatic
1. Clone the repository:
```bash
git clone https://github.com/vinterkii/Terminal-tools.git
```

2. Go into the repo:
```bash
cd Terminal-tools
```

3. Run the installer:
```bash
bash setup.sh
```

Now reopen your terminal, and the tools will be ready to use.

### Manual
Add aliases to your shell config (e.g., `~/.bashrc` for Bash).

```bash
alias wall='bash /path/to/script/wall.sh'
alias stheme='bash /path/to/script/stheme.sh'
```

Then reload your shell config:
```bash
. ~/.bashrc
```
(or `source ~/.bashrc`)

**TailsOS:** if your shell config isn’t persistent, you’ll need to set the aliases every time you restart. If you want it to persist, enable dotfile persistence in the persistent storage, copy the shell config there, and restart.