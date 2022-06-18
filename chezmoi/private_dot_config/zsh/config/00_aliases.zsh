# Editing
alias aliases='$EDITOR ~/.config/zsh/config/00_aliases.zsh ; reload ; echo "Aliases reloaded"'
alias funcs='$EDITOR ~/.config/zsh/config/20_functions.zsh ; reload ; echo "Aliases reloaded"'
alias zshrc='$EDITOR ~/.zshrc ; reload'

# M1
alias aa='arch -arm64 '
alias ax='arch -x86_64 '
alias brewx='ax /usr/local/bin/brew'

# Git
alias gp="git push"
alias gl="git pull"
alias glog="git graph"
alias gd='git diff'
alias gaa="git add --all"
alias gcd="git checkout develop"
alias gcm="git checkout main"
alias gst="git status -s -b && git log --oneline -n5 2>/dev/null || :"
alias gs="git status -sb"
alias gb="git branch"
alias gba="git branch -a"
alias gcmsg="git commit -m"

# Misc
alias -- -="cd -"
alias cl="clear"
f() {
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzy) && cd "$dir"
}
alias ip="curl ifconfig.me"
alias l="ls -la"
alias reload="exec $SHELL -l"
alias work="cd ~/work"
alias dev="cd ~/dev"
alias active-sims="xcrun simctl list 'devices' 'booted'"

# Unused aliases
ua() {
  one_alphabet_aliases=$(alias | gsed -E 's/=.*//g' | gsed -E '/^.{1}$/!d' | sort)
  alphas=$(echo "qwfpgjluy:[]arstdhneio'zxcvbkm,./" | grep -o . | sort)
  unused_aliases=$(comm -23 <(echo $alphas) <(echo $one_alphabet_aliases))
  echo "Unused aliases $(echo $unused_aliases | wc -l): "
  echo $unused_aliases | paste -s -d " " -
}
