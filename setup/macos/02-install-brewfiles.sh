#!/usr/bin/env bash

brew bundle \
	--quiet \
	--no-lock \
	--file=/dev/stdin <<BREWS
tap "candid82/brew"
tap "homebrew/bundle"
tap "homebrew/cask"
tap "homebrew/cask-fonts"
tap "homebrew/core"
tap "homebrew/services"

brew "bash"
brew "colordiff"
brew "coreutils"
brew "curl"
brew "diff-so-fancy"
brew "diffutils"
brew "exa"
brew "findutils"
brew "git"
brew "git-lfs"
brew "gnupg"
brew "grep"
brew "htop"
brew "less"
brew "openssh"
brew "tmux"
brew "unzip"
brew "wget"
brew "zsh"
brew "nvm"
brew "fish"

cask "1password"
cask "daisydisk"
cask "discord"
cask "docker"
cask "font-jetbrains-mono"
cask "font-jetbrains-mono-nerd-font"
cask "obsidian"
cask "slack"
cask "visual-studio-code"
cask "zoom"
cask "google-chrome"
cask "openvpn-connect"
BREWS

echo "🟣 brewfile is installed."
