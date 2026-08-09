zsh_stats() {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n20
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

# y — yazi with cd-on-quit
y() {
  local tmp cwd
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }

# ghq + fzf: jump to any cloned repo, plus own work under ~/projects (incl. devspace/ + workspace/<org>/)
# usage: `g` for picker, `g backend` to pre-filter; right panel previews the repo
# picker logic lives in ~/.local/bin/g-pick (shareable with e.g. a yazi keybinding)
g() {
  local dir
  dir=$(g-pick "$1") || return
  cd "$dir"
}

# same picker, but open the repo in yazi instead of cd
gy() {
  local dir
  dir=$(g-pick "$1") || return
  yazi "$dir"
}
