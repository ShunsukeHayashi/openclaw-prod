# openclaw-prod

Production operations layer for **OpenClaw**.

This repo is intentionally **not** a fork of OpenClaw.
It contains the pieces you need to run OpenClaw as an "OS" in production:

- Runbooks (what to do when something breaks)
- Guardrails (prevent breaking changes / sticky overrides)
- Upgrade gates (staging → verification → production)
- Automation scripts (status/diagnostics/reset helpers)

## Baseline (Pinned)

- OpenClaw version (prod): **2026.2.19-2**
- Policy: production is pinned; upstream is tracked separately and only merged after verification.

## Repo Structure (planned)

```
openclaw-prod/
  runbooks/
  scripts/
  policies/
  staging/
```

## Next steps

1. Add a runbook for "session model override got stuck".
2. Add a staging verification checklist.
3. Add automation scripts:
   - status summary
   - detect overrides
   - reset overrides (safe)
