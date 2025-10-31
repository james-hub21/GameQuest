# GameQuest

GameQuest is a modern, gaming-themed Flutter app for university e-waste recycling, featuring student and admin roles, points, badges, leaderboard, secret rewards, and Firebase backend.

## Features
- Student/Admin login (Email/Google)
- E-waste item logging and admin confirmation
- Points, badges, daily/weekly challenges, secret reward
- Real-time leaderboard and challenge progress
- Dark, neon-accented gaming UI
- Static UIC drop-off map

## Firebase Setup
1. Create a Firebase project.
2. Enable Authentication (Email/Password, Google).
3. Add Firestore and Cloud Functions.
4. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) into respective folders.
5. Update Firestore rules for role-based access (see below).

## Firestore Security Rules
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /dropOffs/{dropOffId} {
      allow create: if request.auth != null && !get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin;
      allow update, delete: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin;
      allow read: if request.auth != null && (get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin || resource.data.userId == request.auth.uid);
    }
    match /challenges/{challengeId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin;
    }
  }
}
```

## Build & Run
```sh
flutter pub get
flutter run
```

## Folder Structure
- `lib/` - Dart source code
- `assets/` - Icons, images, fonts
- `functions/` - Firebase Cloud Functions
- `.github/` - Copilot/AI agent instructions

## Notes
- Replace placeholder icons/images with your own
- See `.github/copilot-instructions.md` for AI agent guidance
