# Check if running as admin 
# FIX: This will be here for a while, might decided to supress later.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit
}

$IS_LOGS = $true

function installPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$script,
        [Parameter(Mandatory = $true)]
        [string]$packageName
    )
    Write-Host "Installing $packageName..." -ForegroundColor Green
    if ($IS_LOGS) {
        Invoke-Expression $script
    }
    else {
        Invoke-Expression $script > $null
    }
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
    }
}

# Set execution policy to bypass (for this process only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Chocolatey
$chocoScript = "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
installPackage -script $chocoScript -packageName "Chocolatey"
confirmCommandInstallation -command "choco" -packageName "Chocolatey"

# Scoop
$scoopScript = "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
installPackage -script $scoopScript -packageName "Scoop"
confirmCommandInstallation -command "scoop" -packageName "Scoop"

# Scoop Packages: curl, jq, neovim, winfetch
$packages = @("curl", "jq", "neovim", "winfetch, starship")
foreach ($package in $packages) {
    $scoopInstallPackage = "scoop install $package"
    installPackage -script $scoopInstallPackage -packageName $package
    confirmCommandInstallation -command $package -packageName $package
}
