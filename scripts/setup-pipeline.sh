#!/bin/bash
# Setup autonomous dev pipeline for a repository
# Usage: ./setup-pipeline.sh <repo-path> <github-owner> <github-repo>

set -euo pipefail

REPO_PATH="${1:?Usage: setup-pipeline.sh <repo-path> <owner> <repo>}"
OWNER="${2:?Missing GitHub owner}"
REPO="${3:?Missing GitHub repo name}"

echo "🔧 Setting up autonomous dev pipeline for $OWNER/$REPO"

# Create pipeline config
cat > "$REPO_PATH/pipeline.json" << EOF
{
  "repo": {
    "owner": "$OWNER",
    "name": "$REPO",
    "localPath": "$REPO_PATH",
    "defaultBranch": "main",
    "tokenPath": "CONFIGURE_ME"
  },
  "schedule": {
    "devCycle": {
      "cron": "0 8,10,12,14,16,18,20 * * *",
      "timezone": "Europe/Berlin",
      "enabled": true
    },
    "codeAudit": {
      "cron": "0 6 * * *",
      "timezone": "Europe/Berlin",
      "enabled": true
    }
  },
  "models": {
    "lead": "anthropic/claude-opus-4-6",
    "worker": "sonnet",
    "reviewTimeout": 600,
    "workerTimeout": 300
  },
  "autoMerge": {
    "enabled": false,
    "method": "squash",
    "gates": {
      "ciMustPass": true,
      "claudeReviewMustApprove": true,
      "opusReviewRequired": true,
      "noUnresolvedComments": true,
      "noMergeConflicts": true
    }
  },
  "quality": {
    "language": "CONFIGURE_ME",
    "rules": {}
  },
  "notifications": {
    "channel": "telegram",
    "onMerge": true,
    "onFailure": true,
    "onAuditFindings": true
  }
}
EOF

# Create dev state
cat > "$REPO_PATH/dev-state.json" << EOF
{
  "lastCycle": null,
  "currentIssue": null,
  "completedIssues": [],
  "mergedPRs": [],
  "openPRs": [],
  "failedCycles": [],
  "lessons": [],
  "notes": "Pipeline initialized $(date +%Y-%m-%d)"
}
EOF

echo "✅ Created pipeline.json and dev-state.json"
echo ""
echo "Next steps:"
echo "  1. Edit pipeline.json — set tokenPath and language"
echo "  2. Enable autoMerge if desired"
echo "  3. Set up GitHub Actions (see references/crons.md)"
echo "  4. Install Claude Code GitHub App: https://github.com/apps/claude"
echo "  5. Create OpenClaw cron jobs (see references/crons.md)"
