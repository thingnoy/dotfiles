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

y() {
  n $@
}

function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }

# pj — project jumper: fzf across ~/projects (own work, incl. devspace/ + workspace/<org>/) + ghq tree (clones)
pj() {
  local dir
  dir=$( { ls -d "$HOME"/projects/*/ "$HOME"/projects/devspace/*/ "$HOME"/projects/workspace/*/*/ 2>/dev/null; \
           ghq list --full-path 2>/dev/null; } \
    | sed 's|/*$||' \
    | command grep -vE '_archive|/projects/(devspace|workspace)$' \
    | fzf --prompt='project> ' --preview 'ls {}' ) || return
  cd "$dir"
}
