# Daily Code Audit Reference

## Audit Checklist

### 1. Security
- Hardcoded secrets, API keys, tokens, passwords
- Path traversal in file operations
- Injection risks (string interpolation in commands/queries)
- HTTPS enforcement on network requests
- Overly broad entitlements/permissions
- URL handling (open redirect, scheme hijacking)
- Insecure data storage (plaintext sensitive data)

### 2. Code Quality
- Unsafe patterns (force unwraps, bare `except`, `unsafe` blocks)
- Empty error handlers (silent failures)
- Debug output in production (`print()`, `console.log()`)
- Memory issues (retain cycles, leaks)
- Lingering TODOs/FIXMEs/HACKs
- Dead code (unused functions, unreachable branches)
- Inconsistent error handling

### 3. Architecture
- God objects (files > 500 lines)
- Separation of concerns violations
- Service isolation
- Concurrency safety
- Data model correctness

### 4. Test Coverage
- Services/models with no tests
- Missing edge case coverage
- Trivial assertions (`assertTrue(true)`)
- Flaky test indicators

### 5. Build Health
- Deprecated API usage
- Compiler warnings
- Dependency vulnerabilities

## Output Protocol

For each finding:
1. Assess severity: critical / high / medium / low
2. Check existing GitHub issues to avoid duplicates
3. Create issue with: title, description, file/line references, suggested fix, severity label
4. Write summary to daily memory file

## Deduplication
Before creating an issue, search existing open issues:
```bash
curl -s -H "Authorization: token $(cat TOKEN)" \
  "https://api.github.com/repos/OWNER/REPO/issues?state=open&per_page=100" \
  | jq '.[].title'
```
If a similar issue exists, add a comment instead of creating a duplicate.
