# Deployment Guide for GameQuest

## Prerequisites

1. Install Flutter SDK (3.3.0 or higher)
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Login to Firebase: `firebase login`
4. Install dependencies: `flutter pub get`

## Build for Web

1. Build the Flutter web app:
   ```bash
   flutter build web --release
   ```

2. The build output will be in `build/web/`

## Deploy to Firebase Hosting

### Initial Setup

1. Initialize Firebase (if not already done):
   ```bash
   firebase init hosting
   ```
   - Select your Firebase project
   - Set public directory to `build/web`
   - Configure as single-page app: Yes
   - Set up automatic builds: No

2. Deploy to Firebase:
   ```bash
   firebase deploy --only hosting
   ```

### Continuous Deployment

For automated deployments, you can use:
```bash
flutter build web --release && firebase deploy --only hosting
```

## Environment Variables

Make sure to set up your Supabase credentials:
- Create a `.env` file in the root directory with:
  ```
  SUPABASE_URL=your_supabase_url
  SUPABASE_ANON_KEY=your_supabase_anon_key
  ```

Or use the fallback values in `main.dart` for development.

## OAuth Configuration

For Google OAuth to work on web:

1. Configure redirect URLs in Supabase Dashboard:
   - Go to Authentication > URL Configuration
   - Add your Firebase Hosting URL to Redirect URLs
   - Format: `https://your-project.web.app/auth/callback`

2. Configure Google OAuth Provider:
   - Go to Authentication > Providers > Google
   - Enable Google provider
   - Add your OAuth client credentials

## Testing After Deployment

1. Visit your Firebase Hosting URL
2. Test user registration/login
3. Test Google OAuth sign-in
4. Test test user authentication
5. Verify all dashboard features work correctly
6. Test admin panel functionality

## Troubleshooting

- **OAuth redirect issues**: Ensure redirect URLs are correctly configured in Supabase
- **Build errors**: Run `flutter clean` then `flutter pub get` before building
- **Deployment errors**: Check Firebase project permissions and ensure you're logged in

