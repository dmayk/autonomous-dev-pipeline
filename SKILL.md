---
name: autonomous-dev-pipeline
description: |
  Autonomous multi-agent software development pipeline with Opus as lead architect
  and Sonnet workers for implementation. Includes continuous development cycles,
  auto-merge with quality gates, daily code audits, and GitHub integration.
  Use when setting up autonomous development on a repository, running dev cycles,
  performing code audits, or managing a CI/CD pipeline with AI-driven quality gates.
  Supports any language/framework — configure via pipeline.json.
---

# Autonomous Dev Pipeline

A professional autonomous development pipeline using multi-agent orchestration.
Opus leads architecture and review; Sonnet workers implement. Code quality and
security are non-negotiable.

## Quick Start

1. Create `pipeline.json` in your workspace (see [references/config.md](references/config.md))
2. Set up cron jobs using the templates in [references/crons.md](references/crons.md)
3. The pipeline runs autonomously — you merge PRs (or enable auto-merge)

## Architecture

```
┌─────────────────────────────────────────────┐
│                 OPUS (Lead)                  │
│  • Picks issues from priority queue         │
│  • Writes implementation specs              │
│  • Reviews all code (quality + security)    │
│  • Decides auto-merge or hold               │
│  • Runs daily code audits                   │
└──────────┬──────────────┬───────────────────┘
           │              │
     ┌─────▼─────┐ ┌─────▼─────┐
     │  SONNET   │ │  SONNET   │
     │  Worker 1 │ │  Worker 2 │
     │  (impl)   │ │  (impl)   │
     └───────────┘ └───────────┘
           │              │
     ┌─────▼──────────────▼───────────────────┐
     │            GitHub                       │
     │  • CI tests (GitHub Actions)            │
     │  • Claude Code Review (approve/reject)  │
     │  • Auto-merge when all gates pass       │
     └────────────────────────────────────────┘
```

## Pipeline Components

### 1. Dev Cycle (every 2 hours)
Picks an issue, writes a spec, spawns a Sonnet worker, reviews the result,
creates a PR. See [references/dev-cycle.md](references/dev-cycle.md).

### 2. Auto-Merge Gates
PRs merge automatically ONLY when ALL gates pass:
- CI tests pass (GitHub Actions)
- Claude Code Review approves
- Opus expert review approves (reads full diff)
- No unresolved review comments
- No merge conflicts

If ANY gate fails, PR stays open. See [references/auto-merge.md](references/auto-merge.md).

### 3. Daily Code Audit (once per day)
Comprehensive security + quality audit of the entire codebase.
Files GitHub issues for every finding. See [references/code-audit.md](references/code-audit.md).

### 4. Heartbeat Integration
During heartbeats, check pipeline health:
- Any failed dev cycles?
- Any CI failures on open PRs?
- Fix broken builds immediately (spawn Sonnet worker)
See [references/heartbeat.md](references/heartbeat.md).

## Quality Gates (NON-NEGOTIABLE)

Every piece of code must pass before PR creation:

1. **Builds** — project compiles without errors
2. **No unsafe patterns** — language-specific (force unwraps in Swift, unsafe in Rust, etc.)
3. **No hardcoded secrets** — grep for API keys, tokens, passwords
4. **Input validation** — all external input validated
5. **Error handling** — no silent failures
6. **Thread safety** — proper concurrency patterns
7. **Tests** — new code has tests, existing tests pass
8. **Security** — no injection, traversal, or data exposure risks

## Configuration

All pipeline settings live in `pipeline.json`. See [references/config.md](references/config.md) for the full schema.

## Self-Improvement Loop

After every correction or failure:
1. Log the lesson in `dev-state.json` under `lessons`
2. Update pipeline prompts to prevent recurrence
3. Review lessons at the start of each cycle

## Files

| File | Purpose |
|------|---------|
| `pipeline.json` | Pipeline configuration (repo, schedule, quality rules) |
| `dev-state.json` | Current state (completed issues, open PRs, lessons) |
| `scripts/setup-pipeline.sh` | Initialize pipeline for a new repo |
