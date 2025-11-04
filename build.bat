@echo off
REM Build and Deploy Script for GameQuest (Windows)

echo 🚀 Building GameQuest for web...

REM Clean previous build
echo 🧹 Cleaning previous build...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Build for web
echo 🔨 Building web app...
flutter build web --release

REM Check if build was successful
if %ERRORLEVEL% EQU 0 (
    echo ✅ Build successful!
    
    REM Deploy to Firebase
    echo 🚀 Deploying to Firebase Hosting...
    firebase deploy --only hosting
    
    if %ERRORLEVEL% EQU 0 (
        echo ✅ Deployment successful!
    ) else (
        echo ❌ Deployment failed!
        exit /b 1
    )
) else (
    echo ❌ Build failed!
    exit /b 1
)

