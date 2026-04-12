---
name: nginx
description: How nginx is configured and managed for openhands-remote
license: MIT
---

The nginx config lives in the repo at `/root/git/openhands-remote/nginx.conf`. It is NOT copied to `/etc/nginx/` — nginx is started directly with `-c` pointing at the repo file.

## Commands

Test config for errors:
```bash
nginx -c /root/git/openhands-remote/nginx.conf -t
```

Start nginx (if not running):
```bash
nginx -c /root/git/openhands-remote/nginx.conf
```

Reload after config changes (no downtime):
```bash
nginx -c /root/git/openhands-remote/nginx.conf -s reload
```

## Workflow for config changes

1. Edit `/root/git/openhands-remote/nginx.conf`
2. Test: `nginx -c /root/git/openhands-remote/nginx.conf -t`
3. Reload: `nginx -c /root/git/openhands-remote/nginx.conf -s reload`

## What the config does

- HTTP (port 80): redirects to HTTPS, except `/.well-known/acme-challenge/` (used for Let's Encrypt cert renewal, webroot at `homepage/`)
- HTTPS (port 443): SSL termination with certs at `/etc/letsencrypt/live/oh.rbren.io/`
- Cookie-based auth via `auth_request` to auth backend on port 4100 (`apps/auth/main.py`); credentials validated against `/etc/nginx/.htpasswd`; `/auth/` and `/apps/sms/api/` bypass auth
- Static routes (`/`, `/status`, `/assistant`, `/files`, etc.) all serve `homepage/index.html`
- Each app is reverse-proxied: `/apps/<name>/` → Vite frontend, `/apps/<name>/api/` → FastAPI backend

## Port assignments

| App       | Frontend | Backend |
|-----------|----------|---------|
| status    | 4001     | 4002    |
| assistant | 4003     | 4004    |
| files     | 4005     | 4006    |
| projects  | 4007     | 4008    |
| secrets   | 4009     | 4010    |
| scheduled | 4011     | 4012    |
| terminal  | 4013     | 4014    |
| skills    | 4015     | 4016    |
| logs      | 4017     | 4018    |
| sms       | 4019     | 4020    |
| hud       | 4021     | —       |
| code-server| —       | 4050    |
