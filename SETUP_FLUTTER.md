# Flutter Setup Guide for Windows

## Quick Setup (Recommended)

### Option 1: Using Flutter Installer (Easiest)

1. **Download Flutter SDK:**
   - Go to: https://docs.flutter.dev/get-started/install/windows
   - Download the Flutter SDK zip file
   - Extract it to `C:\flutter` (or any location you prefer)

2. **Add Flutter to PATH:**
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\flutter\bin`
   - Click "OK" on all dialogs
   - **Restart PowerShell/Command Prompt**

3. **Verify Installation:**
   ```powershell
   flutter doctor
   ```

### Option 2: Using Chocolatey (Package Manager)

If you have Chocolatey installed:
```powershell
choco install flutter
```

### Option 3: Using Git (For Updates)

```powershell
cd C:\
git clone https://github.com/flutter/flutter.git -b stable
```

Then add `C:\flutter\bin` to PATH (see Option 1, Step 2)

## After Installation

1. **Accept Android Licenses** (if developing for Android):
   ```powershell
   flutter doctor --android-licenses
   ```

2. **Verify Flutter:**
   ```powershell
   flutter doctor -v
   ```

3. **Navigate to your project:**
   ```powershell
   cd "C:\Users\Students Account\Downloads\Mobile-v0.1\GameQuest"
   ```

4. **Get dependencies:**
   ```powershell
   flutter pub get
   ```

5. **Run the app:**
   ```powershell
   flutter run -d chrome
   ```

## Troubleshooting

- **Flutter not found after installation:** Restart your terminal/PowerShell
- **Android licenses:** Run `flutter doctor --android-licenses` and accept all
- **VS Code:** Install Flutter and Dart extensions for better development experience

