# Runbook: Session model/provider overrides (sticky)

## Symptoms

- A conversation keeps using an unexpected provider/model.
- Fallbacks configured in `openclaw.json` seem to be ignored.
- `openclaw sessions --json` shows `providerOverride` / `modelOverride` for the active session.

## Root cause

OpenClaw persists per-session routing overrides in the session store (e.g. `sessions.json`).
This can happen when a model is manually selected in UI/controls.

## Confirm

1) Check global routing config:

```powershell
openclaw models status --json
```

2) Check session store for overrides:

```powershell
openclaw sessions --json
```

Look for:
- `providerOverride`
- `modelOverride`
- `authProfileOverride`

## Recover (preferred)

Use the official reset path (do not edit JSON directly if you can avoid it).

- Reset to default routing:

> Use `session_status` tool with `model=default` (implementation exists in OpenClaw).

If/when the CLI wrapper exists, use:

```powershell
openclaw sessions reset --key <sessionKey> --model
```

## Recover (last resort)

If the tool path is unavailable, remove override keys from the session store:

- Back up:
  - `.../agents/<agent>/sessions/sessions.json`
- Remove keys:
  - `providerOverride`
  - `modelOverride`
  - `authProfileOverride`
  - `authProfileOverrideSource`
- Restart gateway:

```powershell
openclaw gateway restart
```

## Prevention

- Treat manual model selection as **persistent** unless explicitly labeled "one-shot".
- Add monitoring to detect override keys in sessions.json.
