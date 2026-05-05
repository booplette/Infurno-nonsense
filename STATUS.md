# Infurno — Ministry of Nonsense Task Registry

## Overview
Standalone task tracker for Infurno Festival's Ministry of Nonsense. Built as a single-page React app (CDN-loaded, no build step) with Supabase PostgreSQL backend, deployed on Netlify.

## URLs
- **Live site:** https://nonsense.pigpup.farm
- **Netlify dashboard:** https://app.netlify.com/projects/infurno-nonsense
- **GitHub:** https://github.com/booplette/Infurno-nonsense
- **Supabase:** https://cjgtyfretcoblphdxlis.supabase.co

## Architecture
- **Frontend:** Single `index.html` with React + ReactDOM + Babel loaded from CDN
- **Backend:** Supabase PostgreSQL (table: `tasks`)
- **Hosting:** Netlify (static site, auto-deploy on git push)
- **Design:** GOV.UK Frontend colour palette + Ministry of Nonsense branding
- **Separation:** Standalone Netlify site, NOT linked to pigpup.farm play menu

## File Structure
```
~/infurno/
├── index.html          # Main app (React, Supabase, all logic)
├── _headers            # Netlify: serves as text/html
├── netlify.toml        # Netlify build config (no build step)
├── deploy.sh           # Manual deploy script
├── setup-supabase.sql  # Database schema
├── STATUS.md           # This file
└── .gitignore
```

## Database Schema
**Table: `tasks`**
```
id              UUID (PK)
title           TEXT
description     TEXT
priority        TEXT  CHECK IN (critical/high/medium/low)
status          TEXT  CHECK IN (backlog/active/complete/archived)
owner           TEXT
cost            NUMERIC(10,2)
category        TEXT
notes           TEXT
due_date        DATE
created_at      TIMESTAMPTZ
updated_at      TIMESTAMPTZ
```

## Data State
- **70 tasks imported** from:
  - Telegram chat exports (2 channel exports, ~1100 messages total)
  - Attendee creative submissions spreadsheet (xlsx)
- Import parsed actionable proposals, mapped authors to owners, inferred priority/status from reactions/context

## Deploy Workflow
**Auto-deploy (recommended):** `git push origin main` → Netlify auto-deploys in ~30s
**Manual deploy:** `cd ~/infurno && bash deploy.sh "commit message"`

Netlify CI/CD config:
- Branch: `main`
- Build command: *(blank)*
- Publish directory: `.` (or blank)

## Outstanding Items
- [ ] **DNS CNAME:** `nonsense.pigpup.farm` → needs DNS record pointing to Netlify (pending user-provided DNS credentials)
- [ ] **Supabase `next_step` / `next_step_owner` columns:** Frontend supports these fields but DB migration not yet run
  - SQL to run: `ALTER TABLE tasks ADD COLUMN next_step TEXT DEFAULT ''; ALTER TABLE tasks ADD COLUMN next_step_owner TEXT DEFAULT '';`

## Netlify CI/CD Setup
Connected in UI: Site settings → Continuous Deployment → Repository → `booplette/Infurno-nonsense`
Build command: `echo "no build step needed"`
Publish directory: `.`

## Supabase Config
- **Project URL:** https://cjgtyfretcoblphdxlis.supabase.co
- **Anon key:** (in `index.html` — redacted in memory, stored in repo)
- **RLS:** Enabled, public access policy applied
- **Notes:** Anon key CANNOT change schema. Always run SQL in Supabase Dashboard SQL Editor for changes.

## Gotchas
1. Netlify CDN caches aggressively — verify raw HTML (Crown Copyright footer text) to confirm deploys landed
2. Supabase anon key CANNOT change schema — write the exact SQL, user runs it in dashboard
3. Site is completely separate from pigpup.farm — never overwrite files in play-menu project
4. Frontend is single `index.html` — all CSS, JS, React components live in one file
5. Git push auto-deploys — no build step, no node_modules, no pipeline friction

## Commands to Continue Development
```bash
cd ~/infurno
# Edit index.html, then:
git add -A && git commit -m "description" && git push
```

## Import Format (for future data imports)
Pipe-delimited: `TITLE | DESCRIPTION | PRIORITY | OWNER | COST | CATEGORY | NEXT STEP | NEXT STEP OWNER`
Chat exports: JSON with `plain`, `bold`, `italic`, `text_link` entities in `text_entities` arrays.
