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

## Quick Start — 最初に使うコマンド3つ

```powershell
# 1. 現在の状態を確認（override有無・モデルルーティング）
.\scripts\oc-prod-status.ps1

# 2. override一覧を検出（-Json で機械可読出力も可）
.\scripts\oc-prod-detect-overrides.ps1
.\scripts\oc-prod-detect-overrides.ps1 -Json

# 3. 異常があれば復旧（status の案内に従う）
.\scripts\oc-prod-reset-overrides.ps1 -SessionKey "agent:main:main"
```

## Next steps

1. Add a runbook for "session model override got stuck".
2. Add a staging verification checklist.
3. Add automation scripts:
   - status summary
   - detect overrides
   - reset overrides (safe)
