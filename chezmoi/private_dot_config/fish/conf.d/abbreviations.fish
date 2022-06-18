# Editing
abbr aliases '$EDITOR ~/.config/zsh/config/00_aliases.zsh ; reload ; echo "Aliases reloaded"'
abbr funcs '$EDITOR ~/.config/zsh/config/20_functions.zsh ; reload ; echo "Aliases reloaded"'
abbr zshrc "$EDITOR ~/.zshrc ; reload"

# M1
abbr aa "arch -arm64 "
abbr ax "arch -x86_64 "
abbr brewx "ax /usr/local/bin/brew"

# Git
abbr gp "git push"
abbr gl "git pull"
abbr glog "git graph"
abbr gd "git diff"
abbr gaa "git add --all"
abbr gcd "git checkout develop"
abbr gcm "git checkout main"
abbr gst "git status -s -b && git log --oneline -n5 2>/dev/null || :"
abbr gs "git status -sb"
abbr gb "git branch"
abbr gba "git branch -a"
abbr gcmsg "git commit -m"

# Misc
abbr - "cd -"
abbr cl "clear"
abbr ip "curl ifconfig.me"
abbr l "ls -la"
abbr reload "exec $SHELL -l"
abbr work "cd ~/work"
abbr dev "cd ~/dev"
abbr active-sims "xcrun simctl list 'devices' 'booted'"
