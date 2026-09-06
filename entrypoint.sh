#!/bin/sh
set -eu
umask 077

: "${SUBSCRIPTION_URL:=}"
case "$SUBSCRIPTION_URL" in
  http://?*|https://?*) ;;
  *) echo 'SUBSCRIPTION_URL must be an HTTP(S) subscription URL' >&2; exit 1 ;;
esac
case "$SUBSCRIPTION_URL" in
  *[[:space:][:cntrl:]]*) echo 'SUBSCRIPTION_URL must be one URL without whitespace' >&2; exit 1 ;;
esac

envsubst '$SUBSCRIPTION_URL' \
  < /etc/mihomo/config.yaml \
  > /run/mihomo/config.yaml
unset SUBSCRIPTION_URL

exec mihomo -d /run/mihomo -f /run/mihomo/config.yaml "$@"
