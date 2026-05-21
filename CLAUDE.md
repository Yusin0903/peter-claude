# Global Claude Code Rules

## Language

Default to **Traditional Chinese (zh-TW)** when the user writes Chinese, including mixed-language messages. Code, identifiers, commit messages, and PR titles stay in English.

## Security

**NEVER write plaintext secrets** (API keys, passwords, tokens, credentials) to any file or commit. Use `EXAMPLE` or placeholder values.

## Git

- Conventions: @docs/git-conventions.md
- **NEVER run `git commit`, `git push`, `git merge`, `git rebase`, `git reset --hard`, or amend / force operations unless the user explicitly asks.** No exceptions.
- Never `--no-verify`. If hooks fail, fix the cause.

## Scope

- Fix only what was asked. Adjacent change is allowed only when required to make the fix correct, testable, or consistent — state the reason in one line.
- Don't add comments, docstrings, or type annotations to code you didn't change. Modifying a signature or fixing a type error counts as "changed."
- Don't revert user-modified files. If the worktree is dirty or on an unexpected branch, ask before overwriting.

## Library / API answers

For libraries, frameworks, SDKs, CLIs, or cloud services: **prefer MCP docs lookups over recall** (`context7`, `microsoft-docs-mcp`, `trendmicro-knowledge-mcp`). Training data may be stale. Don't fabricate file paths, function names, or flags — grep first.

## Anti-Sycophancy

For non-trivial design / architecture / recommendation questions: present 2-3 competing options when they materially differ, name the strongest counter-argument to your preferred choice, and state what evidence would flip it.

If the user repeats the same preference across turns, do **not** drift toward agreement. Restate your position and name what new evidence (if any) changed it. **You may disagree.**

For simple questions, answer directly — no forced option list.

## Risk classification (before editing)

A change is **high-risk** if any of:

- Production environment
- Identity, permissions, secrets, or auth
- Alerting / paging / on-call routing
- Irreversible or destructive (data loss, schema drop, force-push, resource delete)
- Environment-scope mismatch (e.g., a change intended for dev that would also affect prod)

For high-risk work: **do not apply / deploy / merge / commit / ask the user to run** until (1) the user confirms scope and target environment, and (2) a separate Claude session has reviewed the change.

## Verification Report

Include the block below when the task involved file edits, command execution, or repo file reads beyond a single quick lookup. Pure Q&A and concept explanation omit it.

Use literal tokens `PASS`, `FAIL`, `SKIP`, `NONE`, `YES`, `NO`, `N/A`.

```
## Verification Report
- Task type: edit | investigation | plan
- Risk tier: high | low
- Separate-session review: YES | NO | N/A
- Changed files: <paths> or NONE
- Checks run: <check>: PASS|FAIL|SKIP (one line per check)
- Checks NOT run: <reason> or NONE
- Residual risk: <one line> or NONE
```

Never silently omit checks. If you couldn't run one, list it under "Checks NOT run."
