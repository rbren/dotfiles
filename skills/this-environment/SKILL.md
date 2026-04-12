---
name: this-environment
description: Complete guide to this DigitalOcean droplet running openhands-remote at oh.rbren.io — hardware, networking, apps, auth, DNS, and how to add new things
license: MIT
---

# The Machine

DigitalOcean Droplet running **Ubuntu 24.04.3 LTS** (kernel 6.8.0-71-generic, x86_64).

| Resource | Value |
|----------|-------|
| CPU | 4 vCPU (DO-Regular) |
| RAM | 7.8 GB (no swap) |
| Disk | 154 GB `/dev/vda1` (~22 GB used, ~133 GB free) |
| Public IP | 142.93.189.137 |
| VPC IP | 10.17.0.6 (eth0), 10.132.0.2 (eth1) |
| Hostname | openhands-assistant |
| Domain | **oh.rbren.io** |

Everything runs as **root**. No containers in use — all services are bare processes.

# Networking & DNS

- **Public interface**: eth0 at 142.93.189.137
- **DNS resolvers**: DigitalOcean's (67.207.67.2, 67.207.67.3) via systemd-resolved
- **Firewall**: UFW is **inactive**. iptables is wide open (INPUT ACCEPT). The only network-level protection is **fail2ban** (sshd + nginx-http-auth jails).
- **DNS management**: External (likely DigitalOcean DNS panel for `rbren.io`). No local DNS server.
- **Docker**: Installed but not actively running containers. Bridge at 172.17.0.1.

### Domains

| Domain | Points to | Purpose |
|--------|-----------|---------|
| `oh.rbren.io` | 142.93.189.137 | Main platform (all apps under `/apps/*`) |
| `*.app.rbren.io` | 142.93.189.137 | Wildcard — use for new subdomains |
| `todo.app.rbren.io` | 142.93.189.137 | Standalone todo app |
| `artifacts.app.rbren.io` | 142.93.189.137 | Static file server for vibe artifacts |

# SSL/TLS

**Let's Encrypt** via **certbot** with **webroot** authenticator (webroot: `/root/git/openhands-remote/homepage`).

| Domain | Cert path | Expires |
|--------|-----------|---------|
| oh.rbren.io | `/etc/letsencrypt/live/oh.rbren.io/` | 2026-05-22 |
| todo.app.rbren.io | `/etc/letsencrypt/live/todo.app.rbren.io/` | 2026-06-27 |

- Key type: ECDSA
- Auto-renewal: certbot systemd timer runs every 12 hours
- No wildcard certs — each subdomain gets its own cert

Issue a new cert:
```bash
certbot certonly --webroot -w /root/git/openhands-remote/homepage -d <subdomain>
```

# Authentication

Cookie-based auth via a FastAPI service on port 4100 (`apps/auth/main.py`).

- Validates against `/etc/nginx/.htpasswd` (single user: `rbren`, APR1/MD5 hash)
- Sets `oh_session` cookie (HMAC-SHA256 token, 90-day, httponly, secure, samesite=lax)
- `SECRET_KEY` is random per restart (no `AUTH_SECRET_KEY` env var set) — sessions invalidate on restart
- nginx `auth_request /auth/check` on every location under `oh.rbren.io`
- Auth bypassed for: `/auth/`, `/apps/sms/api/` (webhooks), `/apps/bbbb-watch/` (own basic auth)

**fail2ban**: 5 failures in 10 min → IP banned 1 hour. Config at `/etc/fail2ban/jail.d/nginx-http-auth.conf`.

⚠️ All backend ports (4002–4100) bind to `0.0.0.0` and are accessible directly by IP, bypassing nginx auth.

# Nginx

The **real nginx config** is `/root/git/openhands-remote/nginx.conf` — NOT `/etc/nginx/nginx.conf`. nginx is started with `-c` pointing at the repo file.

```bash
nginx -c /root/git/openhands-remote/nginx.conf -t      # test
nginx -c /root/git/openhands-remote/nginx.conf -s reload # reload
```

Two server blocks:
1. **oh.rbren.io** (:80 → HTTPS redirect, :443 → SSL + cookie auth + reverse proxy to all apps)
2. **todo.app.rbren.io** (:80 → HTTPS redirect, :443 → SSL + proxy to port 4032, no auth_request)

Frontend modes controlled by `frontend-modes.conf`: status, files, terminal, logs are **static** (built, served by nginx alias); all others are **dev** (Vite dev server proxy). Generated nginx snippets live in `nginx-frontends/`.

# The Platform: openhands-remote

**Repo**: `/root/git/openhands-remote` (remote: `git@github.com:rbren/openhands-remote.git`, branch: master)

A self-hosted dashboard at **oh.rbren.io** that bundles ~20 micro-apps under one roof. The **homepage** (`homepage/index.html`) is a single HTML file that acts as the application shell — it has a collapsible left sidebar and lazy-loads each app in an iframe.

### How the homepage/meta app works

- Left sidebar with 3 sections: **Agents** (Conversations, Vibe, Kanban, HUD), **Settings** (LLM, Secrets, Projects, Scheduled, Skills, MCP, SMS), **System** (VS Code, Status, Terminal, Files, Logs)
- Each nav item activates an iframe (`data-src` lazy loading)
- URL synced via `pushState` — conversations and vibe support deep linking to `/conversations/{id}` and `/vibe/{id}`
- Child iframes communicate via `postMessage` (`conversations-navigate`, `vibe-navigate`, `conversations-select`, `vibe-select`)
- **Mini Chat**: floating 💬 button in bottom-right, creates a toolless conversation for quick LLM Q&A
- **Power Cycle** button at bottom of sidebar — calls `POST /apps/status/api/restart` → runs `restart.sh`

### Port Assignments

| App | Frontend | Backend | Tech |
|-----|----------|---------|------|
| auth | — | 4100 | FastAPI (cookie auth via htpasswd) |
| status | 4001 | 4002 | React + FastAPI (psutil system monitor) |
| conversations | 4003 | 4004 | React + agent-server (AI chat with full tool suite) |
| files | 4005 | 4006 | React + FastAPI (filesystem CRUD) |
| projects | 4007 | 4008 | React + FastAPI (~/git/ repo overview) |
| secrets | 4009 | 4010 | React + FastAPI (key-value store → secrets.json) |
| scheduled | 4011 | 4012 | React + FastAPI (cron-based scheduled conversations) |
| terminal | 4013 | 4014 | React (xterm.js) + FastAPI (real PTY via WebSocket) |
| skills | 4015 | 4016 | React + FastAPI (skills + agent definitions manager) |
| logs | 4017 | 4018 | React + FastAPI (log file viewer) |
| sms | 4019 | 4020 | React + FastAPI (Twilio SMS → conversations) |
| hud | 4021 | — | React (draggable conversation cards) |
| mcp | 4022 | 4023 | React + FastAPI (MCP server config → mcp.json) |
| kanban | 4025 | — | React (conversations by project × status) |
| llm | 4026 | 4027 | React + FastAPI (model/API key settings) |
| vibe | 4040 | 4041 + 4042 | React + agent-server + artifacts API (vibecoding) |
| todo | — | 4032 | FastAPI + SQLite (also at todo.app.rbren.io) |
| code-server | — | 4050 | VS Code in browser (`--auth none`, protected by nginx) |
| bbbb-watch | — | 4030 | FastAPI (movie/TV watchlist, own basic auth, TMDB API) |

### Key Apps

**Conversations** — AI chat powered by the `software-agent-sdk` agent-server on port 4004. Tools: terminal, file_editor, browser_tool_set, glob, grep, planning_file_editor. Supports delegation (sub-agents). Each conversation gets a PLAN.md at `/tmp/openhands-plans/{id}/`.

**Vibe** — Vibecoding assistant with a separate agent-server on port 4041. Creates HTML/MD artifacts stored in `~/git/artifacts/{conversationId}/`, auto-committed to git.

**Shared library** (`apps/shared/`) — React components (ConversationList, ChatView, EventBubble) and hooks (useSettings, useProjects, useAgentConversation) reused by conversations, vibe, hud, kanban via Vite `@shared` alias.

### restart.sh

`/root/git/openhands-remote/restart.sh` is the master orchestration script. It:
1. Kills all services by port
2. Starts all FastAPI backends via uvicorn
3. Starts the conversations agent-server (`uv run agent-server --port 4004`)
4. Reads `frontend-modes.conf` to decide static vs dev for each frontend
5. Builds static frontends / starts Vite dev servers
6. Generates nginx frontend snippets
7. Reloads nginx

⚠️ The vibe agent-server (port 4041), vibe artifacts (port 4042), todo (port 4032), bbbb-watch (port 4030), and code-server (port 4050) are NOT managed by restart.sh — they're started separately.

# Key Config Files

| File | Purpose |
|------|---------|
| `~/.openhands/remote/assistant-settings.json` | LLM model, API key, agent-server URL, session key, tools |
| `~/.openhands/remote/secrets.json` | Environment secrets (injected into conversations) |
| `~/.openhands/remote/mcp.json` | MCP server config (currently: Slack) |
| `~/.openhands/remote/sms-messages.json` | SMS message history |
| `~/.openhands/agent_settings.json` | Agent/LLM config (Claude Opus, condenser settings, tool list) |
| `~/.openhands/agents/default.md` | Default agent definition for delegation |
| `~/.openhands/skills/*/SKILL.md` | Agent skills (this file is one of them) |
| `/etc/nginx/.htpasswd` | Login credentials (user: rbren) |
| `/root/git/openhands-remote/nginx.conf` | The real nginx config |
| `/root/git/openhands-remote/frontend-modes.conf` | Static vs dev mode per frontend |

# Other Repos in ~/git/

| Repo | What it is |
|------|-----------|
| `software-agent-sdk` | The OpenHands agent-server that powers conversations/vibe backends |
| `typescript-client` | TS client library for the agent-server API (symlinked as dependency) |
| `artifacts` | Git repo storing vibe artifacts by conversation ID |
| `bbbb-watch` | Movie/TV watchlist app (separate from openhands-remote) |
| `todo` | Standalone todo app (also served via openhands-remote) |
| `openhands-reference` | Full OpenHands codebase |
| `openhands-cli` | OpenHands CLI |
| `openhands-web-clone` | Clone of OpenHands web UI |
| `personal-ai-devbox` | Docs/prompts for this setup |
| `calendar-widget` | Calendar widget (Vite + TS) |
| `dotfiles` | Personal dotfiles |
| Others | sine, sine-wave, posthog-readiness, oh-desktop, oh-status, todo-demo, todo-example |

# Adding a New App

No automated script — it's manual:

1. Create `apps/<name>/backend/main.py` (FastAPI) and/or `apps/<name>/frontend/` (Vite React)
2. Pick next available port pair (odd=frontend, even=backend)
3. Add to `nginx.conf`: homepage route (`location = /<name>`) + API proxy + frontend proxy
4. Add to `restart.sh`: `start_backend` and/or `start_dev_frontend` calls
5. Add to `homepage/index.html`: nav item in sidebar + iframe + entry in `APPS` JS object
6. Reload nginx: `nginx -c /root/git/openhands-remote/nginx.conf -s reload`

# Adding a New Subdomain

1. Create DNS A-record for the subdomain pointing to 142.93.189.137 (via DigitalOcean DNS or registrar)
2. Issue cert: `certbot certonly --webroot -w /root/git/openhands-remote/homepage -d <subdomain>`
3. Add `server {}` blocks (HTTP redirect + HTTPS) to `nginx.conf`
4. Test & reload: `nginx -c /root/git/openhands-remote/nginx.conf -t && nginx -c /root/git/openhands-remote/nginx.conf -s reload`

# Cron Jobs

```
0 0 * * *   docker system prune -af --filter "until=168h"      # nightly docker cleanup
0 9 * * *   post-conversation.sh "..." "slack update"           # daily scheduled conversation
```
Several calendar-widget team prompts (architect, PM, engineer, docs) exist but are commented out.

# CI/CD

GitHub Actions workflow (`.github/workflows/docker.yml`) builds a multi-arch Docker image on push to master → `ghcr.io/rbren/openhands-remote:latest`. The Dockerfile does a full build of all frontends as static. In practice, this machine runs everything natively, not in Docker.
