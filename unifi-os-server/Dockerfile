# Home Assistant wrapper around our published UniFi OS Server image.
# The custom GitHub Actions workflow supplies BUILD_FROM from build.yaml.
ARG BUILD_FROM=ghcr.io/killerbigpoint/unifi-os-server:v5.1.42
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}" \
    org.opencontainers.image.title="UniFi OS Server Home Assistant app" \
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.source="https://github.com/killerbigpoint/ha-apps" \
    org.opencontainers.image.base.name="${BUILD_FROM}"

# Keep the upstream stop signal; only wrap its original entrypoint.
COPY ha-entrypoint.sh /usr/local/bin/ha-entrypoint.sh
RUN chmod 0755 /usr/local/bin/ha-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/ha-entrypoint.sh"]
