---
name: handoff
description: Compact the current conversation into a handoff document, organised by project under ~/context_record/ so you can switch projects fast.
argument-hint: [project-name] What will the next session focus on?
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work.

## Storage layout

All handoffs live under `~/context_record/`, organised per project:

```
~/context_record/
├── INDEX.md                              # one line per project (auto-maintained)
└── <project>/
    ├── current.md                        # latest handoff — resume target
    └── archive/
        └── YYYY-MM-DD-HHMM-<slug>.md     # timestamped snapshot
```

## Determining `<project>`

1. If the user's first positional argument looks like a project name (kebab-case, no spaces — e.g. `v1-ti-ops`, `my-app`), use it verbatim and treat the rest of the arguments as the focus description.
2. Otherwise auto-detect:
   - Run `git rev-parse --show-toplevel` in cwd. If it succeeds, use `basename` of that path.
   - If not a git repo, use `basename $PWD`.
3. Confirm the resolved project name in your message before writing files, so the user can correct it if wrong.

## What to write

Save **two copies** of the handoff:

1. `~/context_record/<project>/current.md` — overwrite every time. This is the resume target.
2. `~/context_record/<project>/archive/$(date +%Y-%m-%d-%H%M)-<slug>.md` — timestamped snapshot. `<slug>` is a short kebab-case description of the focus (e.g. `thanos-poc`, `auth-refactor`). Derive from the user's arguments if provided, else from the dominant topic of the conversation.

Read each target path before writing (Write tool requires it for existing files).

## Handoff content

Follow this skeleton — tailor sections to what the next agent actually needs:

```markdown
# Handoff: <one-line title>

**Project:** <project>
**Branch:** <git branch if in repo>
**Latest commit:** <short SHA + subject>
**Updated:** <YYYY-MM-DD HH:MM>
**Focus for next session:** <derived from arguments or conversation>

## Current state at handoff
- What was just done, what's mid-flight, what's blocked.

## Decisions that are LOCKED (do not re-grill)
- Bullet list. Each item: decision + one-line rationale.

## Next steps (in order)
1. ...
2. ...

## Open risks / TODO
- ...

## Suggested skills for next session
- ...

## How to resume cleanly
\`\`\`
Read ~/context_record/<project>/current.md
Continue <focus>.
\`\`\`
```

Do not duplicate content already captured in PRDs, plans, ADRs, issues, or commits — reference them by path or URL.

## Maintain INDEX.md

After writing the handoff files, update `~/context_record/INDEX.md` so the user can see all tracked projects at a glance.

- Read INDEX.md first if it exists.
- Ensure there's exactly one line per project, format:
  `- **<project>** — <updated YYYY-MM-DD HH:MM> — <focus headline>`
- Sort by most-recently-updated first.
- Create INDEX.md if absent.

## Finishing

Report to the user:
- The resolved project name.
- Path to `current.md` (the resume target).
- Path to the archive snapshot.
- The exact one-liner the user can paste to resume: `Read ~/context_record/<project>/current.md`
