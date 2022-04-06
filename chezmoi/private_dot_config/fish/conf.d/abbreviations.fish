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
abbr glog "git log --graph --pretty=format:"%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset" --abbrev-commit --date=relative"
abbr gd "git diff"
abbr gb "git branch"
abbr gaa "git add --all"
abbr gcd "git checkout develop"

# Misc
abbr - "cd -"
abbr cl "clear"
abbr ip "curl ifconfig.me"
abbr l "ls -la"
abbr reload "exec $SHELL -l"