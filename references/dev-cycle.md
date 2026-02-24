# Dev Cycle Reference

## Cycle Steps

### 1. Check State
Read `dev-state.json` for current progress, completed issues, open PRs.
Check git status for any in-progress branches.

### 2. Check Open PRs for Auto-Merge
Before starting new work, check if any existing PRs are ready to merge.
This prevents a backlog of approved-but-unmerged PRs.

### 3. Pick Next Issue
Query GitHub for open issues, ordered by priority labels.
Skip issues that are already completed or have open PRs.
Respect `maxConcurrentPRs` from config.

### 4. Write Implementation Spec
Read the relevant source files. Write a detailed spec covering:
- Exact files to create/modify
- Step-by-step approach
- Edge cases and security considerations
- Tests to add
- Branch name (`feat/issue-N-short-desc`, `fix/issue-N-short-desc`, `security/issue-N-short-desc`)

### 5. Spawn Worker
Use `sessions_spawn` with the worker model. The task must include:
- Full spec from Step 4
- Repo path and git commands
- Quality checklist from pipeline config
- Language-specific requirements (e.g., register new files in project.pbxproj for Swift)
- Instruction to commit, push, and report back

### 6. Review
When worker completes:
- Read the full diff
- Verify quality gates
- Verify language-specific requirements
- If good: create PR via GitHub API
- If bad: log issues, optionally spawn fix worker

### 7. Update State
Write progress to `dev-state.json`.
Log work to daily memory file.

## Branch Naming Convention
- `feat/issue-N-description` — new features
- `fix/issue-N-description` — bug fixes
- `security/issue-N-description` — security fixes
- `refactor/issue-N-description` — architecture improvements
- `ci/issue-N-description` — CI/CD changes

## Error Handling
- If worker times out: log and move to next cycle
- If worker produces broken code: log the failure, don't create PR
- If rate limited: stop gracefully, log for next cycle
- If git conflicts: rebase on main first, then retry
