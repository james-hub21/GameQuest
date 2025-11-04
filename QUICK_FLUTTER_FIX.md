# Quick Flutter Installation Fix

## Current Status
❌ Flutter is NOT installed yet

## Fastest Solution (5 minutes)

### Step 1: Download Flutter SDK
1. Go to: **https://docs.flutter.dev/get-started/install/windows**
2. Click the **"Download Flutter SDK"** button
3. Save the zip file (it's about 400 MB)

### Step 2: Extract
1. **Right-click** on the downloaded `flutter_windows_*.zip` file
2. Select **"Extract All..."**
3. In the extraction dialog, change the path to: **`C:\`**
4. Click **"Extract"**
5. Wait for extraction to complete (2-3 minutes)

This will create `C:\flutter\` with all the Flutter files.

### Step 3: Add to PATH (Already done, but verify)
1. Press `Win + X` → **System** → **Advanced system settings**
2. Click **Environment Variables**
3. Under **User variables**, find **Path** and click **Edit**
4. Check if `C:\flutter\bin` is in the list
5. If NOT, click **New** and add: `C:\flutter\bin`
6. Click **OK** on all dialogs

### Step 4: Test
1. **Close and reopen PowerShell** (important!)
2. Run:
   ```powershell
   flutter doctor
   ```
3. If it works, you're done! Then run:
   ```powershell
   cd "C:\Users\Students Account\Downloads\Mobile-v0.1\GameQuest"
   flutter pub get
   flutter run -d chrome
   ```

## Alternative: One-Line Install (If you have Chocolatey)

```powershell
choco install flutter -y
```

Then restart PowerShell and run `flutter doctor`.

## Troubleshooting

- **Still says "flutter not found"** → Make sure you restarted PowerShell after adding to PATH
- **Extraction errors** → Make sure you have at least 2GB free disk space
- **Permission errors** → Right-click PowerShell and "Run as Administrator"

