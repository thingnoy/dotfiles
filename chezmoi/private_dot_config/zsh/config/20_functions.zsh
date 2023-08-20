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
