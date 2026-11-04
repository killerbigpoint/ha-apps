#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"

# Verify that Home Assistant configuration exists
if [ ! -r "$OPTIONS_FILE" ]; then
    echo "ERROR: Cannot read Home Assistant options: $OPTIONS_FILE" >&2
    exit 1
fi
