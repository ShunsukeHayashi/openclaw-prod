# Task Storage (MVP)

## Why

We want minimal infra + maximal reliability.

## Format

Store tasks as a single JSON file on the host running the gateway.

- Path (prod recommendation):
  - `C:\Users\shuns\Dev\openclaw-state\data\tasks.json`

## Schema (v0)

```json
{
  "version": 0,
  "updatedAt": 0,
  "tasks": [
    {
      "id": "uuid",
      "createdAt": 0,
      "updatedAt": 0,
      "status": "pending",
      "body": "Call supplier about invoice",
      "source": {
        "channel": "telegram",
        "chatId": "telegram:7654362070",
        "messageId": "123"
      }
    }
  ]
}
```

- `status`: `pending` | `done`
- MVP input is `body` only.
- Optional fields (later): dueAt, tags, priority, owner, recurrence

## Backup / durability

- Write atomically: temp file + rename
- Keep a simple rotating backup:
  - `tasks.json.bak.1`, `tasks.json.bak.2`

## Multi-user

For MVP, store can be global or per-chat.
If per-chat is needed later, add `scopeKey` or store-per-session.
