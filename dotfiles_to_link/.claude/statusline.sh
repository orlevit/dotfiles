#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name' | sed 's/ (.*//')
# Effort: check session transcript for latest /effort change, fall back to settings.json
TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // empty')
EFFORT=""
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
    EFFORT=$(tac "$TRANSCRIPT" | grep -m1 -oP 'Set effort level to \K\w+' 2>/dev/null)
fi
[ -z "$EFFORT" ] && EFFORT=$(jq -r '.effortLevel // "auto"' ~/.claude/settings.json 2>/dev/null || echo "auto")
CWD=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

BOLD_GREEN='\033[01;32m'; CYAN='\033[0;36m'; YELLOW='\033[33m'; RED='\033[31m'; GREEN='\033[32m'; MAGENTA='\033[0;35m'; GRAY='\033[0;90m'; RESET='\033[00m'

# PS1-style: user@host:path (git-branch*)
# Abbreviate home directory with ~
DISPLAY_PATH="${CWD/#$HOME/\~}"

# Git branch with dirty indicator (mirrors parse_git_branch from ~/.bashrc)
GIT_BRANCH=""
if git -C "$CWD" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$CWD" branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$branch" ]; then
        dirty=$(git -C "$CWD" status --porcelain 2>/dev/null)
        [ -n "$dirty" ] && branch="${branch}*"
        GIT_BRANCH=" (${branch})"
    fi
fi

# Line 1: PS1-style prompt header
printf "${CYAN}%s${RESET}${YELLOW}%s${RESET}\n" \
    "$DISPLAY_PATH" "$GIT_BRANCH"

# Line 2: model, context bar, cost, duration
if [ "$PCT" -ge 80 ]; then BAR_COLOR="$RED";   CTX_LABEL_COLOR="$RED"
elif [ "$PCT" -ge 50 ]; then BAR_COLOR="$YELLOW"; CTX_LABEL_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; CTX_LABEL_COLOR="$GREEN"; fi

FILLED=$((PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

MINS=$((DURATION_MS / 60000)); SECS=$(((DURATION_MS % 60000) / 1000))
COST_FMT=$(printf '$%.2f' "$COST")

# Plan quota — trigger background refresh, build inline string
(~/.claude/fetch-usage.sh &>/dev/null &) 2>/dev/null

QUOTA_STR=""
USAGE_CACHE="/tmp/claude-usage-cache.json"
if [ -f "$USAGE_CACHE" ]; then
    FIVE_H=$(jq -r '.five_hour.utilization // empty' "$USAGE_CACHE" 2>/dev/null)
    RESET_AT=$(jq -r '.five_hour.resets_at // empty' "$USAGE_CACHE" 2>/dev/null)
    if [ -n "$FIVE_H" ]; then
        FIVE_H_INT=${FIVE_H%.*}
        RESET_STR=""
        if [ -n "$RESET_AT" ]; then
            RESET_EPOCH=$(date -d "$RESET_AT" +%s 2>/dev/null)
            if [ -n "$RESET_EPOCH" ]; then
                DIFF=$(( RESET_EPOCH - $(date +%s) ))
                if [ "$DIFF" -gt 0 ]; then
                    RH=$((DIFF / 3600)); RM=$(((DIFF % 3600) / 60))
                    RESET_STR="↻${RH}h${RM}m"
                fi
            fi
        fi
        QUOTA_STR="${YELLOW}qt:${FIVE_H_INT}%(${RESET_STR})${RESET} | "
    fi
fi

printf "${GRAY}[%s (Level:%s)]${RESET} ${CTX_LABEL_COLOR}ctx:${RESET} ${BAR_COLOR}%s${RESET} %s%% | ${QUOTA_STR}${MAGENTA}ssn: %dm %ds(%s)${RESET}\n" \
    "$MODEL" "$EFFORT" "$BAR" "$PCT" "$MINS" "$SECS" "$COST_FMT"
