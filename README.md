# GameQuest (Supabase Edition)

GameQuest is a neon-themed Flutter app that gamifies university e-waste recycling. Students log items, admins approve them, and everyone competes on a live leaderboard powered by Supabase (Auth, Database, Storage, Edge Functions) with Firebase Hosting serving the Flutter web build.

## Core Features
- **Supabase Auth** with email/password and Google OAuth
- **Postgres schema** for users, drop-offs, and challenges (`supabase_schema.sql`)
- **Edge Function (`update_badges`)** to award points, badges, and secret rewards automatically
- **Supabase Storage** for profile photos and drop-off proof images
- **Realtime UI** via Supabase streams for user/challenge/leaderboard data
- Slick dark UI, neon buttons, Lottie animations, and a static campus drop-off map

## Getting Started

### 1. Clone & Install
```sh
flutter pub get
```

### 2. Supabase Setup
1. Create a new Supabase project (free tier).
2. Run the SQL in [`supabase_schema.sql`](./supabase_schema.sql) inside the Supabase SQL editor to create tables/views.
3. In Supabase Storage, create a **public** bucket named `uploads`.
4. Deploy the edge function located at `supabase/functions/update_badges`:
   ```sh
   supabase functions deploy update_badges --project-ref <your-project-ref>
   ```
   Grant the function access to the database by setting `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` environment variables (via `supabase secrets set`).
5. Copy your project URL and anon key from `Project Settings → API` and create a `.env` file (see next section).

### 3. Environment Variables
Create a `.env` file in the project root:
```
SUPABASE_URL=https://<project-id>.supabase.co
SUPABASE_ANON_KEY=<anon-key>
```

The app loads these keys with `flutter_dotenv` before initializing Supabase.

### 4. Run the App (Mobile/Desktop)
```sh
flutter run
```

### 5. Build for Web & Deploy to Firebase Hosting
```sh
flutter build web
firebase login
firebase use gamequest-m
firebase deploy --only hosting
```

> Firebase is now used **only** for hosting; all backend features are handled by Supabase.

### 6. Production Verification
- Auth: email/password & Google login verified against Supabase.
- Roles: `is_admin` flag auto-routes admins and protects `/admin`.
- Drop-Off flow: students submit items with optional photo; admin confirmation triggers `update_badges` edge function and updates points/badges.
- Leaderboard, challenges, profile, history, and map screens render correctly with Supabase streams.
- Storage: uploads bucket tested for profile + drop-off images.
- Flutter web build deployed to Firebase Hosting (`build/web`).

**Live URL:** https://gamequest-m.web.app

## Project Structure
- `lib/`
  - `services/` – Supabase auth/database/storage helpers
  - `screens/` – Flutter UI for students/admins
  - `models/` – Data classes aligned with the Supabase schema
  - `widgets/` – Reusable neon UI components
- `supabase/functions/` – Deno edge functions (deploy with `supabase functions deploy`)
- `supabase_schema.sql` – Authoritative database schema
- `.github/` – AI assistant guidance for this Supabase-based stack

## Supabase Edge Function (Points & Badges)
`supabase/functions/update_badges/index.ts` mirrors the previous Firebase Cloud Function. It increments points, unlocks tiered badges (`Recycler Lv1/2/3`), and marks the top scorer’s secret reward when a drop-off is confirmed. The Flutter admin panel triggers it via `SupabaseService.confirmDropOff`.

## Additional Notes
- Update `.env` values with your Supabase project keys before building.
- Replace placeholder badge/secret reward icons under `assets/icons/` as needed.
- For CI/CD, run `flutter pub get`, `dart format .`, and `flutter build web` before deploying.

Enjoy a Firebase-free GameQuest powered by Supabase and free-tier hosting! 🚀
