# Dotfiles

**DaikieJP**'s configuration, managed with [chezmoi](https://chezmoi.io).
Reproducible on macOS, Ubuntu/Debian and Arch with a single command.

---

## Installing on a new machine

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply daikiejp
```

That does everything:

1. Installs chezmoi.
2. Clones this repo into `~/.local/share/chezmoi`.
3. Asks two questions (GUI, packages) and stores the answers in
   `~/.config/chezmoi/chezmoi.toml`.
4. Installs the system packages with whichever manager applies (brew / apt / pacman).
5. Clones the external repos: Neovim config, Zsh plugins, TPM.
6. Writes every dotfile, already adapted to the operating system.

To review before it touches anything:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init daikiejp
chezmoi diff          # what would change
chezmoi apply -v      # apply it
```

---

### Keeping the repo somewhere else

chezmoi expects the source in `~/.local/share/chezmoi` and does **not** remember
the `--source` flag between runs. To keep the repo elsewhere, link it:

```sh
ln -sfn ~/path/to/dotfiles ~/.local/share/chezmoi
```

That way `chezmoi` works without flags and the repo lives wherever you want.
(On this machine it points at `~/dev/.config/dotfiles`.)

---

## Daily use

| What you want to do | Command |
| --- | --- |
| Edit a dotfile | `chezmoi edit ~/.zshrc` |
| See what would change | `chezmoi diff` |
| Apply changes | `chezmoi apply -v` |
| Open the repo | `chezmoi cd` |
| Pull changes from another machine | `chezmoi update -v` |
| Adopt an existing file | `chezmoi add ~/.config/something` |
| Force-refresh externals | `chezmoi apply --refresh-externals` |
| Diagnostics | `chezmoi doctor` |

> **Important:** do not edit `~/.zshrc` by hand and expect it to stick. The
> source of truth is the repo. Use `chezmoi edit`, or edit inside `chezmoi cd`
> and then `chezmoi apply`.

---

## Layout

```
.
├── .chezmoiroot              → points at home/, to keep the root clean
├── README.md
├── docs/
│   └── languages.md          Notes on installing languages and LSPs
└── home/                     ← chezmoi source state
    ├── .chezmoi.toml.tmpl        init questions + OS detection
    ├── .chezmoidata.yaml         Package list (brew / apt / pacman)
    ├── .chezmoiexternal.toml.tmpl External repos (nvim, plugins, TPM, fonts)
    ├── .chezmoiignore            What is NOT deployed on each OS
    ├── .chezmoiscripts/          Installers and post-install steps
    ├── create_private_dot_daikie       Local secrets, created empty once
    ├── create_private_dot_wakatime.cfg Wakatime key, same idea
    ├── Library/LaunchAgents/     weekly updater agent (macOS)
    ├── dot_zshrc
    ├── dot_vimrc
    ├── dot_tmux.conf.tmpl
    └── dot_config/
        ├── zsh/                  env / aliases / plugins / local
        ├── mise/                 runtime versions + weekly updater
        ├── systemd/user/         weekly updater timer (Linux)
        ├── tmux/scripts/         custom script for the Dracula theme
        ├── ghostty/              macOS terminal
        ├── alacritty/            Linux terminal
        ├── aerospace/            macOS only
        └── sketchybar/           macOS only
```

### chezmoi naming conventions

| Prefix | Meaning |
| --- | --- |
| `dot_` | Target starts with `.` (`dot_zshrc` → `~/.zshrc`) |
| `.tmpl` | Processed as a Go template before being written |
| `executable_` | Gets `chmod +x` |
| `private_` | Permissions `0600` |
| `create_` | Created if missing, then never touched again |
| `empty_` | Written even when empty (otherwise chezmoi would remove the target) |
| `run_once_` | Runs once per machine |
| `run_onchange_` | Re-runs whenever its rendered content changes |

---

## What is system-specific

| Item | macOS | Ubuntu/Debian | Arch |
| --- | --- | --- | --- |
| Package manager | Homebrew | apt + official installers | pacman |
| Homebrew prefix | `/opt/homebrew` | — | — |
| `PNPM_HOME` | `~/Library/pnpm` | `~/.local/share/pnpm` | `~/.local/share/pnpm` |
| `ls` colors | `LSCOLORS` | `LS_COLORS` | `LS_COLORS` |
| Runtimes | mise (node, ruby, python, php, rust), always `latest` | mise | mise |
| Weekly upgrade | launchd agent | systemd user timer | systemd user timer |
| Terminal | Ghostty | Alacritty | Alacritty |
| Tiling | AeroSpace | GNOME + Tactile (manual) | i3 |
| Status bar | SketchyBar | — | i3status |
| Nerd Fonts | Homebrew cask | chezmoi external | pacman |
| Cascadia Code | Homebrew cask | `dotfiles-private/fonts-linux` | `dotfiles-private/fonts-linux` |

The `zsh` path in `.tmux.conf` is resolved at apply time with `lookPath`, so it
works the same on `/bin/zsh`, `/usr/bin/zsh` or `/opt/homebrew/bin/zsh`.

### Headless machines

In containers, devcontainers and SSH servers chezmoi detects there is no GUI and
skips the terminal config, AeroSpace, SketchyBar and the fonts. It does not try
to change the default shell with `chsh` either.

### Linux caveat

The Linux path has never been run end to end on a real machine — only the
templates are verified. The core (zsh, tmux, nvim, CLI tools, mise) is
OS-agnostic and should be fine; the desktop side is the untested part. On
Ubuntu, tiling is GNOME's own plus the
[Tactile](https://extensions.gnome.org/extension/4548/tactile/) extension, which
is installed from the browser and cannot be automated from apt.

---

## Local, unversioned configuration

`~/.config/zsh/local.zsh` is created once and chezmoi never touches it again.
Keys, client paths and personal aliases that must not end up in a public repo go
there:

```sh
alias bk='~/.config/scripts/backup_daikieapp.sh'
export SOME_API_KEY="..."
```

The same goes for `~/.daikie` (tokens and URLs for the own API, `KEY=value`
format) and `~/.wakatime.cfg`. chezmoi creates them once with empty keys and
`0600` permissions; from then on they are yours. The SketchyBar wakatime and
music modules hide themselves while those are unfilled, so on a new machine the
bar works without configuring anything.

Edit them with a normal editor (`nvim ~/.daikie`), **not** with `chezmoi edit` —
that would open the empty scaffold in the repo. And never run
`chezmoi add ~/.daikie`: that would copy your real secrets into a public repo.

---

## Neovim

The Neovim config lives in its own repo
([daikiejp/nvim](https://github.com/daikiejp/nvim)) and chezmoi clones it into
`~/.config/nvim` as an *external*. It is still edited and published from there:

```sh
cd ~/.config/nvim
git add -A && git commit -m "..." && git push
```

chezmoi runs `git pull --ff-only` every 7 days, or on demand with
`chezmoi apply --refresh-externals`.

---

## Adding a package

Everything comes from `home/.chezmoidata.yaml`. Add the package under the right
manager and apply:

```sh
chezmoi edit --apply ~/.local/share/chezmoi/home/.chezmoidata.yaml
```

The install scripts are `run_onchange_`, so they re-run by themselves once they
notice the list changed.

---

## Manual steps on a new machine

Most of it is one script. Everything secret or non-reproducible lives in a
separate, **private** folder that is deliberately not in this repo — this one is
public, and a stray `git add -A` would publish every key in it.

```sh
# 1. dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply daikiejp

# 2. private files: SSH, GPG, ~/.gitconfig, tokens, fonts with no cask
~/dotfiles-private/restore.sh

# 3. language runtimes as pinned in ~/.config/mise/config.toml
mise install
```

`restore.sh` detects macOS or Linux, puts the fonts in the right directory and
fixes every permission. See the README inside that folder for how to move it
between machines (USB or an encrypted archive — never in the clear).

What is still genuinely manual afterwards:

1. **Accessibility permission for AeroSpace** — System Settings → Privacy &
   Security → Accessibility. Without it AeroSpace cannot move windows.
2. **Gems and global pnpm packages** — see `docs/languages.md`. mise installs the
   runtimes, not their package ecosystems.
3. **Log out and back in** so the default shell change takes effect.
4. **Sign in to the apps** installed as casks (VS Code, Slack, Obsidian…).

---

## Pending

- `home/dot_config/sketchybar/plugins/executable_music_monitor_file` is a
  compiled binary checked into the repo. It should be built from
  `music_monitor_file.swift` in a `run_onchange_`.
- `~/.gitconfig` and `~/.config/git/*` remain unmanaged, on purpose.
