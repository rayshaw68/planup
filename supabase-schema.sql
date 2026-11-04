-- 在 Supabase 控制台的 SQL Editor 中执行一次。
-- 每个登录账号只能读取和修改属于自己的那一行数据。

create table if not exists public.planup_state (
  owner uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"plans":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.planup_state enable row level security;

drop policy if exists "owner can read planup state" on public.planup_state;
create policy "owner can read planup state"
on public.planup_state for select
to authenticated
using (auth.uid() = owner);

drop policy if exists "owner can insert planup state" on public.planup_state;
create policy "owner can insert planup state"
on public.planup_state for insert
to authenticated
with check (auth.uid() = owner);

drop policy if exists "owner can update planup state" on public.planup_state;
create policy "owner can update planup state"
on public.planup_state for update
to authenticated
using (auth.uid() = owner)
with check (auth.uid() = owner);

drop policy if exists "owner can delete planup state" on public.planup_state;
create policy "owner can delete planup state"
on public.planup_state for delete
to authenticated
using (auth.uid() = owner);
