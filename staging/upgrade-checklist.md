# Upgrade Checklist (staging → prod)

Production is pinned. Upgrades are only merged after passing this checklist.

## 0) Prep

- Record current prod baseline:
  - `openclaw --version`
- Ensure you can roll back (keep installer / version pin / state backup).

## 1) Pull upstream (staging only)

- Update OpenClaw to the target version (staging machine only).
- Restart gateway.

## 2) Smoke tests

### Gateway
- `openclaw status`
- `openclaw health`

### Channels
- `openclaw channels status --probe`
- Send/receive a Telegram message.

### Models
- `openclaw models status --json`
- Confirm defaultModel + fallbacks are correct.

### Sessions
- `openclaw sessions --json`
- Confirm you can detect overrides.
- If available: confirm override reset path works ("model=default" behavior or CLI wrapper).

### Regression: rate limit / cooldown handling
- Trigger a controlled failure if possible and verify the system recovers (fallback or a clear error + recovery path).

## 3) Decision

- If any smoke test fails → do not upgrade prod.
- If all pass → schedule prod upgrade and keep a rollback window.

## 4) Prod upgrade

- Upgrade OpenClaw on prod.
- Restart gateway.
- Re-run smoke tests.

## 5) Record

- Write a short changelog note (what changed, when, why, who approved).
