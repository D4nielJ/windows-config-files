Invoke-Expression (&starship init powershell)
Import-Module posh-sshell
Import-Module Terminal-Icons
Import-Module z

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# Functions as Aliases
function fetch { & git fetch $args }
function clone { & git clone $args }
function pull { & git pull $args }
function push { & git push $args }
function gco { & git checkout $args }
function gcob { & git checkout -b $args }
function stat { & git status $args }
function add { & git add $args }
function gcm { & git commit $args }
function log { & git lg }
function gam { 
    & git add .
    & git commit -m $args 
}

function pn {
    & pnpm $args
}

# Alias
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias idea idea64.exe
Set-Alias sudo admin

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function .. { & cd .. }
function ... { 
    & cd .. 
    & cd .. 
}

function admin {
    Start-Process wt -Verb RunAs
}

function psconfig {
    code $env:USERPROFILE\.config\powershell\user_profile.ps1
}

function touch {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        # Update the timestamp
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        # Create a new empty file
        New-Item -Path $Path -ItemType File
    }
}

function config {
    git --git-dir=$env:USERPROFILE\.dotfiles --work-tree=$env:USERPROFILE @args
}

# Random. DON'T READ.
function genshin {
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gist.github.com/MadeBaruna/1d75c1d37d19eca71591ec8a31178235/raw/getlink.ps1'))} global"
}

function zzz {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://zzz.rng.moe/scripts/get_signal_link_os.ps1")
}

#Import Posh-Git after aliases so it recognize them
Import-Module posh-git

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

echo "You beautiful bean, PS is ready for your magic."
