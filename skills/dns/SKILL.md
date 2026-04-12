---
name: dns
description: DNS setup for rbren.io subdomains. Use when creating new subdomains, checking DNS records, or issuing SSL certs.
license: MIT
---

# DNS for rbren.io

## Key Facts

- This machine's public IP is **142.93.189.137**
- **`*.app.rbren.io`** (singular "app") has a wildcard DNS record → points here automatically
- `oh.rbren.io` → 142.93.189.137 ✅
- `todo.app.rbren.io` → 142.93.189.137 ✅ (covered by wildcard)
- `artifacts.app.rbren.io` → 142.93.189.137 ✅ (covered by wildcard)
- DNS is managed externally (DigitalOcean DNS panel for `rbren.io`), no local DNS server

## ⚠️ app vs apps — watch out!

- **`*.app.rbren.io`** → 142.93.189.137 (this machine) ✅
- **`*.apps.rbren.io`** → 161.35.255.23 (DIFFERENT machine) ❌

Always use **`app.rbren.io`** (singular) for new subdomains on this machine.

## Adding a new subdomain

For subdomains under `app.rbren.io`, no DNS changes needed — the wildcard covers it.

For other subdomains (e.g. `foo.rbren.io`), a new A-record must be created in the DigitalOcean DNS panel pointing to 142.93.189.137.

## SSL certs

Issue via certbot with webroot authenticator:
```bash
certbot certonly --webroot -w /root/git/openhands-remote/homepage -d <subdomain> --non-interactive --agree-tos
```

Certs land in `/etc/letsencrypt/live/<subdomain>/`. Auto-renewed by certbot systemd timer every 12 hours.

If certbot fails with a challenge error even though DNS is correct, nginx must be serving the ACME challenge path on port 80 for that domain. Make sure there's an HTTP server block with:
```nginx
location /.well-known/acme-challenge/ {
    root /root/git/openhands-remote/homepage;
}
```
