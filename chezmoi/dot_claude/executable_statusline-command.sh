#!/bin/bash

# Claude Code status line — 5-line "noah-oracle" style, Tokyo Night palette
# Receives JSON on stdin from Claude Code.
# Reproduces: host / repo / branch / version │ session / time / model / effort
#             ctx bar │ 5h bar │ wk bar  (each colored green/yellow/red by usage)

input=$(cat)

# Save raw JSON for auto-scale hook (PRESERVED — a hook depends on this file)
TDIR="${TMPDIR:-${TMP:-${TEMP:-/tmp}}}"
echo "$input" > "$TDIR/statusline-raw.json"

# ── Extract JSON ─────────────────────────────────────────────────────────────
cwd=$(echo "$input"      | jq -r '.workspace.current_dir // .cwd // "~"')
model=$(echo "$input"    | jq -r '.model.display_name // .model.id // "Claude"')
model="${model% (*}"      # drop " (1M context)" parenthetical to match the compact look
version=$(echo "$input"  | jq -r '.version // "?"')
session_id=$(echo "$input" | jq -r '.session_id // ""')
style=$(echo "$input"    | jq -r '.output_style.name // "default"')
effort=$(echo "$input"   | jq -r '.effort.level // ""')
fast=$(echo "$input"     | jq -r '.fast_mode // false')
repo_owner=$(echo "$input" | jq -r '.workspace.repo.owner // ""')
repo_name=$(echo "$input"  | jq -r '.workspace.repo.name // ""')

ctx_pct=$(echo "$input"  | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
used_k=$(echo "$input"   | jq -r '((.context_window.current_usage | .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens + .output_tokens) // 0) / 1000 | floor')
max_k=$(echo "$input"    | jq -r '(.context_window.context_window_size // 0) / 1000 | floor')

h5_pct=$(echo "$input"   | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
h5_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0')
wk_pct=$(echo "$input"   | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)
wk_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // 0')

# ── Tokyo Night palette (24-bit truecolor) ───────────────────────────────────
FG="192;202;245"; BLUE="122;162;247"; CYAN="125;207;255"; GREEN="158;206;106"
YELLOW="224;175;104"; RED="247;118;142"; MAGENTA="187;154;247"; ORANGE="255;158;100"
DIM="86;95;137"
fg() { printf '\033[38;2;%sm' "$1"; }
bold() { printf '\033[1m'; }
rst() { printf '\033[0m'; }

# ── Helpers ──────────────────────────────────────────────────────────────────
# color for a percentage: green < 50 < yellow < 80 < red
pct_color() { if [ "$1" -ge 80 ]; then echo "$RED"; elif [ "$1" -ge 50 ]; then echo "$YELLOW"; else echo "$GREEN"; fi; }
# 🟢/🟡/🔴 dot for a percentage
dot() { if [ "$1" -ge 80 ]; then printf '🔴'; elif [ "$1" -ge 50 ]; then printf '🟡'; else printf '🟢'; fi; }

# bar <pct> [width] — filled blocks colored by usage, dim remainder
bar() {
  local pct=$1 width=${2:-8} i fill col
  fill=$(( (pct * width + 50) / 100 ))
  [ "$fill" -gt "$width" ] && fill=$width
  [ "$fill" -lt 0 ] && fill=0
  col=$(pct_color "$pct")
  fg "$col"; for ((i=0; i<fill; i++)); do printf '█'; done
  fg "$DIM"; for ((i=fill; i<width; i++)); do printf '░'; done
  rst
}

# fmt_remaining <unix_reset> — time until reset as 4d21h / 2h54m / 7m
fmt_remaining() {
  local reset=$1 now secs d h m
  now=$(date +%s)
  secs=$(( reset - now ))
  [ "$secs" -lt 0 ] && secs=0
  d=$(( secs / 86400 )); h=$(( (secs % 86400) / 3600 )); m=$(( (secs % 3600) / 60 ))
  if   [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"
  else printf '%dm' "$m"; fi
}

# fmt_age <elapsed_secs> — cache age as ~7m / ~3h / ~2d (the ~ marks it as "as of", not a reset)
fmt_age() {
  local s=$1
  if   [ "$s" -lt 3600 ]; then printf '~%dm' $(( s / 60 ))
  elif [ "$s" -lt 86400 ]; then printf '~%dh' $(( s / 3600 ))
  else printf '~%dd' $(( s / 86400 )); fi
}

# ── Git ──────────────────────────────────────────────────────────────────────
branch="" dirty="" head_hash=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  git -C "$cwd" diff-index --quiet HEAD -- 2>/dev/null || dirty="*"
  head_hash=$(git -C "$cwd" rev-parse --short=8 HEAD 2>/dev/null)
fi

# repo label: prefer JSON owner/name, else basename of cwd
if [ -n "$repo_name" ]; then
  repo_label="${repo_owner:+$repo_owner/}$repo_name"
else
  repo_label=$(basename "$cwd")
fi

host_label="${CLAUDE_HOST_LABEL:-$(hostname -s 2>/dev/null | tr '[:upper:]' '[:lower:]')}"
sess_hash="${session_id:0:8}"
[ -z "$head_hash" ] && head_hash="--------"
[ -z "$sess_hash" ] && sess_hash="--------"
now_time=$(date '+%H:%M')

# ── Render ───────────────────────────────────────────────────────────────────
# Line 1: host · repo · branch · [style] · version
{
  printf '🖥  '; fg "$CYAN"; bold; printf '%s' "$host_label"; rst
  printf '  📁 '; fg "$BLUE"; printf '%s' "$repo_label"; rst
  if [ -n "$branch" ]; then
    printf '  '; fg "$MAGENTA"; printf '%s' "$branch"; fg "$RED"; printf '%s' "$dirty"; rst
  fi
  if [ "$style" != "default" ]; then printf '  '; fg "$DIM"; printf '🔒%s' "$style"; rst; fi
  fg "$DIM"; printf '  · '; rst; fg "$GREEN"; printf '🌐v%s' "$version"; rst
  printf '\n'
}

# Line 2: session hashes · time · model · effort
{
  fg "$DIM"; printf '🛰  '; rst
  fg "$DIM"; printf '%s ' "$head_hash"; printf '→'; printf ' %s' "$sess_hash"; rst
  fg "$DIM"; printf ' · '; rst; fg "$ORANGE"; printf '%s' "$now_time"; rst
  fg "$DIM"; printf ' · '; rst; fg "$BLUE"; bold; printf '%s' "$model"; rst
  [ "$fast" = "true" ] && { printf ' '; fg "$YELLOW"; printf '⚡fast'; rst; }
  [ -n "$effort" ] && { printf ' '; fg "$MAGENTA"; printf '🧠%s' "$effort"; rst; }
  printf '\n'
}

# Line 3: context window
{
  printf '%s ' "$(dot "$ctx_pct")"; fg "$DIM"; printf '%-5s ' 'ctx'; rst
  bar "$ctx_pct"; printf ' '
  fg "$(pct_color "$ctx_pct")"; printf '%s%%' "$ctx_pct"; rst
  fg "$DIM"; printf ' %sk/%sk' "$used_k" "$max_k"; rst
  printf '\n'
}

# Line 4: 5-hour window
{
  printf '%s ' "$(dot "$h5_pct")"; fg "$DIM"; printf '%-5s ' '5h'; rst
  bar "$h5_pct"; printf ' '
  fg "$(pct_color "$h5_pct")"; printf '%s%%' "$h5_pct"; rst
  if [ "$h5_reset" -gt 0 ]; then fg "$DIM"; printf ' %s' "$(fmt_remaining "$h5_reset")"; rst; fi
  printf '\n'
}

# Line 5: 7-day window
{
  printf '%s ' "$(dot "$wk_pct")"; fg "$DIM"; printf '%-5s ' 'wk'; rst
  bar "$wk_pct"; printf ' '
  fg "$(pct_color "$wk_pct")"; printf '%s%%' "$wk_pct"; rst
  if [ "$wk_reset" -gt 0 ]; then fg "$DIM"; printf ' %s' "$(fmt_remaining "$wk_reset")"; rst; fi
}

# Line 6+: model-scoped weekly buckets (e.g. "Current week (Fable)").
# The status-line stdin does NOT carry these — its top-level seven_day_<model> fields are
# always null. The real data is the cached /api/oauth/usage response that `/usage` renders,
# which Claude Code stores in ~/.claude.json under cachedUsageUtilization.utilization.limits[]
# (kind=weekly_scoped, scope.model.display_name). Read-only local file — no network/token.
# debt: shows last-known cached % (stale if /usage & background refresh haven't run recently);
#       ceiling = fine for an at-a-glance bar. Upgrade path: append age from fetchedAtMs.
cc_json="$HOME/.claude.json"
if [ -f "$cc_json" ]; then
  # cache age — shown only when stale (> USAGE_STALE_SECS, default 10m) so a frozen % never
  # reads as live. Fixes the staleness caveat: /usage refreshes this cache, not the statusline.
  fetched_ms=$(jq -r '.cachedUsageUtilization.fetchedAtMs // 0' "$cc_json" 2>/dev/null)
  age_str=""
  if [ "${fetched_ms:-0}" -gt 0 ]; then
    age_secs=$(( $(date +%s) - fetched_ms / 1000 ))
    [ "$age_secs" -gt "${USAGE_STALE_SECS:-600}" ] && age_str=$(fmt_age "$age_secs")
  fi
  while IFS=$'\t' read -r label m_pct m_reset; do
    [ -z "$label" ] && continue
    m_pct=${m_pct%.*}                                   # int percent for bar/dot/color
    printf '\n'
    printf '%s ' "$(dot "$m_pct")"; fg "$DIM"; printf '%-5s ' "$label"; rst
    bar "$m_pct"; printf ' '
    fg "$(pct_color "$m_pct")"; printf '%s%%' "$m_pct"; rst
    if [ -n "$m_reset" ] && [ "$m_reset" != "null" ]; then
      epoch=$(date -j -u -f '%Y-%m-%dT%H:%M:%S' "${m_reset%%.*}" +%s 2>/dev/null)
      [ -n "$epoch" ] && { fg "$DIM"; printf ' %s' "$(fmt_remaining "$epoch")"; rst; }
    fi
    [ -n "$age_str" ] && { fg "$DIM"; printf ' %s' "$age_str"; rst; }
  done < <(jq -r '
    (.cachedUsageUtilization.utilization.limits // [])[]
    | select(.kind == "weekly_scoped")
    | [ (.scope.model.display_name // "model" | ascii_downcase), (.percent // 0), (.resets_at // "null") ]
    | @tsv' "$cc_json" 2>/dev/null)
fi

# Claude Code blanks the whole status line on a non-zero exit. The trailing while-loop /
# short-circuit tests above can leave $? = 1, so force a clean exit.
exit 0
