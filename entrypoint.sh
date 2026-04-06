#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: docker run -dp <port>:8080 allexkap/xray-url-proxy <url>"
    echo "Extra: --rm --read-only --tmpfs /tmp --cap-drop ALL --security-opt no-new-privileges"
    exit 1
fi

Xray-Link-Json "$1" 2> /dev/null | jq \
'{
  log: { loglevel: "warning" },
  inbounds: [
    {
      listen: "0.0.0.0",
      port: 8080,
      protocol: "http"
    }
  ],
  outbounds: (
    .outbounds | map(
      if has("sendThrough") then
        .tag = .sendThrough | del(.sendThrough)
      else
        .
      end
    )
  )
}' > /tmp/config.json

exec xray run -c /tmp/config.json
