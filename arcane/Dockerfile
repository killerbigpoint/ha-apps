# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM golang:1.27-alpine AS wrapper-builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src

COPY ha-entrypoint.go .

RUN mkdir -p /out && \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS:-linux} \
    GOARCH=${TARGETARCH} \
    go build \
    -trimpath \
    -ldflags="-s -w" \
    -o /out/ha-entrypoint \
    ./ha-entrypoint.go

# Official Arcane runtime.
FROM getarcaneapp/manager:latest

COPY --from=wrapper-builder /out/ha-entrypoint /app/ha-entrypoint

ENTRYPOINT ["/app/ha-entrypoint"]
