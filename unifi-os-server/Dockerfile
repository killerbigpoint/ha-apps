# Wrap the pre-built UniFi OS Server image with a Home Assistant persistence
# shim. BUILD_FROM is supplied by the Home Assistant builder from build.yaml.
ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}" \
    org.opencontainers.image.source="https://github.com/killerbigpoint/ha-apps"

# STOPSIGNAL (SIGRTMIN+3) and the UniFi entrypoint are inherited from the base
# image. We only prepend a shim that maps add-on options to environment
# variables and relocates persistent state onto the /data volume before
# handing off to the original UniFi entrypoint.
COPY ha-entrypoint.sh /usr/local/bin/ha-entrypoint.sh
RUN chmod +x /usr/local/bin/ha-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ha-entrypoint.sh"]
