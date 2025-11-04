# Flutter Setup Script for Windows
# This script helps you install and configure Flutter

Write-Host "🚀 Flutter Setup Script" -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already installed
$flutterPath = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if ($flutterPath) {
    Write-Host "✅ Flutter is already installed at: $flutterPath" -ForegroundColor Green
    flutter doctor
    exit 0
}

Write-Host "❌ Flutter is not installed." -ForegroundColor Red
Write-Host ""
Write-Host "Please choose an installation method:" -ForegroundColor Yellow
Write-Host "1. Download Flutter SDK manually (Recommended)"
Write-Host "2. Install via Chocolatey (if you have it)"
Write-Host "3. Clone from Git"
Write-Host ""
Write-Host "Manual Installation Steps:" -ForegroundColor Cyan
Write-Host "1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows"
Write-Host "2. Extract to C:\flutter (or your preferred location)"
Write-Host "3. Add C:\flutter\bin to your PATH environment variable"
Write-Host "4. Restart PowerShell and run this script again"
Write-Host ""
Write-Host "To add to PATH:" -ForegroundColor Yellow
Write-Host "   - Press Win + X > System > Advanced system settings"
Write-Host "   - Click Environment Variables"
Write-Host "   - Under User variables, edit Path"
Write-Host "   - Add: C:\flutter\bin"
Write-Host "   - Restart PowerShell"
Write-Host ""

# Check if Chocolatey is available
$chocoPath = (Get-Command choco -ErrorAction SilentlyContinue).Source
if ($chocoPath) {
    Write-Host "Chocolatey detected. Would you like to install Flutter via Chocolatey? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -eq 'Y' -or $response -eq 'y') {
        Write-Host "Installing Flutter via Chocolatey..." -ForegroundColor Cyan
        choco install flutter -y
        Write-Host "Please restart PowerShell after installation completes." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "After installation, run 'flutter doctor' to verify setup." -ForegroundColor Green

