# MVP Scope (Secretary only)

## Goal

Launch the smallest usable "daily secretary" that works entirely inside **Telegram**.

## Non-goals (for MVP)

- Content production workflows
- Developer workflows (GitHub/CI)
- Multi-channel support (LINE, etc.)
- External DB (Postgres/RDS) and any always-on servers

## Target users

- Individuals / solo operators / small businesses (SMB)
- Not aiming for strict enterprise security requirements at first

## Key constraints

- Infra cost must be minimal.
- UX must avoid slash-commands as the primary input method (JP keyboard friction).

## Core features

1. Task capture
   - Primary: Telegram inline buttons
   - Secondary: Japanese text prefixes (e.g. "タスク: ...", "追加: ...")
   - Minimal input: task body only

2. Task list
   - Show pending tasks

3. Daily check-ins
   - Morning: propose Top 3
   - Night: daily report (done / remaining / tomorrow)

## Storage

- Local file storage (JSON)
- No SQLite required for MVP

## Version pin

- Production baseline: OpenClaw 2026.2.19-2
