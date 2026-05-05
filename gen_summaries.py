import urllib.request
import json

SUPABASE_URL = 'https://cjgtyfretcoblphdxlis.supabase.co'
SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqZ3R5ZnJldGNvYmxwaGR4bGlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5NjY4MTMsImV4cCI6MjA5MzU0MjgxM30.bjZCRcdhoNXIBhh6er5BuzJ77lGDqJME4QBP0k05x8s'

headers = {
    "apikey": SUPABASE_KEY,
    "Authorization": f"Bearer {SUPABASE_KEY}",
    "Content-Type": "application/json",
    "Prefer": "return=minimal",
}

# Fetch all tasks
req = urllib.request.Request(
    f"{SUPABASE_URL}/rest/v1/tasks?select=*&order=created_at.asc",
    headers=headers,
    method="GET",
)
with urllib.request.urlopen(req) as r:
    tasks = json.loads(r.read().decode())

print(f"Fetched {len(tasks)} tasks")

updated = 0
for task in tasks:
    parts = []
    for field in ["title", "description", "priority", "owner", "cost", "next_step"]:
        val = task.get(field)
        if val:
            if field == "cost":
                parts.append(f"Cost: \u00a3{val}")
            elif field == "next_step":
                parts.append(f"Next step: {val}")
            else:
                parts.append(f"{field.title()}: {val}")
    
    summary = ". ".join(parts)
    if summary:
        patch_headers = {**headers, "Prefer": "return=minimal"}
        patch_req = urllib.request.Request(
            f"{SUPABASE_URL}/rest/v1/tasks?id=eq.{task['id']}",
            headers=patch_headers,
            method="PATCH",
            data=json.dumps({"summary": summary}).encode(),
        )
        try:
            with urllib.request.urlopen(patch_req) as pr:
                updated += 1
        except Exception as e:
            print(f"FAIL {task['id']}: {e}")
    else:
        print(f"SKIP {task['id']}: no data")

print(f"Updated {updated}/{len(tasks)} tasks with summaries")
