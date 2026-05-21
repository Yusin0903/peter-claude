# Git & PR Conventions (TCP Developer Guide)

## Branch Naming

`<type>/<JIRA-ID>_description` or `<type>/<JIRA-ID>-description`

Examples:
- `feat/V1PC-805_add_user_auth`
- `fix/V1PC-805-resolve-login-error`

## PR Title

`<type>: <JIRA-ID> <description>` or `<type>: [<JIRA-ID>] <description>`

Examples:
- `feat: V1PC-805 Add user authentication`
- `fix: [V1PC-805] Resolve login error`

## Commit Messages

Format: `<type>: <JIRA-ID> <description>`

Rules:
- Imperative mood ("Add fix", not "Added fix")
- Capitalize first word after JIRA ID, no trailing punctuation
- Subject line <= 50 chars
- Body (optional) describes "why"
- JIRA ID at the beginning
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
