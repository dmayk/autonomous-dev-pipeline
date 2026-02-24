# Pipeline Configuration

## pipeline.json Schema

```json
{
  "repo": {
    "owner": "dmayk",
    "name": "Verso",
    "localPath": "/path/to/local/clone",
    "defaultBranch": "main",
    "tokenPath": "/path/to/.secrets/github-token"
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
    "enabled": true,
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
    "language": "swift",
    "rules": {
      "noForceUnwraps": true,
      "noHardcodedSecrets": true,
      "inputValidation": true,
      "errorHandling": true,
      "threadSafety": true,
      "testsRequired": true
    },
    "customChecks": [
      "grep -rn '!' --include='*.swift' | grep -v '//' | grep -v 'test' | grep -v 'IBOutlet'"
    ]
  },
  "issueQueue": {
    "priorityLabels": ["priority:critical", "priority:high", "priority:medium", "priority:low"],
    "excludeLabels": ["wontfix", "duplicate", "on-hold"],
    "maxConcurrentPRs": 3
  },
  "notifications": {
    "channel": "telegram",
    "onMerge": true,
    "onFailure": true,
    "onAuditFindings": true
  }
}
```

## Language Presets

### Swift (macOS/iOS)
```json
{
  "quality": {
    "language": "swift",
    "buildCommand": "xcodebuild test -scheme MyApp -destination 'platform=macOS'",
    "rules": {
      "noForceUnwraps": true,
      "noRetainCycles": true,
      "mainActorRequired": true
    },
    "projectFile": "MyApp.xcodeproj/project.pbxproj",
    "newFileRegistration": "Files must be added to project.pbxproj (PBXFileReference, PBXBuildFile, group children, Sources build phase)"
  }
}
```

### TypeScript/Node.js
```json
{
  "quality": {
    "language": "typescript",
    "buildCommand": "npm run build && npm test",
    "rules": {
      "noAny": true,
      "strictNullChecks": true,
      "noConsoleLog": true
    }
  }
}
```

### Rust
```json
{
  "quality": {
    "language": "rust",
    "buildCommand": "cargo test",
    "rules": {
      "noUnsafe": true,
      "clippyClean": true
    }
  }
}
```

### Python
```json
{
  "quality": {
    "language": "python",
    "buildCommand": "pytest",
    "rules": {
      "typeHints": true,
      "noBarExcept": true,
      "ruffClean": true
    }
  }
}
```
