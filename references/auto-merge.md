# Auto-Merge Reference

## Gate Checks

### Gate 1: CI Tests Pass
```bash
curl -s -H "Authorization: token $(cat TOKEN)" \
  "https://api.github.com/repos/OWNER/REPO/commits/SHA/check-runs" \
  | jq '.check_runs[] | {name, conclusion}'
```
ALL check runs must have `conclusion: "success"`.

### Gate 2: Claude Code Review Approved
```bash
curl -s -H "Authorization: token $(cat TOKEN)" \
  "https://api.github.com/repos/OWNER/REPO/pulls/NUMBER/reviews" \
  | jq '.[] | select(.state == "APPROVED") | {user: .user.login, state}'
```
At least one `APPROVED` review must exist. No `CHANGES_REQUESTED` reviews pending.

### Gate 3: Opus Expert Review
Read the full diff and evaluate:
- Does the code solve the issue correctly?
- Is error handling comprehensive?
- Are there security concerns?
- Is the code clean and maintainable?
- Are tests meaningful (not just `assertTrue(true)`)?
- Would a staff engineer approve this?

### Gate 4: No Unresolved Comments
```bash
curl -s -H "Authorization: token $(cat TOKEN)" \
  "https://api.github.com/repos/OWNER/REPO/pulls/NUMBER/comments" \
  | jq 'length'
```
All review threads must be resolved.

### Gate 5: No Merge Conflicts
```bash
curl -s -H "Authorization: token $(cat TOKEN)" \
  "https://api.github.com/repos/OWNER/REPO/pulls/NUMBER" \
  | jq '{mergeable, mergeable_state}'
```
`mergeable` must be `true`, `mergeable_state` should be `clean`.

## Merge Execution
```bash
curl -s -H "Authorization: token $(cat TOKEN)" \
  -X PUT "https://api.github.com/repos/OWNER/REPO/pulls/NUMBER/merge" \
  -d '{"merge_method": "squash", "commit_title": "TITLE (#NUMBER)"}'
```

## Post-Merge
1. Update `dev-state.json` — move PR from `openPRs` to `mergedPRs`
2. Delete the remote branch
3. Pull main locally
4. Log to daily memory
5. Notify user (if configured)

## Safety Rails
- Never force-merge past failing gates
- Log which gate failed when holding a PR
- If a PR has been open >48h without passing, flag for manual review
