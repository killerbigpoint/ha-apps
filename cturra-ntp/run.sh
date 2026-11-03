
#!/bin/sh
set -eu

OPTIONS_FILE="/data/options.json"

# Verify that Home Assistant configuration exists
if [ ! -r "$OPTIONS_FILE" ]; then
    echo "ERROR: Cannot read Home Assistant options: $OPTIONS_FILE" >&2
    exit 1
fi

# Read NTP servers from Home Assistant configuration
NTP_SERVERS="$(jq -r '.ntp_servers // "time.cloudflare.com"' "$OPTIONS_FILE")"

# Export the variable for the upstream startup script
export NTP_SERVERS

echo "Starting NTP with servers: ${NTP_SERVERS:-time.cloudflare.com}"

# Execute the original upstream startup script
exec /bin/sh /opt/startup.sh
