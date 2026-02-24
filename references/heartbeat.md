# Heartbeat Integration

## Pipeline Health Checks (during heartbeats)

Add these to your HEARTBEAT.md:

```markdown
### Pipeline Health Check
- Read `dev-state.json` — any failed cycles, rejected PRs, build errors?
- Check `cd REPO && git log --oneline -5` — is progress happening?
- If a worker left broken code or a failing build → fix it NOW (spawn worker)
- If a quality gate was missed → file issue or spawn fix
- Review recent dev cycle cron output — any errors, timeouts, anti-patterns?
```

## What to Fix Immediately
- CI failures on open PRs (rebase, fix compilation, fix tests)
- Workers that created files but forgot project registration
- Merge conflicts from parallel PRs
- Rate limit errors that blocked cycles

## What to Log for Next Cycle
- Issues discovered during heartbeat auditing
- Patterns of worker mistakes (for prompt improvement)
- Config tweaks needed
