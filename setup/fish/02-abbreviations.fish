#!/usr/bin/env fish

echo "🔵 applying abbreviations."

# misc abbreviations.
abbr -a md 'mkdir -p'
abbr -a npmg 'npm list -g --depth 0'
abbr -a cls clear

# git abbreviations.
abbr -a g git
abbr -a gaa 'git add --all'
abbr -a gc 'git commit'
abbr -a gco 'git checkout'
abbr -a gcm 'git checkout $(git_main_branch)'
abbr -a gcd 'git checkout $(git_develop_branch)'
abbr -a gcf 'git config --list'
abbr -a gd 'git diff'
abbr -a gl 'git pull'
abbr -a glog 'git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --all'
abbr -a gp 'git push'
abbr -a gss 'git status -s'
abbr -a gst 'git status'

# exa abbreviations.
abbr -a tree 'exa --tree'
abbr -a l 'exa --color-scale --group-directories-first --header --long --time-style=long-iso'
abbr -a ll 'l --accessed --created --modified --group'
abbr -a la 'l --accessed --sort=acc'   # oldest accessed on top
abbr -a lc 'l --created --sort=cr'     # oldest created on top
abbr -a lm 'l --modified --sort=mod'   # oldest modfied on top
abbr -a ls 'l --sort=size'  

# tmux abbreviations.
abbr -a ta 'tmux attach'
abbr -a tns 'tmux new -s'

# chezmoi abbreviations.
abbr -a ch chezmoi
