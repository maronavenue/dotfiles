# :house: mmontano dotfiles

> ain't no place like `~/`

My evolving configuration for WSL Ubuntu all over the years. Live, stable and currently in-use. Feel free to fork.

![](https://img.shields.io/badge/OS-WSL%202%20(Ubuntu%2022.04)-blue)

<img src="assets/2024-08-27%2002_11_15.nvim.png" width="1500">

## Prologue

Here's a breakdown of things I use day-to-day dev workflow which my entire configuration is tailored for:

|  | Feature | Notes |
|--------|---------------------|-----------|
| Distro | WSL 2 (Ubuntu-22.04) | https://learn.microsoft.com/en-us/windows/wsl/install |
| Unix Shell | ZSH |  https://ohmyz.sh/ |
| Editor| NeoVim | https://neovim.io/ |
| Prompt | Starship | https://starship.rs/ |
| Terminal 1 | Alacritty | https://github.com/alacritty/alacritty |
| Terminal 2 | Wezterm | https://wezfurlong.org/wezterm/ |
| Remote IDE | VSCode | https://code.visualstudio.com/ |

I only ever exclusively use Windows for three things:
1. Launching ~~Alacritty~~ Wezterm (because its battery includes emoji support, very important)
1. Testing localhost with Edge
1. Coding on VS Code with Remote-SSH into WSL-Ubuntu

As such, make sure to treat the list above as prerequisites and install them as needed if you are planning to use this configuration.

## Setup

My dotfiles management is as vanilla as it gets. No abstractions, no symlink, no magic. You just need to have plain ol' Git. And that's it.

> I did not intend to rhyme things, but sure I'll take it.

### TL;DR

- Use a bare repo that points to `$HOME` as its worktree to version control dotfiles directly from a side folder: `$HOME/.dotfiles`
- Create a simple alias or function to interact with the bare repo using standard git commands
- Use git submodules to equally manage plugins, themes, scripts and other dependencies that live in their own separate repos (or forks).
- Keep any other stuff under `$HOME/external` as a general guideline    
    - Files that aren't expected to be in an explicit path in `$HOME` just to keep things organized

### Install

> ⚠️ **Warning:** Back things up first and proceed with caution.  

```bash
# ignore $HOME/.dotfiles
echo ".dotfiles/" >> .gitignore

# ignore untracked files
dotfiles config --local status.showUntrackedFiles no

# clone into bare repo in the side folder
git clone --bare git@github.factset.com:mmontano/dotfiles.git  $HOME/.dotfiles

# define shorthand alias in the current shell scope
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# pull contents from .dotfiles to your $HOME
dotfiles checkout
```

> 💡 **Tip**: You would probably want to fork this repo and clone your own copy instead.

### Usage

To manage and update files:

```bash
cd # $HOME
dotfiles add .vimrc
dotfiles commit -m "chore: add vimrc"
dotfiles push origin main
```

To manage and update projects:

```bash
# git submodules require a proper worktree, so we need to clone it into a separate repo
git clone $HOME/.dotfiles/ /path/to/dotfiles
cd /path/to/dotfiles

# add submodule directly in the expected correct path and start tracking
git submodule add git@github.factset.com:mmontano/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
git commit -m "chore: add submodule kickstart.nvim"

# push to local dotfiles
git push origin main

cd $HOME/.dotfiles

# checkout submodule under $HOME
dotfiles restore --staged . && dotfiles restore .
dotfiles submodule update --init --recursive

# push to remote dotfiles
dotfiles push origin main

# check status
dotfiles status
```

There you have it. You can continue to manage and track them in their own respective repos as you would normally do, while keeping them in sync within the .dotfiles repo using basic Git.

## Philosophies

1. Centralize setup, configuration and binaries in one place. I tend to install everything in Ubuntu whenever I can. For example, I cannot live with having `x` (i.e Docker or Python or Go) on both Windows and Ubuntu.
1. Leave tiny trails of improvement. My terminal is my sanctuary-- crafted over years of experience, battles lost and won. Keeping it clean, fast and beautiful never not pays off.
1. Keep your lines open with, well, a backup default editor. Inevitably we find ourselves working with pseudo-bare metal distros where being comfortable with native and default editors pay dividends ten-fold. I wield VS Code as my primary, but I also actively switch back to NVim as my secondary. I strive to reach a point where I feel good with `nvim .` as much as I do with `code .`.

## Epilogue

I dedicate this section for FDS-specific configurations and gotchas so this only exists in https://github.factset.com/mmontano/dotfiles but not in https://github.com/maronavenue/dotfiles.

### 🚧 WIP 🚧

- wsl-vpnkit
- awslogin
- factset-cli
- lima
- docker
- artifactory overrides for package managers
- wsl setup guide

## FAQs

### How do I manage multiple environments?

Simple. Just create a new branch for each environment. For example:

```bash
dotfiles checkout -b wsl-ubuntu
dotfiles add .bashrc
dotfiles commit -m "chore: add wsl bashrc"
dotfiles push origin wsl

dotfiles checkout -b macos
dotfiles add .bashrc
dotfiles commit -m "chore: add mac bashrc"
dotfiles push origin mac
```

Lean and clean. 👍

### Why are emojis and special characters not rendering in my terminal?

Make sure to install patched fonts and configure your terminal to use them. Check out my personal favorites: `MesloLGS NF` and `Hack NF`. Install manually or via PowerShell, for example:

```powershell
PS C:\WINDOWS\system32> Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip" -OutFile "$env:TEMP\Hack.zip"; Expand-Archive -Path "$env:TEMP\Hack.zip" -DestinationPath "$env:TEMP\Hack"; Copy-Item -Path "$env:TEMP\Hack\*.ttf" -Destination "$env:SystemRoot\Fonts"; Remove-Item -Path "$env:TEMP\Hack.zip"; Remove-Item -Path "$env:TEMP\Hack" -Recurse
```

### How do I sync my Alacritty or Wezterm configuration between Windows and WSL?

Remember that we are still using Alacritty on Windows to launch the Ubuntu terminal. This means it will look for the config at `%APPDATA%\alacritty\alacritty.toml`. But that's fine. Create a symbolic link from your Windows AppData to your WSL home directory. For example:

```powershell
PS C:\WINDOWS\system32> cmd /c mklink C:\Users\username\AppData\Roaming\alacritty\alacritty.yml "\\wsl.localhost\Ubuntu-22.04\home\username\.config\alacritty\alacritty.yml"
symbolic link created for C:\Users\username\AppData\Roaming\alacritty\alacritty.yml <<===>> \\wsl.localhost\Ubuntu-22.04\home\username\.config\alacritty\alacritty.yml

PS C:\WINDOWS\system32> cmd /c mklink C:\Users\username\.wezterm.lua "\\wsl.localhost\Ubuntu-22.04\home\username\.wezterm.lua"
symbolic link created for C:\Users\username\.wezterm.lua <<===>> \\wsl.localhost\Ubuntu-22.04\home\username\.wezterm.lua
```


See reference: https://github.com/alacritty/alacritty?tab=readme-ov-file#configuration
