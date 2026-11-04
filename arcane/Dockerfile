# Use the official Cturra Ntp image directly.
# BUILD_FROM is declared to satisfy HA's build tooling but not used —
# we want the full NPM image, not the minimal HA base.
ARG BUILD_FROM
FROM getarcaneapp/manager:latest

# Install jq to read Home Assistant configuration
RUN apk add --no-cache jq

# Add our Home Assistant startup wrapper
COPY run.sh /usr/local/bin/ha-entrypoint.sh
RUN chmod +x /usr/local/bin/ha-entrypoint.sh

# Expose port 3552
EXPOSE 3552

# Replace upstream entrypoint with our wrapper
ENTRYPOINT ["/bin/sh", "/usr/local/bin/ha-entrypoint.sh"]
