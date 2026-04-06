# xray-url-proxy

A lightweight Docker image that converts a share link into a running
[Xray](https://github.com/XTLS/Xray-core) HTTP proxy instance.

## Usage

```sh
docker run -dp 8080:8080 allexkap/xray-url-proxy "vless://..."
```

## How it works

1. [`Xray-Link-Json`](https://github.com/NightMachinery/Xray-Link-Json) parses
   the share URL into a JSON config
2. `jq` patches it — adds an HTTP inbound on port 8080 and normalizes outbound
   tags
3. `xray` runs with the resulting config
