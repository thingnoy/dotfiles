zsh_stats() {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20
}

# nnn
nn() {
  # Block nesting of nnn in subshells
  if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
    echo "nnn is already running"
    return
  fi

  # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
  # To cd on quit only on ^G, remove the "export" as in:
  #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  # NOTE: NNN_TMPFILE is fixed, should not be modified
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

  # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
  # stty start undef
  # stty stop undef
  # stty lwrap undef
  # stty lnext undef

  nnn "$@"

  if [ -f "$NNN_TMPFILE" ]; then
    . "$NNN_TMPFILE"
    rm -f "$NNN_TMPFILE" >/dev/null
  fi
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

take() {
  mkdir -p $@ && cd ${@:$#}
}

n() {
  if [[ -f "$(pwd)/yarn.lock" ]]; then
    echo "Found yarn.lock, using Yarn"
    yarn $@
  elif [[ -f "$(pwd)/package-lock.json" ]]; then
    echo "Found package-lock.json, using Npm"
    npm $@
  elif [[ -f "$(pwd)/package.json" ]]; then
    echo "Yarn & Npm lockfile not found, but found package.json, using Yarn"
    yarn $@
  else
    echo "Yarn & Npm lockfile not found"
    return 1
  fi
}

y() {
  n $@
}

function prompt_my_arch_check() {
  local arch=$(uname -m)
  if [[ "$arch" == "arm64" ]]; then
    p10k segment -t "arm" -b 232 -f 7
  elif [[ "$arch" == "x86_64" ]]; then
    p10k segment -t "x86" -b 232 -f 7
  fi
}

function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
