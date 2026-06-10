# claude/

Claude Code configuration, managed as GNU Stow packages targeting `~/.claude/`.

`claude/` is the stow **dir** containing two packages — `base/` (always applied) and `airbnb/` (applied only on Airbnb machines). This mirrors the `50-`base / `80-`airbnb split in the zsh config.

## Packages

### `base/` — always stowed

| File | Lands in `~/.claude/` | Description |
|---|---|---|
| `settings.json` | `settings.json` | Global settings — privacy env vars, permission deny rules, hooks, statusline |
| `CLAUDE.md` | `CLAUDE.md` | Global development standards loaded into every session |
| `statusline.sh` | `statusline.sh` | Two-line statusline (model, folder, branch, context %, cost, duration) |
| `rules/diagrams.md` | `rules/diagrams.md` | Always use MermaidJS for diagrams |
| `rules/writing-style.md` | `rules/writing-style.md` | Concise, scannable technical writing standards |
| `rules/no-repetition.md` | `rules/no-repetition.md` | Single-source rule for docs |
| `rules/remediation-design.md` | `rules/remediation-design.md` | Audit → enforce rollout pattern |
| `rules/link-validation.md` | `rules/link-validation.md` | Validate all links before finalizing docs |
| `rules/substantiate.md` | `rules/substantiate.md` | Always back factual claims with verifiable evidence |

### `airbnb/` — stowed only on Airbnb machines

| File | Lands in `~/.claude/` | Description |
|---|---|---|
| `rules/ghe-access.md` | `rules/ghe-access.md` | GHE hosts (git.musta.ch vs github.airbnb.biz) and `gh` CLI usage |
| `rules/link-validation-airbnb.md` | `rules/link-validation-airbnb.md` | Airbnb fetch tooling addendum: use `mcp__airbnb-core__fetch` for internal URLs |
| `rules/substantiate-airbnb.md` | `rules/substantiate-airbnb.md` | Airbnb evidence sources: Sourcegraph, Telescope, Trino/Superset |

### Stow-dir level — never stowed

| File | Description |
|---|---|
| `justfile` | Claude recipes, surfaced from root as `just claude <recipe>` |
| `README.md` | This file |

Runtime state (`sessions/`, `history.jsonl`, `cache/`, `projects/`, `plugins/`) lives in `~/.claude/` and is never touched by stow.

## Environment detection

The `stow` and `restow` recipes auto-detect Airbnb environment by checking (in order):
1. `command -v yak` (AirDev workspace CLI)
2. `~/dev/airbnb` directory
3. `command -v airlab`
4. `~/.airlab` directory

Override for testing:
```bash
CLAUDE_FORCE_AIRBNB=1 just claude restow   # force Airbnb rules on
CLAUDE_FORCE_AIRBNB=0 just claude restow   # force Airbnb rules off
```

## Upstream source

Seeded from [armarquez/claude-code-config](https://github.com/armarquez/claude-code-config) (fork of Trail of Bits' template). **Seed-once, own-it** — files are maintained directly here, not auto-merged. Check for upstream changes worth cherry-picking:

```bash
just claude check-upstream
```

## Recipes

| Recipe | Purpose |
|---|---|
| `just claude stow` | Link both packages into `~/.claude/` (backs up conflicts to `*.bak`) |
| `just claude restow` | Re-stow after adding files; also syncs Airbnb rules if env changed |
| `just claude unstow` | Remove all stow-managed symlinks from `~/.claude/` |
| `just claude check-upstream` | Diff `base/` files against the ToB fork |

## Adding a rule

- **Universal rule:** drop in `base/rules/<name>.md`, run `just claude restow`.
- **Airbnb-only rule:** drop in `airbnb/rules/<name>.md`, run `just claude restow`.
