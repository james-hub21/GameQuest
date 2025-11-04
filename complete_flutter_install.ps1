# Complete Flutter Installation Script
# Run this after the download script finishes

Write-Host "Completing Flutter Installation..." -ForegroundColor Cyan
Write-Host ""

# Check if Flutter is already installed
if (Test-Path "C:\flutter\bin\flutter.bat") {
    Write-Host "Flutter is already installed!" -ForegroundColor Green
    Write-Host ""
    
    # Add to PATH if not already there
    $flutterBinPath = "C:\flutter\bin"
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    
    if ($currentPath -notlike "*$flutterBinPath*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "User")
        Write-Host "Added Flutter to PATH" -ForegroundColor Green
    } else {
        Write-Host "Flutter already in PATH" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "IMPORTANT: Please restart PowerShell for PATH changes to take effect" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After restarting, run:" -ForegroundColor Cyan
    Write-Host "   flutter doctor" -ForegroundColor White
    exit 0
}

# Check if zip file exists
if (Test-Path "$env:TEMP\flutter.zip") {
    Write-Host "Found downloaded Flutter SDK" -ForegroundColor Cyan
    Write-Host "Extracting Flutter SDK..." -ForegroundColor Cyan
    
    try {
        # Wait a moment to ensure file is not locked
        Start-Sleep -Seconds 3
        
        # Extract
        Expand-Archive -Path "$env:TEMP\flutter.zip" -DestinationPath "C:\" -Force
        Write-Host "Extraction complete!" -ForegroundColor Green
        
        # Clean up
        Remove-Item -Path "$env:TEMP\flutter.zip" -Force -ErrorAction SilentlyContinue
        
        # Add to PATH
        $flutterBinPath = "C:\flutter\bin"
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        
        if ($currentPath -notlike "*$flutterBinPath*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$flutterBinPath", "User")
            Write-Host "Added Flutter to PATH" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "Flutter installation complete!" -ForegroundColor Green
        Write-Host ""
        Write-Host "IMPORTANT: Please restart PowerShell for PATH changes to take effect" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "After restarting, run:" -ForegroundColor Cyan
        Write-Host "   flutter doctor" -ForegroundColor White
        Write-Host "   flutter pub get" -ForegroundColor White
        Write-Host "   flutter run -d chrome" -ForegroundColor White
        
    } catch {
        Write-Host "Error: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "The zip file might still be locked by another process." -ForegroundColor Yellow
        Write-Host "Please wait for the download script to finish, then run this script again." -ForegroundColor Yellow
    }
} else {
    Write-Host "Flutter SDK zip file not found" -ForegroundColor Red
    Write-Host "Please run the install_flutter.ps1 script first." -ForegroundColor Yellow
}
