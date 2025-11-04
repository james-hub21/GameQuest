# Manual Flutter Installation Guide

## Quick Fix - Manual Download and Extract

Since the automated download is having issues, here's the manual way:

### Step 1: Download Flutter SDK

1. **Go to:** https://docs.flutter.dev/get-started/install/windows
2. **Click:** "Download Flutter SDK" button
3. **Save the zip file** to your Downloads folder (or anywhere you prefer)

### Step 2: Extract Flutter

1. **Right-click** on the downloaded `flutter_windows_*.zip` file
2. **Select:** "Extract All..."
3. **Extract to:** `C:\` (so it creates `C:\flutter\`)
4. **Wait for extraction** to complete (this may take a few minutes)

### Step 3: Add to PATH

1. Press `Win + X` → Select **System**
2. Click **Advanced system settings**
3. Click **Environment Variables**
4. Under **User variables**, find **Path** and click **Edit**
5. Click **New** and add: `C:\flutter\bin`
6. Click **OK** on all dialogs

### Step 4: Verify Installation

1. **Close and reopen PowerShell** (important!)
2. Navigate to your project:
   ```powershell
   cd "C:\Users\Students Account\Downloads\Mobile-v0.1\GameQuest"
   ```
3. Run:
   ```powershell
   flutter doctor
   ```
4. If it works, continue with:
   ```powershell
   flutter pub get
   flutter run -d chrome
   ```

## Alternative: Use Chocolatey (If Installed)

If you have Chocolatey installed:
```powershell
choco install flutter
```

## Troubleshooting

- **"flutter: command not found"** → Restart PowerShell after adding to PATH
- **Extraction errors** → Make sure you have enough disk space (need ~2GB)
- **Permission errors** → Run PowerShell as Administrator

