# Awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Enable extended globbing
setopt extendedglob

# Allow [ or ] whereever you want
unsetopt nomatch

# Save 10,000 entries
HISTSIZE=10000
SAVEHIST=10000

# History File Location
HISTFILE=~/.zsh_history

# Save timestamps
setopt EXTENDED_HISTORY

# Save every command before it's executed
setopt INC_APPEND_HISTORY

# Share command history between all sessions
setopt SHARE_HISTORY

# Ignore duplicates
setopt HIST_IGNORE_DUPS

# Don't save commands starting with a space
setopt HIST_IGNORE_SPACE

# Skip over older duplicates of commands
setopt HIST_FIND_NO_DUPS
