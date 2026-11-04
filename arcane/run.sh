#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"

# Verify that Home Assistant configuration exists
if [ ! -r "$OPTIONS_FILE" ]; then
    echo "ERROR: Cannot read Home Assistant options: $OPTIONS_FILE" >&2
    exit 1
fi

# Read variables servers from Home Assistant configuration
ENCRYPTION_KEY="$(jq -r '.ENCRYPTION_KEY // ""' "$OPTIONS_FILE")"
AGENT_MODE="$(jq -r '.AGENT_MODE // "false"' "$OPTIONS_FILE")"
AGENT_TOKEN="$(jq -r '.AGENT_TOKEN // ""' "$OPTIONS_FILE")"

# Export the variable for the upstream startup script
export ENCRYPTION_KEY
export AGENT_MODE
export AGENT_TOKEN

# Execute the original upstream startup script
exec /bin/sh /opt/startup.sh
