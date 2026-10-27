# Use the official Nginx Proxy Manager image directly.
# BUILD_FROM is declared to satisfy HA's build tooling but not used —
# we want the full NPM image, not the minimal HA base.
ARG BUILD_FROM
FROM zoeyvid/npmplus:2026-10-22-r1

# Run our HA setup script early in s6's cont-init sequence.
# Uses /bin/sh — with-contenv is not available in the jc21 base image.
COPY cont-init.d/01-ha-setup.sh /etc/cont-init.d/01-ha-setup.sh
RUN chmod +x /etc/cont-init.d/01-ha-setup.sh

EXPOSE 80 81 443

# Do NOT override ENTRYPOINT — s6-overlay (/init) must run as PID 1.
