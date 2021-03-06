# Dotfiles

## Chezmoi

The latest version of my dotfiles are managed with [Chezmoi](https://chezmoi.io).

### TODOs

- [x] Fix Fish shell broken in clean install
- [x] Add Homebrew install script (run-once)

## Usage

```shell
ASK=1 sh -c "$(curl -fsSL https://raw.githubusercontent.com/thingnoy/dotfiles/master/install.sh) -x encrypted -v"
```

First installation will ask for your name so you can customize a bit, and it will skip the encryped files, since you have to retrieve the GPG private key manually later. Removing `ASK=1` will use my names for the machine.

After the first installation you can always change the variables via `ASK=1 chezmoi init` or run `chezmoi edit-config`

To change the data or script, `chezmoi cd`, edit them, then run `chezmoi apply`.

## Manual tasks (One-time per machine)

- macOS
  - Login to App Store before running (If not `mas` will skip installation and open the App Store for you)

## Features

```shell
$ make
help                           Print command list
dotfiles                       Update dotfiles
apply                          Run chezmoi apply
macos                          Run macos script
```

### Installed Applications & Tools

- macOS
  - [Homebrew](https://brew.sh)
  - [Homebrew Cask](https://github.com/Homebrew/homebrew-cask)
  - [Mas](https://github.com/mas-cli/mas)
  - [Chezmoi](https://chezmoi.io)
  - [zsh](https://zsh.org) with [zsh4humans](https://github.com/romkatv/zsh4humans) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme
  - [fish](https://fishshell.com) with [fisher](https://github.com/jorgebucaran/fisher) + [Tide](https://github.com/IlanCosman/tide) theme
  - [asdf](https://asdf-vm.com) with Ruby & Node.js
  - [tmux](https://github.com/tmux/tmux/)
  - [macOS defaults](https://mths.be/macos)
  - etc.
- Linux
  - Dotfiles only

<details>
  <summary><b>Notes</b> (If you have some time to read)</summary>

### Zsh + Fish

After the recent [drama with Zinit](https://github.com/zdharma-continuum/I_WANT_TO_HELP), I decided to give [Fish](https://fishshell.com) a try, it is good but I also want to still maintain my Zsh configuration. I migrated the settings to [zsh4human](https://github.com/romkatv/zsh4humans) which is maintained by the one who made Powerlevel10k. It's 2-3x faster than Zinit as of now.

I'll separate the dotfiles script to install zsh or fish separately to save some space. You can also install both like mine.

### Apple Silicon

Here are the list of issues I've found on running the script on M1 Macbooks (Tested on both Macbook Air & Macbook Pro)

- Setup both versions of Homebrew, then use shell script to point to the correct `brew`

  ```shell
  # Install both versions
  arch -arm64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # .zshrc
  if [ "$(uname -m)" == "arm64" ]; then
    # Use arm64 brew, with fallback to x86 brew
    if [ -f /opt/homebrew/bin/brew ]; then
      export PATH="/usr/local/bin${PATH+:$PATH}";
      eval $(/opt/homebrew/bin/brew shellenv)
    fi
  else
    # Use x86 brew, with fallback to arm64 brew
    if [ -f /usr/local/bin/brew ]; then
      export PATH="/opt/homebrew/bin${PATH+:$PATH}";
      eval $(/usr/local/bin/brew shellenv)
    fi
  fi
  ```

</details>
