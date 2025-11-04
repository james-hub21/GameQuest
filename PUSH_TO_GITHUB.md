# How to Push to GitHub

## Authentication Issue

You're currently authenticated as `orent143` but trying to push to `james-hub21/GameQuest`. 

## Solution Options

### Option 1: Use Personal Access Token (Recommended)

1. **Create a Personal Access Token:**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token" → "Generate new token (classic)"
   - Give it a name like "GameQuest Push"
   - Select scopes: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

2. **Push using the token:**
   ```powershell
   git push https://<YOUR_TOKEN>@github.com/james-hub21/GameQuest.git main
   ```
   Replace `<YOUR_TOKEN>` with your actual token.

   Or set it as remote:
   ```powershell
   git remote set-url origin https://<YOUR_TOKEN>@github.com/james-hub21/GameQuest.git
   git push origin main
   ```

### Option 2: Use GitHub CLI

1. **Install GitHub CLI** (if not installed):
   ```powershell
   winget install GitHub.cli
   ```

2. **Authenticate:**
   ```powershell
   gh auth login
   ```
   Follow the prompts to authenticate with `james-hub21` account.

3. **Push:**
   ```powershell
   git push origin main
   ```

### Option 3: Clear Windows Credential Manager

1. **Open Credential Manager:**
   - Press `Win + R`
   - Type: `control /name Microsoft.CredentialManager`
   - Press Enter

2. **Remove GitHub credentials:**
   - Go to "Windows Credentials"
   - Find and remove any `git:https://github.com` entries

3. **Try pushing again:**
   ```powershell
   git push origin main
   ```
   You'll be prompted to authenticate - use your `james-hub21` credentials.

### Option 4: Use SSH (If you have SSH key set up)

1. **Change remote to SSH:**
   ```powershell
   git remote set-url origin git@github.com:james-hub21/GameQuest.git
   ```

2. **Push:**
   ```powershell
   git push origin main
   ```

## Current Status

✅ All changes are committed locally  
✅ Remote is configured correctly  
⏳ Waiting for authentication to push

## Quick Command Reference

After authentication, run:
```powershell
git push origin main
```

