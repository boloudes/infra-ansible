#!/usr/bin/env bash
set -euo pipefail
APP=fb-dashboard
REPO_SSH="git@github.com:boloudes/fb-dashboard.git"
RELEASE_DIR="/var/www/${APP}/releases"
CURRENT_LINK="/var/www/${APP}/current"
ts="$(date +%Y%m%d%H%M%S)"
dst="${RELEASE_DIR}/${ts}"

install -d -m 755 "$RELEASE_DIR"

# Clone la dernière version avec la clé dédiée FB
GIT_SSH_COMMAND='ssh -i /root/.ssh/fb_dashboard_ed25519 -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new' \
  git clone --depth 1 "$REPO_SSH" "$dst"

# Bascule atomique
ln -sfn "$dst" "$CURRENT_LINK"

# Permissions + reload nginx
chown -R www-data:www-data "/var/www/${APP}"
systemctl reload nginx || true

echo "[OK] ${APP} déployé → $(readlink -f "$CURRENT_LINK")"
