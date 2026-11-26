# Community-maintained all-in-one image:
# Immich Server + PostgreSQL + Redis, with the local ML service omitted.
# Machine-learning inference is provided by the separate LattePanda host.
ARG BUILD_FROM=docker.io/fabioogaravini/hassio-immich-noml:latest
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH

LABEL \
    io.hass.name="Immich" \
    io.hass.description="Immich with bundled PostgreSQL and Redis; remote machine learning" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.version="${BUILD_VERSION}" \
    org.opencontainers.image.title="Immich Home Assistant app" \
    org.opencontainers.image.version="${BUILD_VERSION}" \
    org.opencontainers.image.source="https://github.com/killerbigpoint/ha-apps" \
    org.opencontainers.image.base.name="${BUILD_FROM}"
