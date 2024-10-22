# Check if running as admin 
# FIX: This will be here for a while, might decided to supress later.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit
}

function confirmCommandInstallation {
    param(
        [Parameter(Mandatory = $true)]
        [string]$command,
        [Parameter(Mandatory = $true)]
        [string]$packageName
    )
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        Write-Host "$packageName installed successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "Failed to install $packageName." -ForegroundColor Red
        exit
    }
}

# Set execution policy to bypass (for this process only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install Chocolatey
Write-Host "Installing Chocolatey..." -ForegroundColor Green
# Suppress standard output, but keep error messages visible
$chocoScript = "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
Invoke-Expression $chocoScript > $null

# Confirm Chocolatey installation
confirmCommandInstallation -command "choco" -packageName "Chocolatey"

#Install starship
Write-Host "Installing starship..." -ForegroundColor Green
$starshipScript = "choco install starship"
Invoke-Expression $starshipScript > $null

# Install scoop
Write-Host "Installing Scoop..." -ForegroundColor Green
$scoopScript = "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
Invoke-Expression $scoopScript > $null

# Confirm Scoop installation
confirmCommandInstallation -command "scoop" -packageName "Scoop"

# Install scoop packages
$packages = @("curl", "jq", "neovim", "winfetch")
foreach ($package in $packages) {
    Write-Host "Installing $package..." -ForegroundColor Green
    $scoopInstallPackage = "scoop install $package"
    Invoke-Expression $scoopInstallPackage > $null

    # Confirm package installation
    confirmCommandInstallation -command $package -packageName $package
}
