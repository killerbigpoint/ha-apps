#!/command/with-contenv bashio

NTP_SERVERS="$(bashio::config 'ntp_servers')"

printf '%s' "${NTP_SERVERS}" \
    > /var/run/s6/container_environment/NTP_SERVERS
