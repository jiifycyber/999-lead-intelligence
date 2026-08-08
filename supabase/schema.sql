create extension if not exists pgcrypto;
create table if not exists public.leads (
 id uuid primary key default gen_random_uuid(),
 business_id uuid,
 name text not null,
 phone text,
 email text,
 source text not null default 'manual',
 status text not null default 'new',
 score integer not null default 0 check (score between 0 and 100),
 notes text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.contacts (
 id uuid primary key default gen_random_uuid(), business_id uuid, name text not null, email text, phone text, created_at timestamptz not null default now()
);
create table if not exists public.activities (
 id uuid primary key default gen_random_uuid(), business_id uuid, lead_id uuid references public.leads(id) on delete cascade, type text not null, details jsonb not null default '{}'::jsonb, created_at timestamptz not null default now()
);
create table if not exists public.automation_rules (
 id uuid primary key default gen_random_uuid(), business_id uuid, name text not null, trigger_type text not null, action_type text not null, config jsonb not null default '{}'::jsonb, enabled boolean not null default true, created_at timestamptz not null default now()
);
