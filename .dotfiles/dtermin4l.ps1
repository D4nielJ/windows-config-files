$GitName = Read-Host -Prompt "Please enter the name you want to use for Git"
$GitEmail = Read-Host -Prompt "Please enter the email you want to use for Git"

function installPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$script,
        [Parameter(Mandatory = $true)]
        [string]$packageName
    )
    Write-Host "Installing $packageName..." -ForegroundColor Green
    
    # Should be:
    try {
        Invoke-Expression $script
        Write-Host "$packageName installed successfully" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install $packageName`: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Set execution policy to bypass (for this process only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install SpaceMono Nerd font
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SpaceMono.zip"

# Define the location to download the zip file
$zipPath = "$env:TEMP\SpaceMono.zip"

# Download the zip file
Invoke-WebRequest -Uri $fontUrl -OutFile $zipPath

# Define the extraction path
$extractPath = "$env:TEMP\SpaceMono"

# Create the extraction directory
New-Item -ItemType Directory -Path $extractPath -Force

# Extract the zip file
Expand-Archive -Path $zipPath -DestinationPath $extractPath

# Install the font
Get-ChildItem -Path "$extractPath\*.ttf" | ForEach-Object {
    $font = $_.FullName
    $fontInstaller = New-Object -ComObject Shell.Application
    $fontInstaller.Namespace('C:\Windows\Fonts').CopyHere($font)
}

# Clean up
Remove-Item -Path $zipPath -Force
Remove-Item -Path $extractPath -Recurse -Force

Write-Host "SpaceMono Nerd Font installed successfully."

# Install git:
$gitScript = "winget install -e --id Git.Git"
installPackage -script $gitScript -packageName "Git"

# Refresh PATH so git is recognized in the same session
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

# Add .gitconfig customization
@"

[user]
    email = $GitEmail
    name = $GitName
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
scoop bucket add extras

# Scoop Packages:
$scoopPackages = @("vcredist2022", "curl", "jq", "neovim", "winfetch", "starship", "fzf", "deno", "pnpm", "nvm", "terminal-icons")
foreach ($package in $scoopPackages) {
    $scoopInstallPackage = "scoop install $package"
    installPackage -script $scoopInstallPackage -packageName $package
}

scoop uninstall vcredist2022

# Set up node:
$nodeScript = "nvm install lts; nvm use lts;"
installPackage -script $nodeScript -packageName "node"

# Powershell modules
$powershellModules = @("posh-sshell", "z", "PSFzf", "PSReadLine", "posh-git")
foreach ($module in $powershellModules) {
    $powershellInstallModule = "Install-Module $module -Scope CurrentUser -Force"
    installPackage -script $powershellInstallModule -packageName $module
}

#Set up bare repository and dotfiles command
git clone --bare https://github.com/D4nielJ/windows-config-files.git $HOME/.dotfiles

# Add dotfiles function to the current session and profile
$dotfilesFunction = @"
function dotfiles { 
    git --git-dir=$HOME\.dotfiles --work-tree=$HOME @args 
}
"@
# Add to current session
Invoke-Expression $dotfilesFunction

# Also append to the profile for future sessions
Add-Content $PROFILE $dotfilesFunction

# Now that the dotfiles function is available, you can run the following commands:
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

# Load powershell config to $PROFILE
Add-Content $PROFILE '. $HOME\.config\powershell\user_profile.ps1'
& $PROFILE
Sync-TerminalSettings
