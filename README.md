# DTERMIN4L

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=flat&logo=powershell&logoColor=white)

A powerful Windows terminal configuration script that automates the setup of your development environment. This is a highly opinionated script that will install all the tools I use on a daily basis during development on windows. You can customize it to your liking by editing the script or take it as a starting point to build your own.

## Prerequisites

- Windows 10/11
- PowerShell 7+ (Windows PowerShell 5.1 is not supported)
- Internet connection

## Installation

```powershell
# Install latest powershell update
winget install --id Microsoft.PowerShell --source winget
```

```powershell
# Re-open powershell and run the script.
$scriptUrl = "https://raw.githubusercontent.com/D4nielJ/windows-config-files/refs/heads/main/.dotfiles/dtermin4l.ps1"
iex (irm $scriptUrl)

# Reset the terminal once more and run
Sync-TerminalSettings
```

> ⚠️ **Note**: Make sure to backup your existing terminal settings.json as it will be replaced by the settings from /.config/terminal/settings.json

## 🛠️ Post-Installation Usage

### Dotfiles Management

After installation, you can manage your dotfiles using the `dt` alias (shorthand for `dotfiles`):

```powershell
dt status              # Check status of your dotfiles
dt add route/to/file   # Add files you want to track
dt commit -m "message" # Commit changes
dt push               # Push changes to remote
dt pull               # Pull latest changes
```

> ⚠️ **Warning**: Never use `dt add .` in your home directory! Since this is a bare repository, it will try to track all files in your home directory. Instead, explicitly add the files you want to track: `dt add ~/.config/specific-file`

### Useful Aliases & Functions

#### Git Shortcuts

- `g` - Alias for `git`
- `gam "message"` - Add all changes and commit with message
- `gpob` - Pull from origin of current branch
- `gpub` - Push to origin and set upstream for current branch
- `lg` - Pretty git log with graph
- `stat` - Git status
- `branch` - Git branch management
- `gbd` - Delete git branch

#### Navigation

- `pr` - Navigate to ~/projects
- `docs` - Navigate to ~/Documents
- `cfg` - Navigate to ~/.config
- `~` - Navigate to home directory
- `..` - Go up one directory
- `...` - Go up two directories
- `take dirname` - Create and enter directory

#### Terminal Management

- `admin` - Open new terminal with admin privileges
- `. rld` - Reload PowerShell profile
- `psconfig` - Edit PowerShell configuration
- `Sync-TerminalSettings` - Sync the terminal settings.json from /config/terminal/settings.json to the local Windows Terminal settings.json

#### Development Tools

- `vim` - Opens Neovim
- `code` - Opens Cursor (VS Code alternative)
- `pn` - Alias for pnpm
- `dn` - Alias for deno
- `prettier-init` - Initialize .prettierrc in current directory
- `Stop-Port 3000` - Kill process using specified port

### 🔗 Installed Tools Reference

#### Package Managers

- [Scoop](https://scoop.sh/) - Command-line installer
- [pnpm](https://pnpm.io/) - Fast, disk space efficient package manager

#### Terminal Tools

- [Starship](https://starship.rs/) - Cross-shell prompt
- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [Windows Terminal](https://github.com/microsoft/terminal) - Modern terminal for Windows
- [PSReadLine](https://github.com/PowerShell/PSReadLine) - Command line editing in PowerShell
- [Terminal-Icons](https://github.com/devblackops/Terminal-Icons) - File and folder icons
- [PSFzf](https://github.com/kelleyma49/PSFzf) - Fuzzy finder integration

#### Git Tools

- [Git for Windows](https://gitforwindows.org/)
- [posh-git](https://github.com/dahlbyk/posh-git) - Git integration for PowerShell
- [tig](https://github.com/jonas/tig) - Text-mode interface for Git

#### Additional Utilities

- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- [z](https://github.com/rupa/z) - Directory jumper
- [curl](https://curl.se/) - Command line tool for transferring data
- [jq](https://stedolan.github.io/jq/) - Command-line JSON processor
- [winfetch](https://github.com/lptstr/winfetch) - System information tool

#### License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
