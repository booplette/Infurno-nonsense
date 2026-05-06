# Infurno — Ministry of Nonsense Task Registry

## Overview
Standalone task tracker for Infurno Festival's Ministry of Nonsense. Single-page React app (CDN-loaded, zero build) with Supabase PostgreSQL backend, deployed on Netlify. User is "boop" — Minister for Nonsense.

## URLs
- **Live site:** https://nonsense.pigpup.farm
- **Netlify dashboard:** https://app.netlify.com/projects/infurno-nonsense
- **GitHub:** https://github.com/booplette/Infurno-nonsense
- **Supabase:** https://cjgtyfretcoblphdxlis.supabase.co
- **Netlify Site ID:** `a94ab0e3-858b-4b95-a2b0-9cae505d1a3d`
- **Netlify Auth Token:** `nfp_1NUxfhdrxWJumAckC5HfySH281bjGm5v2e8c`

## Architecture
- **Frontend:** Single `index.html` — React 18 + ReactDOM + Babel Standalone loaded from CDN
- **Backend:** Supabase PostgreSQL, table `tasks`, RLS enabled with wide-open anon policy
- **Hosting:** Netlify, auto-deploy on `git push origin main`
- **Design:** GOV.UK Frontend colour palette (blue header `#1d70b8`, grey-3 bg `#f3f2f1`, green buttons `#00703c`, dark text `#0b0c0c`), Ministry of Nonsense branding
- **Separation:** Completely standalone — never touch `~/play-menu/` or `pigpup.farm` production files

## File Structure
```
~/infurno/
├── index.html          # Everything — HTML, CSS, React components, Supabase logic
├── _headers            # Netlify: force text/html for Supabase.js
├── netlify.toml        # Build config (no build step, publish = ".")
├── deploy.sh           # Manual deploy wrapper (sets NETLIFY_AUTH_TOKEN)
├── setup-supabase.sql  # Database schema definition
├── STATUS.md           # This file — project state, always read first
└── .gitignore
```

## Database Schema
**Table: `tasks`**
```
id                  UUID (PK, default gen_random_uuid())
title               TEXT
description         TEXT
priority            TEXT  CHECK IN ('critical','high','medium','low')
status              TEXT  CHECK IN ('backlog','active','complete','archived')
owner               TEXT
cost                NUMERIC(10,2)
category            TEXT
notes               TEXT
due_date            DATE
summary             TEXT DEFAULT ''           -- auto-generated task summary
next_step           TEXT DEFAULT ''
next_step_owner     TEXT DEFAULT ''
created_at          TIMESTAMPTZ (default now())
updated_at          TIMESTAMPTZ (default now(), updated by DB trigger)
is_archived         BOOLEAN DEFAULT false
```

## Data State
- **69 tasks** in database, all populated with generated summaries
- Imported from Telegram chat exports (~1100 messages across 2 channels) + attendee spreadsheet
- All tasks have summaries; new tasks get summaries on click via `handleSummarise()`

## Frontend Features
- **CRUD:** Create, edit, delete, archive tasks via modal form
- **Filtering:** By status (all/backlog/active/complete/archived), by priority (all/critical/high/medium/low), show/hide archived
- **Sorting:** Priority (critical→low), Status, Cost (high→low), Owner (A→Z), Next Step Owner, Last Updated (oldest first — edited tasks sink to bottom)
- **Summarise:** Per-task button generates summary from fields, displays in modal with copy-to-clipboard
- **Import:** Parse pipe-delimited text or Telegram JSON chat exports
- **Add Notes:** Per-task notes field in modal, append-only display

## Deploy Workflow
**Auto-deploy (recommended):** `git push origin main` → Netlify auto-deploys in ~30s
**Manual deploy:** `cd ~/infurno && bash deploy.sh "message"`
**Netlify CI/CD:** Branch `main`, publish `.`, no build command

## How to Continue Development (after session loss)
1. Read this file first
2. `cd ~/infurno && cat STATUS.md`
3. Read `index.html` for current code state
4. Edit `index.html` as needed
5. Commit + push: `git add -A && git commit -m "desc" && git push origin main`
6. Wait ~30s then verify: `curl -s https://nonsense.pigpup.farm | grep -o "Crown Copyright"`

## Database Changes
Anon key CANNOT alter schema. When the user needs schema changes:
- Write the exact SQL
- Tell user: "Run this in Supabase Dashboard → SQL Editor"
- User executes it themselves
- Example: `ALTER TABLE tasks ADD COLUMN foo TEXT DEFAULT '';`

## Import Format
**Pipe-delimited:** `TITLE | DESCRIPTION | PRIORITY | OWNER | COST | CATEGORY | NEXT STEP | NEXT STEP OWNER`
**Telegram JSON:** Parse `plain`, `bold`, `italic`, `text_link` entities from `text_entities` arrays in chat export JSON

## Gotchas
1. Netlify CDN caches aggressively — verify with `curl -s --header "Cache-Control: no-cache" https://nonsense.pigpup.farm | grep "Crown Copyright"` to confirm deploy landed
2. Supabase anon key CANNOT change schema — always provide exact SQL, user runs in dashboard
3. Site is completely separate from pigpup.farm — never overwrite `~/play-menu/`
4. Frontend is single `index.html` — all CSS, JS, React components in one file
5. `handleSave` does NOT include `updated_at` in the update payload — DB trigger handles it
6. Sort "Last Updated" uses `updated_at || created_at` fallback, oldest-first so edited tasks sink
7. Modal save button uses direct `onClick={handleSave}` — NOT `<form onSubmit>` (form pattern was broken)
8. `gen_summaries.py` — utility script, not needed in production (safe to ignore/remove)
9. Frontend hardcodes `SUPABASE_URL` and `SUPABASE_ANON` at top of script block in `index.html`
10. `_headers` file required — Supabase.js module needs `text/html` MIME type, not `application/javascript`

## Supabase Config
- **Project URL:** `https://cjgtyfretcoblphdxlis.supabase.co`
- **Anon key:** Hardcoded in `index.html` (search for `SUPABASE_ANON`)
- **RLS:** Enabled, wide-open anon policy
- **Trigger:** `updated_at` auto-updates on row change

## Commands Reference
```bash
# View project state
cat ~/infurno/STATUS.md

# Deploy after git push
curl -s --header "Cache-Control: no-cache" https://nonsense.pigpup.farm | grep -o "Crown Copyright"

# Manual deploy (if CI broken)
cd ~/infurno && bash deploy.sh "message"

# Query DB for debugging
# (use gen_summaries.py as template for curl/python queries)

# Verify file content
cat ~/infurno/index.html | grep -o "Last Updated"
```

## Pending / Future Work
- Import more data (chats, spreadsheets) when user provides them
- Add bulk import from uploaded files (currently text/JSON paste only)
- Add export functionality (download tasks as CSV)
- Add filtering by category or next_step_owner
- Consider adding a dashboard/overview page with stats
