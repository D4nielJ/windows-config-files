function installPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$script,
        [Parameter(Mandatory = $true)]
        [string]$packageName
    )
    Write-Host "Installing $packageName..." -ForegroundColor Green

    Invoke-Expression $script
}

# Set execution policy to bypass (for this process only)
Set-ExecutionPolicy Bypass -Scope Process -Force

# Install git:
$gitScript = "winget install -e --id Git.Git"
installPackage -script $gitScript -packageName "Git"

# Refresh PATH so git is recognized in the same session
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")

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
scoop bucket add extras

# Scoop Packages: extras/vcredist2022, curl, jq, neovim, winfetch, fzf
$scoopPackages = @("vcredist2022", "curl", "jq", "neovim", "winfetch, starship", "fzf")
foreach ($package in $scoopPackages) {
    $scoopInstallPackage = "scoop install $package"
    installPackage -script $scoopInstallPackage -packageName $package
}

scoop uninstall vcredist2022

# Powershell modules
$powershellModules = @("posh-sshell", "Terminal-Icons", "z", "PSFzf", "PSReadLine", "posh-git")
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
