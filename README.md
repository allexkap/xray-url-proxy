# URL2Proxy

URL2Proxy runs a Mihomo subscription as a local HTTP/SOCKS5 proxy. It listens
on `127.0.0.1:7890`, checks nodes every five minutes, automatically selects a
responsive node, and refreshes the subscription every four hours.

## Portable mode

Export `SUBSCRIPTION_URL` and start the published image:

```bash
read -rsp 'Subscription URL: ' SUBSCRIPTION_URL; echo
export SUBSCRIPTION_URL
podman run --rm \
  -e SUBSCRIPTION_URL \
  -p 127.0.0.1:7890:7890 \
  ghcr.io/allexkap/url2proxy:latest
unset SUBSCRIPTION_URL
```

The portable mode uses the writable container layer for its generated
configuration and subscription cache. You can replace `podman` with `docker`
in the portable commands. Quadlet and `podman secret` are Podman-specific.

## Quadlet

Install the Quadlet unit to run the published GHCR image:

```bash
install -d ~/.config/containers/systemd
curl -fsSL https://raw.githubusercontent.com/allexkap/url2proxy/main/quadlets/url2proxy.container \
  -o ~/.config/containers/systemd/url2proxy.container

read -rsp 'Subscription URL: ' subscription_url; echo
printf '%s' "$subscription_url" | podman secret create url2proxy-subscription -
unset subscription_url

systemctl --user daemon-reload
systemctl --user start url2proxy.service
```

## Updates

To update the Quadlet service:

```bash
podman pull ghcr.io/allexkap/url2proxy:latest
systemctl --user restart url2proxy.service
```

## Verify

```bash
curl --proxy http://127.0.0.1:7890 https://api.ipify.org
```

## Configuration

- `SUBSCRIPTION_URL` is the only external setting.
- Supported payloads include Clash/Mihomo YAML, URI lists, and Base64-encoded
  URI lists. A single `vless://` or `hysteria2://` URI is not a subscription URL.

The base images are pinned to the Mihomo v1.19.30 and Alpine 3.22 digests.
