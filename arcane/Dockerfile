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

# Use the official Arcane runtime image.
FROM getarcaneapp/manager:latest

# Copy the statically compiled startup wrapper.
COPY --from=wrapper-builder /out/ha-entrypoint /app/ha-entrypoint

# Replace the entrypoint while retaining Arcane's original CMD.
ENTRYPOINT ["/app/ha-entrypoint"]
