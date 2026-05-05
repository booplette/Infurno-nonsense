|-- Infurno Ministry of Nonsense — Database Schema
|-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor)

-- Tasks table
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('critical', 'high', 'medium', 'low')),
  status TEXT NOT NULL DEFAULT 'backlog' CHECK (status IN ('backlog', 'active', 'complete', 'archived')),
  owner TEXT DEFAULT '',
  cost NUMERIC(10,2) DEFAULT 0,
  category TEXT DEFAULT '',
  notes TEXT DEFAULT '',
  due_date DATE,
  next_step TEXT DEFAULT '',
  next_step_owner TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Public access policy (anon key can read/write)
CREATE POLICY "Allow public access to tasks"
  ON tasks
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Trigger to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
