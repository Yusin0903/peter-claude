# Git & PR Conventions (TCP Developer Guide)

## Branch Naming

`<type>/<JIRA-ID>_description` or `<type>/<JIRA-ID>-description`

Examples:
- `feat/V1PC-805_add_user_auth`
- `fix/V1PC-805-resolve-login-error`

## PR Title

`<type>(<scope>): <JIRA-ID> <description>` — same format as commit subjects.

Examples:
- `feat(auth): V1PC-805 add user authentication`
- `fix(login): V1PC-805 resolve login error`

## Commit Messages

Format: `<type>(<scope>): <JIRA-ID> <description>`

- `<type>` — the kind of change (see Allowed Types below).
- `<scope>` — **optional**; the area the change touches: a module / component /
  subsystem / environment name. Pick the one the reader cares about most.
  Omit it (and its parentheses) when the change is broad or global. Multiple
  scopes: comma-separated.
- `<JIRA-ID>` — required, right after the colon.
- `<description>` — imperative mood ("add", not "added"), lowercase start, no
  trailing period.

Examples:
- `feat(thanos): AVATAR-9336 add central Thanos stack`
- `fix(dns): AVATAR-9336 align regional cert with upstream`
- `chore(deploy): AVATAR-9617 default the bool toggles to false`
- `fix(au/eks): AVATAR-9642 add brownfield LT guards` (env/component scope)
- `refactor: AVATAR-9617 migrate global-system from upstream` (no scope — broad change)

Rules:
- Imperative mood ("Add fix", not "Added fix")
- JIRA ID required, immediately after the colon
- Subject line <= 72 chars
- Body (optional) describes "why"
- Remove unused/commented code before committing

## Allowed Types

| Type | Description |
|---|---|
| `feat` | New features or enhancements |
| `fix` | Bug fixes or corrections |
| `chore` | Routine tasks or maintenance |
| `test` | Adding or updating tests |
| `refactor` | Code improvements without changing behaviour |
| `poc` | Proof of concept or experimental code |
| `break` | Changes that cause backward incompatibility |

## PR Merge Strategy

- Prefer **Rebase and Merge** (linear history)
- **Squash and Merge** acceptable with strong use case
- Do NOT use **Create a Merge Commit**
