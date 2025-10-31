# Copilot Instructions for GameQuest (Flutter + Firebase)

## Project Overview
- **GameQuest** is a Flutter app for university e-waste recycling, using Firebase (Auth, Firestore, Functions).
- Two roles: **Student** (log e-waste, view dashboard, earn points/badges, see leaderboard, static map) and **Admin** (confirm items, manage points, monitor challenges, update leaderboard).
- Gamified dark UI: neon accents, glowing effects, animations, modern fonts, and static UIC drop-off map.

## Key Patterns & Conventions
- **State Management:** Uses `provider` for app-wide state (auth, user, leaderboard, challenges).
- **Firebase Integration:**
  - Auth: Email/Password & Google
  - Firestore: users, dropOffs, challenges collections
  - Cloud Functions: points assignment, badge logic, leaderboard updates
- **UI Structure:**
  - `lib/screens/`: All main screens (login, dashboard, add item, history, admin, leaderboard, profile)
  - `lib/widgets/`: Reusable UI components (neon buttons, badge icons, cards)
  - `lib/services/`: Firebase and business logic (auth, Firestore, functions)
  - `lib/models/`: Data models (User, DropOff, Challenge, Badge)
- **Assets:**
  - Neon SVG/PNG icons in `assets/icons/`
  - Fonts in `assets/fonts/` (use GoogleFonts for modern look)
  - Placeholder images in `assets/images/`
- **Map:** Static map widget with UIC drop-off marker (no GPS)
- **Animations:** Use `animated_text_kit`, `lottie`, and custom transitions for points/badges

## Developer Workflows
- **Build:** `flutter pub get` then `flutter run`
- **Firebase:** Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to platform folders
- **Cloud Functions:** Place JS/TS code in `/functions`, deploy with `firebase deploy --only functions`
- **Testing:** Use `flutter_test` for unit/widget tests in `test/`
- **Real-time:** Use Firestore streams for live updates (points, badges, leaderboard, challenges)

## Firestore Structure
- `users`: userId, name, email, isAdmin, totalPoints, badges, secretReward, rewardClaimedAt, profilePic
- `dropOffs`: id, userId, itemName, status, confirmedBy, confirmedAt, pointsEarned, verifiedLocation
- `challenges`: id, type, description, points, completedBy

## Security
- See `README.md` for Firestore rules (role-based access)

## Examples
- See `lib/screens/dashboard_screen.dart` for student dashboard patterns
- See `lib/screens/admin_screen.dart` for admin workflows
- See `lib/widgets/neon_button.dart` for custom neon UI

## Tips
- Use provider for all user/session state
- Keep UI dark, neon, and animated
- Use placeholder icons/images for badges/items/secret reward
- Comment code for maintainability

---
Update this file as new conventions or workflows emerge.
