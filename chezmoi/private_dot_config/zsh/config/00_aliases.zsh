# Editing
alias aliases='$EDITOR ~/.config/zsh/config/00_aliases.zsh ; reload ; echo "Aliases reloaded"'
alias funcs='$EDITOR ~/.config/zsh/config/20_functions.zsh ; reload ; echo "Aliases reloaded"'
alias zshrc='$EDITOR ~/.zshrc ; reload'

# Replace default commands
alias cat='bat'
alias df='dust -df'
alias du='dust'
alias find='fd'
alias grep='rg'
alias l='exa -lahF --git'
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'
alias ll='exa -labF --git'
alias ls='exa'
alias lt='exa -lahbF --git --sort=modified --octal-permissions --time-style=long-iso'
alias ping='prettyping --nolegend'
alias top='htop'
alias tree='exa --tree'
alias vi='nvim'
alias vim='nvim'

# Git stuff
alias gaa="git add --all"
alias gb="git branch"
alias gba="git branch -a"
alias gcd="git checkout develop"
alias gcm="git checkout main"
alias gcmsg="git commit -m"
alias gco="git checkout"
alias gd='git diff'
alias gl="git pull"
alias glog="git graph"
alias gp="git push"
alias gs="git status -sb"
alias gst="git status -s -b && git log --oneline -n5 2>/dev/null || :"

# directory short cuts
alias d='cd ~/Downloads/'
alias dev="cd ~/dev"
alias p='cd ~/Projects/'
alias work="cd ~/work"

# Misc
alias .="cd .."
alias active-sims="xcrun simctl list 'devices' 'booted'"
alias cl="clear"
alias ip="curl -s ipinfo.io/ip"
alias reload="exec $SHELL -l"
alias usage="du -h -d 1 | sort -h"
