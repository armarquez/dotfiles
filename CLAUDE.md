# dotfiles — agent guidance

## What this repo is

- **GNU Stow + git subtree + justfile.** `zsh/` is a vendored git subtree of [zsh-quickstart-kit](https://github.com/unixorn/zsh-quickstart-kit). `zsh/zsh/` is the Stow package whose contents map directly into `$HOME`.
- **`claude/` is the Claude Code config package**, stowed into `~/.claude/`. It is fully owned — seeded once from the [armarquez/claude-code-config](https://github.com/armarquez/claude-code-config) fork (upstream: Trail of Bits), then maintained directly here. Not a subtree.
- **Single `main` branch for both personal and work machines** — environment-detection inside fragments handles the split at runtime.

## Critical conventions

- **Never edit files inside `zsh/` except `zsh/zsh/.zshrc.d/`.** Everything else in `zsh/` is upstream kit — `just update-zsh` will clobber hand-edits. All customization goes in fragment files under `zsh/zsh/.zshrc.d/`.
- **Fragment numbering = load order** (files are sourced alphanumerically):
  - `50-` prefix → base config, loaded on every machine.
  - `80-` prefix → Airbnb/work config, self-gated (see below).
- **Airbnb fragments self-skip on personal machines** via `_is_airbnb_env` at the top of each `80-*` file. It checks for `yak`/`airlab` CLIs, `~/dev/airbnb`, or `~/.airlab`, then calls `return 0` to bail out early if not a work env. Never create a work-only branch; use this pattern instead.
- **New fragments must be self-contained.** Each fragment redefines `can_haz()` locally and carries the BSD-licensed header comment matching the existing files. Match that style exactly.
- **Stow symlinks are live.** Edits to existing fragment files take effect immediately after the next shell reload — no `just stow` needed. Only run `just restow` after *adding* a new file to the package.

### Claude config (`claude/`)

See `claude/README.md` for the full layout and recipe reference. Key agent-facing rules:

- **`claude/` is the stow *dir* containing two packages** — `base/` (always stowed) and `airbnb/` (stowed only when an Airbnb env is detected). Both target `~/.claude/` and their `rules/` contents merge into `~/.claude/rules/`.
- **Rules gate at stow time, not runtime.** Unlike zsh fragments (which `source` + `return 0` early), Claude rules are static markdown loaded by presence. The Airbnb gate is applied when stowing — `ghe-access.md` and `substantiate.md` only land in `~/.claude/rules/` on Airbnb machines.
- **Detection mirrors `_is_airbnb_env` from `80-airbnb.zsh`** (`yak`, `~/dev/airbnb`, `airlab`, `~/.airlab`). Use `CLAUDE_FORCE_AIRBNB=1/0` to override.
- **`justfile` and `README.md` live at the stow-dir level** (in `claude/`, not inside `base/` or `airbnb/`), so they're never packaged and never appear in `~/.claude/`. No `--ignore` flags needed.
- **`claude/justfile` recipes** are surfaced from the root via `mod claude` as `just claude <recipe>`. Zsh recipes stay in the root justfile — a justfile inside `zsh/` would be in the subtree path and could be clobbered by `just update-zsh`.
- **Seeded from ToB fork, owned here.** Run `just claude check-upstream` to diff `base/` files against the fork. Never auto-merge.

## Common commands

| Command | Purpose |
|---|---|
| `just init` | One-time bootstrap (zgenom, stow, fzf, just) |
| `just stow` / `restow` / `unstow` | Manage `$HOME` zsh symlinks |
| `just claude stow` / `restow` / `unstow` | Manage `~/.claude/` symlinks |
| `just claude check-upstream` | Diff vendored files against ToB fork |
| `just update-zsh` | Pull upstream kit subtree from GitHub |
| `just update-plugins` / `regen` | Update / regenerate zgenom plugins |
| `just startup` | Per-session cloud-workspace setup |
| `just sync` | Pull from public `origin`, push to work `ghe` |
| `just push-all` | Push to both remotes |

## Two-remote sync model

- `origin` → `github.com/armarquez/dotfiles` (public)
- `ghe` → `git.musta.ch/anthony-marquez/dotfiles` (work)
- Standard workflow: commit to `main`, then `just push-all` or `just sync`.

## Tooling

- **Plugin manager:** zgenom (cached at `~/.zgenom`, configured via `~/.zgen-setup`)
- **Prompt:** powerlevel10k (`just p10k` to reconfigure)
- **Runtime managers:** pyenv, jenv (lazy), rbenv, nvm, GVM, and **mise** (preferred — used for Go and Airbnb shims)
- **Other:** direnv, fzf, tig, pygitup
