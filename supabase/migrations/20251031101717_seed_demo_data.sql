-- Seed data for demo account: jrabang_22000001540@uic.edu.ph
-- This migration populates the user profile, points, badges, a demo challenge, and sample drop-off.

-- First, mirror the auth user into public.users (no-op if already exists)
insert into public.users (id, email, display_name, is_admin)
select id,
       'jrabang_22000001540@uic.edu.ph',
       split_part('jrabang_22000001540@uic.edu.ph','@',1),
       false
from auth.users
where email = 'jrabang_22000001540@uic.edu.ph'
on conflict (id) do nothing;

-- Seed progress data
update public.users
set points = 240,
    badges = array['Recycler Rookie','Eco Hero','Campus Clean Champion'],
    secret_reward = false
where email = 'jrabang_22000001540@uic.edu.ph';

-- Add a demo challenge (only if none exist)
insert into public.challenges (id, title, description, points, type, is_active, created_at)
select uuid_generate_v4(),
       'Bring 5 Batteries',
       'Drop off five used batteries to earn bonus points.',
       120,
       'drop_off',
       true,
       now()
where not exists (select 1 from public.challenges where is_active = true)
limit 1;

-- Add a sample pending drop-off for history/admin views
insert into public.drop_offs (
  id, user_id, item_name, status, created_at, verified_location
)
select uuid_generate_v4(),
       u.id,
       'Old phone charger',
       'pending',
       now(),
       'Main campus lobby'
from public.users u
where u.email = 'jrabang_22000001540@uic.edu.ph'
  and not exists (
    select 1 from public.drop_offs d where d.user_id = u.id and d.status = 'pending'
  );
