# Languages and LSPs

Homebrew installs the compilers, LSPs and formatters (see
`home/.chezmoidata.yaml`). **mise** owns the language runtimes themselves. What
is left here is only what neither of them can do: per-language package managers
(gems, global pnpm packages) and rustup components.

---

## Runtimes — mise

Versions are pinned in `home/dot_config/mise/config.toml`, which chezmoi
deploys to `~/.config/mise/config.toml`. On a new machine:

```sh
mise install        # installs node, ruby, python, php and rust as pinned
mise ls             # what is active and where it came from
```

That replaces the old nvm + rbenv + rustup dance. Nothing to source in `.zshrc`
either: `env.zsh` runs `mise activate zsh` when the binary is present.

Every tool tracks **`latest`**, and a weekly job keeps it that way.

| Runtime | Notes |
| --- | --- |
| node | pnpm still comes from Homebrew |
| ruby | compiled with ruby-build, takes a while |
| python | precompiled builds, fast |
| php | **compiled from source, this one is slow** |
| rust | mise drives rustup underneath |

### Staying on the latest version

`~/.config/mise/update.sh` runs `mise upgrade --prune`, which moves everything
to the newest release and deletes the version it replaced, so old builds never
accumulate. It runs by itself every Sunday at 03:00 — launchd on macOS,
a systemd user timer on Linux — and can be run by hand any time. Its log is
`~/.local/state/mise/update.log`.

Two deliberate choices in there:

- `--minimum-release-age 7d`, so a release published hours ago is not pulled in
  until it has had a week to be yanked if it is broken.
- The pins say `latest` rather than a number. `mise upgrade --bump` would
  rewrite `config.toml`, but chezmoi owns that file, so the two would fight and
  `chezmoi status` would never come back clean. With `latest` the file never
  changes.

The cost of "always latest" is that a new PHP or Ruby release means a full
source build in the background. To stop it:

```sh
launchctl bootout gui/$(id -u)/com.daikiejp.mise-update   # macOS
systemctl --user disable --now mise-update.timer          # Linux
```

### Per-project overrides

A repo with its own `.mise.toml` or `.tool-versions` wins over the global pins,
and `not_found_auto_install` installs the missing version on entry instead of
erroring out.

---

## Ruby gems

Not managed by anything — reinstall per ruby version:

```sh
gem install rubocop
gem install erb-formatter
gem install neovim
gem install rails
```

`ruby-lsp` used to be installed as a gem; it now comes from Homebrew.

---

## Global pnpm packages

```sh
pnpm install -g typescript
pnpm install -g @astrojs/language-server
pnpm install -g @prisma/language-server
pnpm install -g emmet-ls
pnpm install -g tree-sitter-cli      # then: pnpm approve-builds -g
```

---

## Rust components

```sh
rustup component add rustfmt
rustup component add clippy
```

`rust-analyzer` comes from Homebrew, so there is no need to add it as a rustup
component.

---

## LSPs from Homebrew

Already in `.chezmoidata.yaml`, listed here only as a reference of what is
available after a fresh install:

`dockerfile-language-server`, `lua-language-server`, `marksman`, `pyright`,
`ruby-lsp`, `rust-analyzer`, `tailwindcss-language-server`,
`typescript-language-server`, `yaml-language-server`,
`vscode-langservers-extracted` (which provides the html, css, json and eslint
language servers).

### Still missing, if ever needed

`nginx_language_server`, `java_language_server`, `prismals` (via pnpm),
`emmet_language_server`.
