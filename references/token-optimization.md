# Token Optimization Guide

## Principles
1. **Opus for decisions, Sonnet for execution** — never burn Opus tokens on grep-able work
2. **Self-contained prompts** — don't read 5 files every cycle when instructions can be inline
3. **Reference files on-demand** — only read auto-merge.md when checking PRs, not every cycle
4. **Grep-first auditing** — concrete shell commands beat LLM reasoning for pattern detection

## Model Selection by Task

| Task | Model | Why |
|------|-------|-----|
| Dev cycle (lead/review) | Opus | Architecture decisions, quality judgment |
| Implementation (worker) | Sonnet | Code generation, file editing |
| Code audit | Sonnet | Mostly grep + pattern matching |
| Stock analysis (expert panel) | Opus | Deep reasoning, synthesis |
| Monitoring (BTC, health) | Sonnet or script | Deterministic checks |
| Chat with user | Opus | Nuanced conversation |

## Cron Prompt Design

### Bad (token-heavy)
```
Read SKILL.md for the system design.
Read pipeline.json for config.
Read dev-state.json for state.
Read dev-cycle.md for cycle steps.
Read auto-merge.md for merge gates.
Now execute the cycle...
```
**Cost:** ~8k tokens just reading files, 7x/day = 56k wasted tokens

### Good (self-contained)
```
Config: repo path, token path, state file path.
Cycle steps: 1. Read state. 2. Check PRs for auto-merge. 3. Pick issue...
Reference files (read ONLY when needed): auto-merge.md for gate details.
```
**Cost:** ~2k tokens for the prompt, files loaded only when relevant

## Code Audit Optimization

### Bad
Using Opus to reason about what to grep for, then interpreting results.

### Good
Pre-written grep commands in the prompt. Sonnet runs them, interprets output,
files issues. Opus only needed if findings require architectural judgment.

```bash
# Pre-built audit commands — Sonnet just runs these
grep -rn '!' --include='*.swift' Foram/ | grep -v '//\|IBOutlet\|!='
grep -rn 'catch.*{' --include='*.swift' Foram/ -A1 | grep -B1 '}$'
grep -rn 'print(' --include='*.swift' Foram/ | grep -v '//'
find Foram/ -name '*.swift' -exec wc -l {} + | sort -rn | head -10
```

## Monitoring Optimization

### Principle: Use scripts, not LLMs, for deterministic checks
If a check is just "hit an API and compare a number," it should be a cron script,
not an LLM session. LLM sessions are for checks that require judgment.

### Example: BTC wallet monitoring
A Node.js script running via system crontab costs zero LLM tokens.
Only alert the LLM (via webhook or file flag) when something actually changes.
