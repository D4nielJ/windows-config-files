# Check if running as admin 
# FIX: This will be here for a while, might decided to supress later.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit
}

# Set execution policy to bypass (for this process only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey
Write-Host "Installing Chocolatey..." -ForegroundColor Green
# Suppress standard output, but keep error messages visible
$chocoScript = "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
Invoke-Expression $chocoScript > $null

# Confirm Chocolatey installation
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
}
else {
    Write-Host "Failed to install Chocolatey." -ForegroundColor Red
    exit
}

# Install scoop
Write-Host "Installing Scoop..." -ForegroundColor Green
$scoopScript = "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
Invoke-Expression $scoopScript > $null

# Confirm Scoop installation
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop installed successfully!" -ForegroundColor Green
}
else {
    Write-Host "Failed to install Scoop." -ForegroundColor Red
    exit
}