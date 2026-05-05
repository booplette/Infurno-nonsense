# Infurno — Ministry of Nonsense Task Registry

A task management system for the Infurno Festival's Ministry of Nonsense.

## Setup (one-time)

### 1. Create Supabase project
1. Go to https://supabase.com → Sign up / Sign in
2. Create a **new project** (pick any name, e.g. "infurno-nonsense")
3. Note your **Project URL** (looks like `https://xxxxx.supabase.co`)
4. Go to **Settings → API** → Copy the **anon/public** key

### 2. Set up the database
1. In your Supabase dashboard, go to **SQL Editor**
2. Click **New query**
3. Copy the contents of `setup-supabase.sql` and paste it in
4. Click **Run** — this creates the `tasks` table with the right schema

### 3. Configure the site
1. Open `index.html` in a text editor
2. Find these two lines near the top of the `<script>` block:
   ```javascript
   const SUPABASE_URL = 'REPLACE_WITH_YOUR_SUPABASE_URL';
   const SUPABASE_ANON = 'REPLACE_WITH_YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace the placeholder values with your actual Supabase credentials

### 4. Deploy to Netlify
1. Go to https://app.netlify.com → **Add new site** → **Import an existing project** → **Deploy manually**
2. Copy the **Site ID** from the site settings
3. Open `deploy.sh` and fill in:
   ```bash
   SITE_ID="your-site-id-here"
   TOKEN="your-netlify-api-token-here"  # Use the permanent token: nfp_1NUxfhdrxWJumAckC5HfySH281bjGm5v2e8c
   ```
4. Run: `bash deploy.sh "initial deploy"`

## Usage

### Adding tasks
- Click **"+ New Task"** to create a task manually
- Fill in title, description, priority, status, owner, cost, category, due date, and notes

### Importing data
- Click **"Import Data"**
- Paste pipe-separated data (one task per line):
  ```
  TITLE | DESCRIPTION | PRIORITY | OWNER | COST | CATEGORY
  ```
- Supported priorities: critical, high, medium, low
- Or drag-and-drop a `.txt` or `.csv` file

### Managing tasks
- Click any task to edit it
- Filter by status, priority, or search by text
- Sort by priority, status, cost, date, or owner

## File structure
```
infurno/
├── index.html          # Single-page React app
├── setup-supabase.sql  # Database schema (run in Supabase)
├── deploy.sh           # Netlify deploy script
└── README.md           # This file
```

## Design
- **Gov.uk functional design** — GDS Transport font, clean borders, focus indicators, high contrast
- **Ministry of Nonsense branding** — red header, sepia tones, "NONSENSE" watermark stamp
- **No framework build step** — React + Babel loaded from CDN, single HTML file
