# Check if running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit
}

# Set execution policy to bypass (for this process only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey
Write-Host "Installing Chocolatey..." -ForegroundColor Green
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Confirm Chocolatey installation
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to install Chocolatey." -ForegroundColor Red
    exit
}
