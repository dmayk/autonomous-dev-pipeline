# Cron Job Templates

## Dev Cycle Cron

Set up via OpenClaw cron:
- **Schedule:** Every 2 hours during work hours (e.g., `0 8,10,12,14,16,18,20 * * *`)
- **Timezone:** Your local timezone
- **Model:** Opus for lead, spawns Sonnet workers
- **Session:** Isolated
- **Timeout:** 600s (10 min)

The cron prompt should instruct the agent to:
1. Read pipeline config and dev state
2. Check open PRs for auto-merge eligibility
3. Pick next issue from priority queue
4. Write implementation spec
5. Spawn Sonnet worker
6. Review result and create PR
7. Update state

## Code Audit Cron

- **Schedule:** Daily at a quiet hour (e.g., `0 6 * * *`)
- **Model:** Opus (needs deep reasoning for security audit)
- **Session:** Isolated
- **Timeout:** 600s

The cron prompt should instruct the agent to:
1. Run the full audit checklist from [code-audit.md](code-audit.md)
2. Check for duplicates before filing issues
3. Write a summary to daily memory

## GitHub Actions (CI)

### Test Workflow
```yaml
name: Tests
on:
  push:
    branches: [main, 'feat/**', 'fix/**', 'bugfix/**', 'security/**', 'refactor/**']
  pull_request:
    branches: [main]
jobs:
  test:
    runs-on: <appropriate-runner>
    steps:
      - uses: actions/checkout@v4
      - name: Build and Test
        run: <build-command-from-config>
```

### Claude Code Review Workflow
```yaml
name: Claude Code Review
on:
  pull_request:
    types: [opened, synchronize, ready_for_review, reopened]
jobs:
  claude-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      issues: read
      id-token: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: anthropics/claude-code-action@v1
        with:
          claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
          prompt: |
            Review this PR. If you find blocking issues (unsafe code, missing
            validation, security vulnerabilities, silent error swallowing),
            submit REQUEST_CHANGES. If clean, APPROVE.
```

Install the Claude Code GitHub App: https://github.com/apps/claude
