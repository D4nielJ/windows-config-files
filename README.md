# How to set up Windows Terminal

#### Install Powershell from Microsoft Store

#### !alpha dtermin4l script

```powershell
irm https://raw.githubusercontent.com/D4nielJ/windows-config-files/refs/heads/main/.dotfiles/dtermin4l.ps1 | iex
```

#### Install and set up: SpaceMono Nerd Font: https://www.nerdfonts.com/font-downloads

#### Add Dracula Theme to terminal `settings.json` file:

```json
{
  "name": "Dracula",
  "cursorColor": "#F8F8F2",
  "selectionBackground": "#44475A",
  "background": "#282A36",
  "foreground": "#F8F8F2",
  "black": "#21222C",
  "blue": "#BD93F9",
  "cyan": "#8BE9FD",
  "green": "#50FA7B",
  "purple": "#FF79C6",
  "red": "#FF5555",
  "white": "#F8F8F2",
  "yellow": "#F1FA8C",
  "brightBlack": "#6272A4",
  "brightBlue": "#D6ACFF",
  "brightCyan": "#A4FFFF",
  "brightGreen": "#69FF94",
  "brightPurple": "#FF92DF",
  "brightRed": "#FF6E6E",
  "brightWhite": "#FFFFFF",
  "brightYellow": "#FFFFA5"
}
```

#### Chocolatey from: https://chocolatey.org/install

#### Scoop from: https://scoop.sh/

#### jq, curl, neovim, winfetch:

```
scoop install curl jq neovim winfetch
```

#### Git for Windows:

```
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
```

#### Install modules posh-sshell, terminal-icons, z, PSFzf, PSReadLine, posh-git

```
Install-Module posh-sshell -Scope CurrentUser -Force
Install-Module Terminal-Icons -Scope CurrentUser -Force
Install-Module z -Scope CurrentUser -Force
scoop install fzf
Install-Module PSFzf -Scope CurrentUser -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force
Install-Module posh-git -Scope CurrentUser -Force
```

#### Set up this repository and link config to $PROFILE

```
# Clone repo as bare
git clone --bare https://github.com/D4nielJ/windows-config-files.git $HOME/.dotfiles
Add-Content $PROFILE 'function dotfiles { git --git-dir=$HOME\.dotfiles --work-tree=$HOME @args }'

# Load the updated profile to the current session
. $PROFILE

# Set up Git to ignore untracked files in your home directory
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

# Load powershell config to $PROFILE
Add-Content $PROFILE '. $HOME\.config\powershell\user_profile.ps1'
```

#### Install Node, pnpm or deno or whatever.

You're on your own from this point.
