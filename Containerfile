FROM docker.io/metacubex/mihomo:v1.19.30@sha256:baf38d282b785d7037337676714a69e3fdd1f2d9bf748dfd25fce681a624ea74 AS upstream
FROM docker.io/library/alpine:3.22@sha256:14358309a308569c32bdc37e2e0e9694be33a9d99e68afb0f5ff33cc1f695dce
COPY --from=upstream /mihomo /usr/local/bin/mihomo
COPY --from=upstream /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
RUN apk add --no-cache gettext-envsubst \
    && install -d -o 65532 -g 65532 -m 0700 /run/mihomo
COPY config.yaml /etc/mihomo/config.yaml
COPY --chmod=0755 entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 7890/tcp
USER 65532:65532
ENTRYPOINT ["/bin/sh", "/usr/local/bin/entrypoint.sh"]
