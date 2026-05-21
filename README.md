# peter-claude

My personal Claude Code config — global `CLAUDE.md`, owned skills, and an installer that pulls in third-party skills I actually use.

## What's in here

```
peter-claude/
├── CLAUDE.md                   # Global rules — symlinked to ~/.claude/CLAUDE.md
├── docs/
│   └── git-conventions.md      # Imported by CLAUDE.md via @docs/git-conventions.md
├── skills/                     # Owned skills (each becomes a symlink under ~/.claude/skills/)
│   └── handoff/
├── install.sh                  # Symlink owned files + clone external skills
└── README.md
```

Third-party skills are **not** stored in this repo. They're cloned by `install.sh` into `~/.claude/.peter-claude-cache/` and symlinked into `~/.claude/skills/`.

## Install

```bash
git clone https://github.com/<you>/peter-claude.git ~/peter-claude
cd ~/peter-claude
./install.sh
```

Re-run any time to update third-party skills (it does `git pull` on each cached repo).

Dry-run first if you want to see what it'll do:

```bash
./install.sh --dry-run
```

## Currently installed third-party skills

| Skill | Source | Subdir |
|---|---|---|
| `grill-me` | https://github.com/mattpocock/skills | `skills/productivity/grill-me` |
| `caveman`  | https://github.com/JuliusBrussee/caveman | `skills/caveman` |

## Adding a new skill

### Adding one you wrote yourself

1. Create `skills/<name>/SKILL.md` in this repo.
2. Commit + push.
3. Re-run `./install.sh` on each machine.

### Adding a third-party skill

Edit `install.sh`, find the marked section, and add a line:

```bash
install_external <name> <git-url> <subdir-inside-repo>
```

Then commit + push + re-run `./install.sh`.

## Cross-platform

Tested on macOS. Should work on WSL2 / Linux (uses symlinks, plain bash, git).

Windows native is **not** supported — use WSL2.

## Recovery

`install.sh` backs up any pre-existing real (non-symlink) files at the target with a `.bak.<timestamp>` suffix before linking. Symlinks are replaced silently.

To uninstall, delete the symlinks under `~/.claude/` and restore from `.bak.*` if needed:

```bash
rm ~/.claude/CLAUDE.md ~/.claude/docs ~/.claude/skills/{handoff,grill-me,caveman}
ls ~/.claude/*.bak.*  # find backups
```
