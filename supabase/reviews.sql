-- Frozican Emulator Hub reviews
-- Run this file in Supabase SQL Editor.
create table if not exists public.review_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  display_name text not null check (char_length(display_name) between 1 and 50),
  rating int not null check (rating between 1 and 5),
  title text not null check (char_length(title) between 1 and 100),
  body text not null check (char_length(body) between 10 and 2000),
  created_at timestamptz not null default now(),
  status text not null default 'pending' check (status in ('pending','approved','rejected'))
);

alter table public.review_admins enable row level security;
alter table public.reviews enable row level security;

create or replace function public.is_review_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.review_admins a where a.user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_review_admin() from public;
grant execute on function public.is_review_admin() to anon, authenticated;

-- Anyone can submit a review, but cannot choose its status or read submitted reviews.
drop policy if exists "Anyone can submit pending reviews" on public.reviews;
create policy "Anyone can submit pending reviews"
on public.reviews for insert to anon, authenticated
with check (status = 'pending');

-- Only allowlisted admin accounts can read and moderate.
drop policy if exists "Admins can read all reviews" on public.reviews;
create policy "Admins can read all reviews"
on public.reviews for select to authenticated
using (public.is_review_admin());

drop policy if exists "Admins can update reviews" on public.reviews;
create policy "Admins can update reviews"
on public.reviews for update to authenticated
using (public.is_review_admin())
with check (public.is_review_admin());

drop policy if exists "Admins can delete reviews" on public.reviews;
create policy "Admins can delete reviews"
on public.reviews for delete to authenticated
using (public.is_review_admin());

-- The allowlist itself is not readable/writable from the browser.
-- Add your own user after creating an account in Supabase Auth:
-- insert into public.review_admins (user_id) values ('YOUR-AUTH-USER-UUID');
