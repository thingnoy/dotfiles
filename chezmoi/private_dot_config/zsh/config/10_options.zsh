# Awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# No duplicate history when reverse-searching my commands
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups # do not put duplicated command into history list
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt inc_append_history_time  # append command to history file immediately after execution
setopt extended_history  # record command start time
