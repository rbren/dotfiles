---
name: agent-server-api
description: How to create conversations via the agent-server REST API. Use when delegating coding tasks to agent-server or spawning new agent conversations.
license: MIT
---

# Agent Server API — Creating Conversations

## Server Locations
- **Primary (conversations app):** `http://localhost:4004`
- **Vibe app:** `http://localhost:4041`
- Source code: `~/git/software-agent-sdk/openhands-agent-server/`

## Authentication
- Header: `X-Session-API-Key`
- Value comes from env var `OH_SESSION_API_KEYS_0`

## Create a Conversation

**POST** `/api/conversations`

### Minimal Payload
```json
{
  "agent": {
    "llm": {
      "model": "anthropic/claude-sonnet-4-20250514",
      "api_key": "<ANTHROPIC_API_KEY>"
    },
    "tools": [{"name": "terminal"}, {"name": "file_editor"}]
  },
  "workspace": {
    "type": "local",
    "working_dir": "/path/to/project"
  },
  "initial_message": {
    "role": "user",
    "content": [{"type": "text", "text": "Your task description here"}],
    "run": true
  }
}
```

### Key Fields

| Field | Required | Notes |
|-------|----------|-------|
| `agent.llm.model` | yes | Format: `provider/model-name` |
| `agent.llm.api_key` | yes | Use `$ANTHROPIC_API_KEY` from env |
| `agent.tools` | yes | Array of `{"name": "..."}` objects. Common: `terminal`, `file_editor`, `browser_tool_set`, `task_tracker`, `delegate` |
| `workspace.type` | yes | Always `"local"` on this machine |
| `workspace.working_dir` | yes | Absolute path to the project root |
| `initial_message` | no | If provided with `"run": true`, agent starts immediately |
| `initial_message.content` | — | Array of `{"type": "text", "text": "..."}` objects |
| `max_iterations` | no | Default 500. Cap to prevent runaway agents |
| `conversation_id` | no | UUID. Auto-generated if omitted |
| `confirmation_policy` | no | Defaults to `NeverConfirm()` |
| `secrets` | no | Dict of secret name → source |
| `autotitle` | no | Default true. Auto-generates title from first message |

### Example curl
```bash
curl -s -X POST http://localhost:4004/api/conversations \
  -H 'Content-Type: application/json' \
  -H "X-Session-API-Key: $AGENT_SERVER_API_KEY" \
  -d '{
    "agent": {
      "llm": {
        "model": "anthropic/claude-sonnet-4-20250514",
        "api_key": "'"$ANTHROPIC_API_KEY"'"
      },
      "tools": [{"name": "terminal"}, {"name": "file_editor"}]
    },
    "workspace": {
      "type": "local",
      "working_dir": "/root/git/my-project"
    },
    "initial_message": {
      "role": "user",
      "content": [{"type": "text", "text": "Fix the bug in main.py"}],
      "run": true
    },
    "max_iterations": 100
  }'
```

### Response
Returns `ConversationInfo` with status 201 (new) or 200 (existing):
```json
{
  "id": "uuid-here",
  "status": "running",
  "workspace": { "type": "local", "working_dir": "..." },
  ...
}
```

## Other Useful Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/conversations/search` | List/search conversations |
| POST | `/api/conversations/{id}/message` | Send message to existing conversation |
| POST | `/api/conversations/{id}/pause` | Pause a conversation |
| POST | `/api/conversations/{id}/resume` | Resume a paused conversation |
| DELETE | `/api/conversations/{id}` | Delete a conversation |
| GET | `/api/conversations/{id}/events` | Get conversation events |

## Notes
- The `working_dir` in workspace is where the agent's terminal starts and where file operations are rooted
- `"run": true` on the initial message means the agent loop starts automatically after receiving the message
- Conversations persist across agent-server restarts via `meta.json` files
- Terminal sessions use tmux (`tmux -Lopenhands` socket) — these can leak if cleanup fails (see known bugs in the codebase)
