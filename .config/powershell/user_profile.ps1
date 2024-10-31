# Terminal Settings
$env:TERMINAL_SETTINGS = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

# Import necessary modules (only if they are needed)
$modules = @('posh-sshell', 'Terminal-Icons', 'z', 'PSFzf')

foreach ($module in $modules) {
    try {
        if (Get-Module -ListAvailable -Name $module) {
            Import-Module $module -ErrorAction Stop
        }
    }
    catch {
        Write-Warning "Failed to import module $module : $_"
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
    param([Parameter(Mandatory = $true)][string]$message)
    git add .
    if ($?) {
        git commit -m $message
    }
}
function stash { git stash $args }
function pop { git stash pop $args }
function gpob { git pull origin $(git branch --show-current) }
function gpub { git push origin $(git branch --show-current) }
function rebase { git rebase $args }
function reset { git reset $args }
function branch { git branch $args }
function gbd { git branch -d $args }
function gcp { git cherry-pick $args }

function dlx { 
    & pn dlx $args
}

# Quick directory shortcuts
function pr { Set-Location ~/projects }
function docs { Set-Location ~/Documents }
function dl { Set-Location ~/Downloads }
function cfg { Set-Location ~/.config }
function ~ { Set-Location ~ }

# Alias for commands
Set-Alias vim nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias idea idea64.exe
Set-Alias dt dotfiles
Set-Alias pn pnpm
Set-Alias dn deno
Set-Alias code cursor

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue | 
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function .. { cd ..; }
function ... { cd ..; cd ..; }

function psconfig {
    cursor "$env:USERPROFILE\.config\powershell\user_profile.ps1"
}

function touch {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Paths
    )
    
    process {
        foreach ($Path in $Paths) {
            try {
                if (Test-Path -LiteralPath $Path) {
                    (Get-Item -LiteralPath $Path).LastWriteTime = Get-Date
                }
                else {
                    New-Item -Path $Path -ItemType File -Force
                }
            }
            catch {
                Write-Error "Failed to touch $Path`: $_"
            }
        }
    }
}

function admin {
    Start-Process wt -Verb RunAs
}

function Copy-FileContent {
    param (
        [Parameter(Mandatory = $true)][string]$SourceFile,
        [Parameter(Mandatory = $true)][string]$TargetFile
    )
    
    # Resolve full paths
    $SourceFile = Resolve-Path $SourceFile -ErrorAction SilentlyContinue
    $TargetFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($TargetFile)
    
    if (-not $SourceFile) {
        Write-Error "Source file does not exist!"
        return
    }

    try {
        # Create directory for target file if it doesn't exist
        $targetDir = Split-Path -Parent $TargetFile
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }

        # Copy content
        Get-Content $SourceFile | Set-Content $TargetFile -ErrorAction Stop
        Write-Host "Content copied successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to copy content: $_"
    }
}

function Sync-TerminalSettings {
    Copy-FileContent $HOME\.config\terminal\settings.json $env:TERMINAL_SETTINGS
}

function rld {
    $reloaded = 0
    @($Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost) | ForEach-Object {
        if (Test-Path $_) {
            try {
                . $_
                $reloaded++
                Write-Host "Reloaded: $_" -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to reload $_`: $_"
            }
        }
    }
    Write-Host "Reloaded $reloaded profile(s)" -ForegroundColor Cyan
}
function take {
    param (
        [Parameter(Mandatory = $true)]
        [string]$dirName
    )

    # Check if directory already exists
    if (!(Test-Path -Path $dirName)) {
        # Create the directory
        New-Item -Path $dirName -ItemType Directory | Out-Null
    }

    # Navigate into the directory
    Set-Location -Path $dirName
}

# Usage:
# Kill-Port 3000
# Kill-Port 3000,3001,3002
function Kill-Port {
    param(
        [Parameter(Mandatory = $true)]
        [int[]]$Ports
    )
    
    foreach ($port in $Ports) {
        $process = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($process) {
            Stop-Process -Id $process.OwningProcess -Force
            Write-Host "Killed process using port $port"
        }
        else {
            Write-Host "No process found using port $port"
        }
    }
}

# Random. DON'T READ.
function genshin {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression "&{$((New-Object System.Net.WebClient).DownloadString('https://gist.github.com/MadeBaruna/1d75c1d37d19eca71591ec8a31178235/raw/getlink.ps1'))} global"
}

function zzz {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Invoke-Expression (New-Object Net.WebClient).DownloadString("https://zzz.rng.moe/scripts/get_signal_link_os.ps1")
}

##################################################################################################################

# Import posh-git after aliases or they are not recognized
Import-Module posh-git

# Import the Chocolatey Profile for tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}
# Load Deno completions
& $HOME\.config\deno\deno.ps1

# Invoke Starship
Invoke-Expression (&starship init powershell)

# Final message
Write-Output "~ Okaaaaaaaaay, let's go"
