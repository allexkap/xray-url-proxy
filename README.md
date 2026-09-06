# URL2Proxy

URL2Proxy runs a Mihomo subscription as a local HTTP/SOCKS5 proxy. It listens
on `127.0.0.1:7890`, checks nodes every five minutes, automatically selects a
responsive node, and refreshes the subscription every four hours.

## Quadlet

Move the complete repository into the user data directory, then link its
Quadlet units into the user systemd directory:

```bash
install -d ~/.local/share ~/.config/containers/systemd
cd .. && mv url2proxy ~/.local/share/url2proxy && cd ~/.local/share/url2proxy

ln -s ~/.local/share/url2proxy/quadlets ~/.config/containers/systemd/url2proxy

read -rsp 'Subscription URL: ' subscription_url; echo
printf '%s' "$subscription_url" | podman secret create url2proxy-subscription -
unset subscription_url

systemctl --user daemon-reload
systemctl --user start url2proxy.service
```

## Portable mode

Build the image, export `SUBSCRIPTION_URL`, and start the container:

```bash
podman build -t url2proxy .
read -rsp 'Subscription URL: ' SUBSCRIPTION_URL; echo
export SUBSCRIPTION_URL
podman run -d -p 127.0.0.1:7890:7890 -e SUBSCRIPTION_URL url2proxy
unset SUBSCRIPTION_URL
```

The portable mode uses the writable container layer for its generated
configuration and subscription cache. For these `build` and `run` commands,
`podman` may be replaced with `docker`. Quadlet and `podman secret` are
Podman-specific.

## Verify

```bash
curl --proxy http://127.0.0.1:7890 https://api.ipify.org
```

## Configuration

- `SUBSCRIPTION_URL` is the only external setting.
- Supported payloads include Clash/Mihomo YAML, URI lists, and Base64-encoded
  URI lists. A single `vless://` or `hysteria2://` URI is not a subscription URL.

The base images are pinned to the Mihomo v1.19.30 and Alpine 3.22 digests.
