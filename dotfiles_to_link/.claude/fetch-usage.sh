#!/bin/bash
# Fetches Claude plan quota from the oauth/usage endpoint.
# Caches result for 5 minutes to avoid rate limits.
# Safe to call frequently — exits instantly when cache is fresh.

CACHE_FILE="/tmp/claude-usage-cache.json"
CACHE_AGE=300  # seconds (5 min)

# Exit immediately if cache is still fresh
if [ -f "$CACHE_FILE" ]; then
    last_mod=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0)
    age=$(( $(date +%s) - last_mod ))
    [ "$age" -lt "$CACHE_AGE" ] && exit 0
fi

# --- Get OAuth access token ---
TOKEN=""

# Linux: ~/.claude/.credentials.json
if [ -z "$TOKEN" ] && [ -f "$HOME/.claude/.credentials.json" ]; then
    TOKEN=$(jq -r '.claudeAiOauth.accessToken // empty' "$HOME/.claude/.credentials.json" 2>/dev/null)
fi

# macOS: system keychain
if [ -z "$TOKEN" ] && command -v security &>/dev/null; then
    raw=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
    [ -n "$raw" ] && TOKEN=$(echo "$raw" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
fi

[ -z "$TOKEN" ] && exit 1

# --- Fetch quota from API ---
response=$(curl -sf --max-time 5 \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "Accept: application/json" \
    -H "User-Agent: claude-code/2.0.31" \
    "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)

# Only overwrite cache on success (keep stale data on failure)
if [ $? -eq 0 ] && echo "$response" | jq -e '.five_hour' &>/dev/null; then
    echo "$response" > "$CACHE_FILE"
fi
