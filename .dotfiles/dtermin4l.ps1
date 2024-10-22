# Check if running as admin 
# FIX: This will be here for a while, might decided to supress later.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an administrator." -ForegroundColor Red
    exit
}

$IS_LOGS = $true
$logFile = "$HOME\dtermin4l-logs.txt"
New-Item -Path $logFile -ItemType File -Force

function installPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$script,
        [Parameter(Mandatory = $true)]
        [string]$packageName
    )
    Write-Host "Installing $packageName..." -ForegroundColor Green
    if ($IS_LOGS) {
        Invoke-Expression $script | Out-File -FilePath $logFile -Append
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

# Install git:
winget install -e --id Git.Git

# Add .gitconfig customization
@"

[user]
    email = d4niel.djm@gmail.com
    name = Daniel J
[init]
    defaultBranch = main
[alias]
    lg1 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all
    lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'
    lg = lg1
"@ | Add-Content -Path $HOME\.gitconfig

# Scoop
$scoopScript = "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
installPackage -script $scoopScript -packageName "Scoop"
confirmCommandInstallation -command "scoop" -packageName "Scoop"
scoop bucket add extras

# Scoop Packages: extras/vcredist2022, curl, jq, neovim, winfetch
$packages = @("vcredist2022", "curl", "jq", "neovim", "winfetch, starship")
foreach ($package in $packages) {
    $scoopInstallPackage = "scoop install $package"
    installPackage -script $scoopInstallPackage -packageName $package
    confirmCommandInstallation -command $package -packageName $package
}

scoop uninstall vcredist2022
