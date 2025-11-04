# GameQuest - UIC E-Waste Recycling Gamified App

GameQuest is a modern, production-ready Flutter app that gamifies university e-waste recycling. Students log items, admins approve them, and everyone competes on a live leaderboard powered by Supabase (Auth, Database, Storage, Edge Functions) with Firebase Hosting serving the Flutter web build.

## ✨ Latest Improvements

- ✅ **Fixed Google OAuth Authentication** - Proper web redirect handling with callback support
- ✅ **Test User Authentication** - Quick demo login for testing
- ✅ **Comprehensive Error Handling** - User-friendly error messages throughout the app
- ✅ **Notification System** - Beautiful, modern notifications for all important actions
- ✅ **Improved UI/UX** - Clean, modern, responsive design with SafeArea and ConstrainedBox
- ✅ **Dashboard Bug Fixes** - Fixed user and admin dashboard issues
- ✅ **Production-Ready** - Proper error handling, loading states, and user feedback
- ✅ **Firebase Hosting Ready** - Complete deployment configuration with build scripts

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

Optional - Test User Configuration:
```
TEST_USER_EMAIL=your-email@example.com
TEST_USER_PASSWORD=your-password
```

The app loads these keys with `flutter_dotenv` before initializing Supabase.

> **Note:** You can copy `.env.example` to `.env` and fill in your values.

### 4. Run the App (Mobile/Desktop)
```sh
flutter run
```

### 5. Build for Web & Deploy to Firebase Hosting

#### Quick Deploy (Windows)
```sh
build.bat
```

#### Quick Deploy (Linux/Mac)
```sh
chmod +x build.sh
./build.sh
```

#### Manual Deploy
```sh
flutter build web --release
firebase login
firebase use <your-project-id>
firebase deploy --only hosting
```

> Firebase is now used **only** for hosting; all backend features are handled by Supabase.

See `DEPLOY.md` for detailed deployment instructions.

### 6. OAuth Configuration

For Google OAuth to work on web:

1. Configure redirect URLs in Supabase Dashboard:
   - Go to Authentication > URL Configuration
   - Add your Firebase Hosting URL to Redirect URLs
   - Format: `https://your-project.web.app/auth/callback`

2. Configure Google OAuth Provider:
   - Go to Authentication > Providers > Google
   - Enable Google provider
   - Add your OAuth client credentials

### 7. Production Verification

- ✅ **Authentication**: Email/password, Google OAuth, and test user login all working
- ✅ **Error Handling**: Comprehensive error handling with user-friendly notifications
- ✅ **User Notifications**: Beautiful notifications for all important actions
- ✅ **Roles**: `is_admin` flag auto-routes admins and protects `/admin`
- ✅ **Drop-Off Flow**: Students submit items with optional photo; admin confirmation triggers `update_badges` edge function and updates points/badges
- ✅ **Challenges**: Interactive challenge completion with tap-to-complete functionality
- ✅ **Leaderboard**: Real-time leaderboard with badges and secret rewards
- ✅ **Profile**: Profile picture upload with error handling
- ✅ **History**: Submission history with proper status tracking
- ✅ **Storage**: Uploads bucket tested for profile + drop-off images
- ✅ **Responsive Design**: Works on all screen sizes with proper constraints
- ✅ **Flutter Web Build**: Deployed to Firebase Hosting (`build/web`)

**Live URL:** https://gamequest-m.web.app

## Project Structure
- `lib/`
  - `services/`
    - `auth_service.dart` – Authentication with email, Google OAuth, and test user
    - `supabase_service.dart` – Database operations with error handling
    - `notification_service.dart` – User-friendly notification system
  - `screens/` – Flutter UI for students/admins
    - `login_screen.dart` – Enhanced login with test user option
    - `dashboard_screen.dart` – Improved user dashboard with interactive challenges
    - `admin_screen.dart` – Enhanced admin panel with better notifications
    - `auth_callback_screen.dart` – OAuth callback handler for web
  - `models/` – Data classes aligned with the Supabase schema
  - `widgets/` – Reusable neon UI components
- `supabase/functions/` – Deno edge functions (deploy with `supabase functions deploy`)
- `supabase_schema.sql` – Authoritative database schema
- `DEPLOY.md` – Complete deployment guide
- `build.sh` / `build.bat` – Automated build and deploy scripts

## Supabase Edge Function (Points & Badges)
`supabase/functions/update_badges/index.ts` mirrors the previous Firebase Cloud Function. It increments points, unlocks tiered badges (`Recycler Lv1/2/3`), and marks the top scorer’s secret reward when a drop-off is confirmed. The Flutter admin panel triggers it via `SupabaseService.confirmDropOff`.

## Additional Notes
- Update `.env` values with your Supabase project keys before building.
- Replace placeholder badge/secret reward icons under `assets/icons/` as needed.
- For CI/CD, run `flutter pub get`, `dart format .`, and `flutter build web` before deploying.

Enjoy a Firebase-free GameQuest powered by Supabase and free-tier hosting! 🚀
