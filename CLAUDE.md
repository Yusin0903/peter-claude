# Global Claude Code Rules

## Security

**NEVER write plaintext secrets (API keys, passwords, tokens, credentials) to any file or commit.** Use `EXAMPLE` or placeholder values.

## Git

- Conventions: @docs/git-conventions.md
- **NEVER run `git commit` unless the user explicitly asks.** No exceptions.

## Language

Mixed Chinese with other languages → default to Chinese.

## Code Quality

- Fix only what was asked; don't refactor untouched code.
- Don't add comments, docstrings, or type annotations to code you didn't change.

## Anti-Sycophancy

For subjective judgment (system design, architecture, tradeoffs, recommendations):

1. Develop 2-3 competing hypotheses BEFORE inferring my preference.
2. Report confidence per option and what evidence would change it.
3. Self-critique your top choice: what's the strongest argument against it?
4. If I push the same preference across turns, do NOT gradually agree. Restate your original position and what NEW evidence (if any) changed it.

**YOU MAY disagree.** Be "honest even if it's not what the user wants to hear."

## Docker Image Platform

Apple Silicon Mac defaults to `linux/arm64`; most cloud runtimes (EKS/ECS) are `linux/amd64`. Mismatched images fail with `exec format error` at runtime.

- **Always specify `--platform`** when pulling images to mirror to a registry.
- Confirm target arch BEFORE pull (check EKS node group `instance_types`); ask user if unclear.

## AI Work Validation

Before editing: identify risk tier (below).

### Risk tiers

A change is **high-risk** if any of:

- Can wake someone up (alerting, paging, on-call routing)
- Affects identity, permissions, or secrets
- Touches production environments
- Is irreversible or destructive (data loss, state corruption, resource deletion)
- Applies differently across environments (scope mismatch)

**High-risk changes MUST be reviewed in a fresh Claude session before commit** (new context eliminates self-review blind spots).

### Verification Report

**YOU MUST** end every task's final response with this block. Use literal tokens `PASS`, `FAIL`, `SKIP`, `NONE`, `YES`, `NO`, `N/A`.

```
## Verification Report
- Task type: edit | read-only investigation | plan only
- Risk tier: high | low
- Separate-session review: YES | NO | N/A
- Changed files: <paths> or NONE
- Checks run: <check>: PASS|FAIL|SKIP (one line per check)
- Checks NOT run: <reason> or NONE
- Residual risk: <one line> or NONE
```

If verification could not be run (no credentials, no cluster access, no tool installed), list it under "Checks NOT run" — never silently omit.
