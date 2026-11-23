FROM --platform=$BUILDPLATFORM caddy:2.11.9-builder AS builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH GOARM=${TARGETVARIANT#v} \
    xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/caddyserver/replace-response

FROM caddy:2.11.9
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
