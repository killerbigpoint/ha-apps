#!/bin/bash
# Home Assistant persistence and configuration shim for UniFi OS Server.
# /data is the persistent app volume and also contains options.json.
set -Eeuo pipefail

DATA=/data
OPTS="$DATA/options.json"

# Read the string options without requiring jq in the base image.
if [[ -r "$OPTS" ]]; then
    _read_opt() {
        local key="$1"
        sed -n 's/.*"'"$key"'"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$OPTS" | head -n 1
    }

    _uos_ip="$(_read_opt UOS_SYSTEM_IP)"
    _hw_platform="$(_read_opt HARDWARE_PLATFORM)"

    if [[ -n "$_uos_ip" ]]; then
        export UOS_SYSTEM_IP="$_uos_ip"
        echo "[ha-shim] UOS_SYSTEM_IP configured"
    fi

    if [[ -n "$_hw_platform" ]]; then
        export HARDWARE_PLATFORM="$_hw_platform"
        echo "[ha-shim] HARDWARE_PLATFORM=$_hw_platform"
    fi
fi

# Relocate state onto the persistent /data volume. Do not delete source data
# unless the copy completed successfully.
persist() {
    local src="$1"
    local name="$2"
    local dst="$DATA/$name"

    if [[ -L "$src" ]]; then
        local link_target
        link_target="$(readlink "$src")"
        if [[ "$link_target" == "$dst" ]]; then
            return 0
        fi
        echo "[ha-shim] ERROR: $src points to unexpected target $link_target" >&2
        return 1
    fi

    mkdir -p "$dst"

    if [[ -e "$src" ]]; then
        echo "[ha-shim] Migrating $src to $dst"
        cp -a -- "$src/." "$dst/"
        rm -rf -- "$src"
    fi

    mkdir -p "$(dirname "$src")"
    ln -s "$dst" "$src"
    echo "[ha-shim] Persistent path: $src -> $dst"
}

# Keep this list aligned with the state directories required by the base image.
persist /persistent persistent
persist /srv srv
persist /var/lib/unifi var-lib-unifi
persist /var/lib/mongodb var-lib-mongodb
persist /var/log var-log
persist /etc/rabbitmq/ssl etc-rabbitmq-ssl

if [[ ! -x /root/uos-entrypoint.sh ]]; then
    echo "[ha-shim] ERROR: /root/uos-entrypoint.sh is missing or not executable" >&2
    exit 127
fi

# Temporary systemd startup diagnostics
export SYSTEMD_LOG_LEVEL=debug
export SYSTEMD_LOG_TARGET=console
export SYSTEMD_LOG_COLOR=0
export SYSTEMD_LOG_LOCATION=1

echo "========== CONTAINER DIAGNOSTICS =========="

echo "=== PID 1 CGROUP ==="
cat /proc/1/cgroup

echo "=== CGROUP MOUNTS ==="
grep -E 'cgroup|cgroup2' /proc/self/mountinfo || true

echo "=== RUNTIME MOUNTS ==="
awk '$5 == "/run" || $5 == "/run/lock" || $5 == "/sys/fs/cgroup" {print}' \
    /proc/self/mountinfo

echo "=== FILESYSTEM TYPES ==="
stat -f -c '%n: %T' /run /run/lock /sys/fs/cgroup

echo "=== CGROUP CONTROLLERS ==="
if [ -f /sys/fs/cgroup/cgroup.controllers ]; then
    cat /sys/fs/cgroup/cgroup.controllers
else
    echo "No cgroup.controllers file"
fi

echo "=== CGROUP WRITE TEST ==="
if mkdir /sys/fs/cgroup/.ha-cgroup-test 2>/tmp/ha-cgroup-error; then
    rmdir /sys/fs/cgroup/.ha-cgroup-test
    echo "SUCCESS: cgroup directory creation works"
else
    echo "FAILED:"
    cat /tmp/ha-cgroup-error
fi

echo "========== END DIAGNOSTICS =========="

# Original fork entrypoint performs image initialization and starts systemd.
exec /root/uos-entrypoint.sh "$@"
