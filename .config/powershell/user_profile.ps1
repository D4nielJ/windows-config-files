# Import necessary modules (only if they are needed)
$modules = @('posh-sshell', 'Terminal-Icons', 'z', 'PSFzf')

foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module
    }
}

# PSReadLine settings
Set-PSReadLineOption -EditMode Emacs -BellStyle None -PredictionSource History -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar

# Fzf options
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Git alias functions
function fetch { & git fetch $args }
function clone { & git clone $args }
function pull { & git pull $args }
function push { & git push $args }
function add { & git add $args }
function gco { & git checkout $args }
function gcob { & git checkout -b $args }
function stat { & git status $args }
function gcm { & git commit $args }
function log { & git log }
function lg { & git log --pretty=format:"%C(auto)%h %C(yellow)%d %C(reset)%s %C(bold blue)<%an>%C(reset)" --graph }
function gam {
    & git add .; & git commit -m $args
}

# Alias for commands
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias idea idea64.exe
Set-Alias sudo admin
Set-Alias dt dotfiles

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function .. { cd .. }
function ... { cd ..; cd .. }

function admin {
    Start-Process wt -Verb RunAs
}

function psconfig {
    code "$env:USERPROFILE\.config\powershell\user_profile.ps1"
}

function touch {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        # Update the timestamp
        (Get-Item $Path).LastWriteTime = Get-Date
    }
    else {
        # Create a new empty file
        New-Item -Path $Path -ItemType File -ErrorAction SilentlyContinue
    }
}

# Random. DON'T READ.
function genshin {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gist.github.com/MadeBaruna/1d75c1d37d19eca71591ec8a31178235/raw/getlink.ps1'))} global"
}

function zzz {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Invoke-Expression (New-Object Net.WebClient).DownloadString("https://zzz.rng.moe/scripts/get_signal_link_os.ps1")
}

# Import posh-git after aliases or they are not recognized
Import-Module posh-git

# Import the Chocolatey Profile for tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}

# Invoke Starship
Invoke-Expression (&starship init powershell)

# Final message
echo "You beautiful bean, PS is ready for your magic."
