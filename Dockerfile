FROM golang:1.26.1-alpine3.23 AS builder
RUN apk add git && go install github.com/NightMachinery/Xray-Link-Json@v0.0.0-20260322231717-c363d7a84131

FROM teddysun/xray:26.3.27
RUN apk add --no-cache jq ca-certificates && update-ca-certificates

RUN addgroup -S app && adduser -S -G app app

COPY --from=builder /go/bin/Xray-Link-Json /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

WORKDIR /home/app
USER app

ENTRYPOINT ["/entrypoint.sh"]
