# Quick Start Guide

## If Flutter is NOT Installed

### Option 1: Automated Installation (Recommended)
```powershell
.\install_flutter.ps1
```
This will automatically download and install Flutter for you.

### Option 2: Manual Installation
Run the setup script:
```powershell
.\setup_flutter.ps1
```
Or follow the manual steps in `SETUP_FLUTTER.md`

2. **After Flutter is installed, restart PowerShell and continue below**

## If Flutter IS Installed (or after installation)

1. **Navigate to project:**
   ```powershell
   cd "C:\Users\Students Account\Downloads\Mobile-v0.1\GameQuest"
   ```

2. **Get dependencies:**
   ```powershell
   flutter pub get
   ```

3. **Run the app:**
   ```powershell
   flutter run -d chrome
   ```

## Alternative: Use Web Build Directly

If you just want to build for web without running:

```powershell
flutter build web --release
```

Then open `build\web\index.html` in your browser.

## Troubleshooting

- **"flutter: command not found"** → Flutter is not in PATH. See `SETUP_FLUTTER.md`
- **"No devices found"** → Run `flutter doctor` to check setup
- **Dependencies error** → Run `flutter clean` then `flutter pub get`

