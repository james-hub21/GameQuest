# Automated Flutter Installation Script for Windows
# This script downloads and sets up Flutter automatically

Write-Host "🚀 Automated Flutter Installation" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already installed
$flutterPath = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if ($flutterPath) {
    Write-Host "✅ Flutter is already installed at: $flutterPath" -ForegroundColor Green
    Write-Host "Running flutter doctor..." -ForegroundColor Yellow
    flutter doctor
    exit 0
}

$flutterInstallPath = "C:\flutter"
$downloadUrl = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.0-stable.zip"
$zipPath = "$env:TEMP\flutter.zip"

Write-Host "This script will:" -ForegroundColor Yellow
Write-Host "1. Download Flutter SDK to $flutterInstallPath"
Write-Host "2. Extract it"
Write-Host "3. Add it to PATH (requires admin privileges)"
Write-Host ""
Write-Host "Continue? (Y/N)" -ForegroundColor Cyan
$response = Read-Host

if ($response -ne 'Y' -and $response -ne 'y') {
    Write-Host "Installation cancelled." -ForegroundColor Red
    exit 0
}

# Check if Flutter directory already exists
if (Test-Path $flutterInstallPath) {
    Write-Host "⚠️  Flutter directory already exists at $flutterInstallPath" -ForegroundColor Yellow
    Write-Host "Do you want to remove it and reinstall? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -eq 'Y' -or $response -eq 'y') {
        Remove-Item -Path $flutterInstallPath -Recurse -Force
    } else {
        Write-Host "Installation cancelled." -ForegroundColor Red
        exit 0
    }
}

# Create directory
Write-Host "📁 Creating directory..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $flutterInstallPath -Force | Out-Null

# Download Flutter
Write-Host "📥 Downloading Flutter SDK (this may take a few minutes)..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
    Write-Host "✅ Download complete" -ForegroundColor Green
} catch {
    Write-Host "❌ Download failed: $_" -ForegroundColor Red
    Write-Host "Please download manually from: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Yellow
    exit 1
}

# Extract Flutter
Write-Host "📦 Extracting Flutter SDK..." -ForegroundColor Cyan
try {
    Expand-Archive -Path $zipPath -DestinationPath "C:\" -Force
    Write-Host "✅ Extraction complete" -ForegroundColor Green
} catch {
    Write-Host "❌ Extraction failed: $_" -ForegroundColor Red
    exit 1
}

# Clean up zip file
Remove-Item -Path $zipPath -Force

# Add to PATH
Write-Host "🔧 Adding Flutter to PATH..." -ForegroundColor Cyan
$flutterBinPath = "$flutterInstallPath\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$flutterBinPath*") {
    try {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "User")
        Write-Host "✅ Added to PATH" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Could not add to PATH automatically (requires admin)" -ForegroundColor Yellow
        Write-Host "Please add $flutterBinPath to your PATH manually:" -ForegroundColor Yellow
        Write-Host "   Win + X > System > Advanced system settings > Environment Variables"
        Write-Host "   Add to User PATH: $flutterBinPath"
    }
} else {
    Write-Host "✅ Flutter already in PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Flutter installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  IMPORTANT: Please restart PowerShell for PATH changes to take effect" -ForegroundColor Yellow
Write-Host ""
Write-Host "After restarting, run:" -ForegroundColor Cyan
Write-Host "   flutter doctor" -ForegroundColor White
Write-Host "   flutter pub get" -ForegroundColor White
Write-Host "   flutter run -d chrome" -ForegroundColor White

