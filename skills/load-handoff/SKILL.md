---
name: load-handoff
description: Load the latest handoff document for a project and resume work from where the last session left off. The read/resume counterpart to the handoff skill. Use when the user says "start from last state", "resume", "load handoff", "繼續之前", "從之前的狀態開始", or wants to pick up prior work after a /clear.
argument-hint: [project-name] Optional focus to narrow the resume.
---

Read the latest handoff for a project and resume work. This is the **read** counterpart to the `handoff` skill (which **writes**). Do NOT write or overwrite any handoff file here — this skill only loads state and continues work.

## Determining `<project>`

Same rules as the `handoff` skill:

1. If the user's first positional argument looks like a project name (kebab-case, no spaces — e.g. `v1-ti-ops`, `my-app`), use it verbatim. Treat the rest as an optional focus hint.
2. Otherwise auto-detect:
   - Run `git rev-parse --show-toplevel` in cwd. If it succeeds, use `basename` of that path.
   - If not a git repo, use `basename $PWD`.

Note: phrases like "start from last state", "resume", "load handoff" are NOT project names — they are the trigger. When the whole argument is such a phrase, fall through to auto-detect.

## What to do

1. **Read** `~/context_record/<project>/current.md`.
   - If it does not exist, list `~/context_record/` so the user can see which projects have handoffs, and stop. Do not invent state.
2. **Reconcile the recorded state against reality** before trusting it. The handoff is a snapshot and may be stale:
   - Compare the recorded `Latest commit` / `Branch` against actual `git log -1 --oneline` and `git branch --show-current`.
   - Check `git status --short` for drift (new commits, dirty tree, different branch).
   - If they diverge, say so explicitly — the recorded next-steps may no longer apply.
3. **Summarise** for the user, concisely:
   - One-line title + focus.
   - Current state (what's done / mid-flight / blocked).
   - LOCKED decisions (so neither of you re-litigates them).
   - The ordered next steps.
4. **Confirm the resolved project name** and whether the recorded state matches reality.
5. **Do NOT auto-start** high-risk next steps (deploy, apply, commit, anything CLAUDE.md flags high-risk). Surface the next step and let the user point at it. Low-risk continuation (reading a file, planning) may proceed if the user's argument clearly asked to continue.

## Important

- This skill never writes to `~/context_record/`. Loading state is read-only. To save new state, use the `handoff` skill.
- "Returning to a previous state" here means **loading context to continue**, not a git checkout/reset. If the user actually wants to roll the working tree back to a recorded commit, that is a separate git operation — confirm scope and target before doing it, and never reset/checkout-over a dirty tree without asking.
- Respect project memory (e.g. LOCKED decisions in the handoff or in saved memories) — do not re-grill settled decisions.

## Finishing

End with the resolved project name and a one-line statement of the next action you (or the user) will take.
