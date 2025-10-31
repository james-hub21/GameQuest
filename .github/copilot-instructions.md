# Copilot Instructions for GameQuest (Flutter + Supabase)

## Project Overview
- **GameQuest** is a Flutter app for university e-waste recycling, powered by Supabase (Auth, Postgres, Storage, Edge Functions).
- Roles: **Student** logs e-waste, earns points/badges, views leaderboard; **Admin** confirms drop-offs, manages challenges, and monitors progress.
- Styling: neon cyberpunk theme, dark backgrounds, glowing UI components, animated transitions.

## Key Patterns & Conventions
- **State Management:** `provider` for auth/session (`AuthService`) and data access (`SupabaseService`).
- **Supabase Integration:**
  - Auth: email/password + Google via `supabase_flutter`.
  - Database: `supabase.from(...).stream` for users, drop-offs, challenges, leaderboard view.
  - Storage: `SupabaseService.pickAndUpload` for drop-off photos & profile pictures.
  - Edge Function: `update_badges` keeps points/badges in sync when admins confirm drop-offs.
- **UI Layout:**
  - `lib/screens/` – login, dashboard, add item, history, admin, leaderboard, profile.
  - `lib/widgets/` – reusable neon components (`NeonButton`, badge icons, animations).
  - `lib/services/` – Supabase service layer (auth, storage, DB helpers).
  - `lib/models/` – `AppUser`, `DropOff`, `Challenge` matching `supabase_schema.sql`.
- **Assets:** icons & badges under `assets/icons/`, images under `assets/images/`, fonts via `google_fonts`.
- **Map:** static campus map image (no live geolocation).
- **Animations:** `lottie`, `animated_text_kit`, and Flutter animations for gamified feel.

## Developer Workflow
- Install deps: `flutter pub get`
- Run locally: `flutter run`
- Format: `dart format .`
- Build web: `flutter build web`
- Supabase schema: execute `supabase_schema.sql`
- Edge Function deploy: `supabase functions deploy update_badges`
- Firebase Hosting (web only): `firebase deploy --only hosting`
- Real-time updates rely on Supabase channel streaming – do not reintroduce Firestore.

## Supabase Schema Cheat Sheet
- `users`: id, email, display_name, is_admin, points, badges[], secret_reward, profile_pic, reward_claimed_at
- `drop_offs`: id, user_id, item_name, status, points_earned, verified_location, confirmed_by, confirmed_at, photo_url
- `challenges`: id, title, description, type, points, is_active, completed_by[]
- `leaderboard` view: id, display_name, points (ordered desc)

## Examples
- Student dashboard patterns: `lib/screens/dashboard_screen.dart`
- Admin approval flow & photo preview: `lib/screens/admin_screen.dart`
- Storage helpers: `lib/services/supabase_service.dart`
- Edge function source: `supabase/functions/update_badges/index.ts`

## Tips
- Always load Supabase with `.env` (see `main.dart`).
- Use `SupabaseService.confirmDropOff` to ensure points/badges stay consistent.
- Prefer streaming queries (`.stream`) for live UI updates.
- Keep neon aesthetic: bright accent colors on dark surfaces, generous drop shadows.

---
Update this file if Supabase workflows or architectural decisions evolve.
