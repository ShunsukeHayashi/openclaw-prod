# Telegram UX (MVP)

## Principle

Avoid slash commands as the primary UX.
Use inline buttons + short Japanese prompts.

## Always-available menu (inline buttons)

- ➕ タスク追加
- 📋 一覧
- ☀️ 今日
- ✅ 完了
- ⚙️ 設定 (later)

## Flows

### Add task

1) User taps: ➕ タスク追加
2) Bot asks: "タスク内容を送ってください" (one message)
3) Bot saves to tasks.json and replies: "登録した: <body>"

### List tasks

- Show pending tasks with numeric indices
- Add per-task buttons later (done/delete)

### Complete task

MVP approach:
- User taps ✅ 完了
- Bot asks: "どれを完了にする？番号で返信して"

(Buttons per task can be added in v1.)

## Text fallback (optional)

Recognize Japanese prefixes:
- `タスク: ...`
- `追加: ...`
- `やる: ...`

Only treat these as task capture to avoid false positives.
