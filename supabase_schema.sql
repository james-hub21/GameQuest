-- USERS TABLE
create table users (
  id uuid primary key default uuid_generate_v4(),
  email text unique not null,
  is_admin boolean default false,
  display_name text,
  points int default 0,
  badges text[] default array[]::text[],
  secret_reward boolean default false,
  profile_pic text,
  reward_claimed_at timestamp,
  created_at timestamp default now()
);

-- DROP_OFFS TABLE
create table drop_offs (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references users(id),
  item_name text,
  status text default 'pending',
  points_earned int default 0,
  verified_location text,
  confirmed_by text,
  confirmed_at timestamp,
  photo_url text,
  created_at timestamp default now()
);

-- CHALLENGES TABLE
create table challenges (
  id uuid primary key default uuid_generate_v4(),
  title text,
  description text,
  points int,
  type text,
  is_active boolean default true,
  completed_by text[] default array[]::text[],
  created_at timestamp default now()
);

-- LEADERBOARD VIEW
create or replace view leaderboard as
select id, display_name, points
from users
order by points desc;

-- EDGE FUNCTION: deploy supabase/functions/update_badges to keep points/badges in sync
