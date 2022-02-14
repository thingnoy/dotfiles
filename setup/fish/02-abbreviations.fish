#!/usr/bin/env fish

echo "🔵 applying abbreviations."

# misc abbreviations.
abbr -a md 'mkdir -p'
abbr -a npmg 'npm list -g --depth 0'
abbr -a cls clear

# git abbreviations.
abbr -a g git
abbr -a gaa 'git add --all'
abbr -a gba 'git branch -a'
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
abbr -a ls 'exa'                                                          # ls
abbr -a l 'exa -lbF --git'                                                # list, size, type, git
abbr -a ll 'exa -lbGF --git'                                              # long list
abbr -a llm 'exa -lbGF --git --sort=modified'                             # long list, modified date sort
abbr -a la 'exa -la --git --sort=modified'                                # list all, long list, modified date sort
abbr -a lla 'exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
abbr -a llx 'exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list

# tmux abbreviations.
abbr -a ta 'tmux attach'
abbr -a tns 'tmux new -s'

# chezmoi abbreviations.
abbr -a ch chezmoi
