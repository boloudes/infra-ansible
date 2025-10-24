#!/bin/bash
LOGFILE="/var/log/letsencrypt/monit-certbot-check.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

certbot renew --dry-run --quiet
STATUS=$?

if [ $STATUS -ne 0 ]; then
  echo "[$DATE] ❌ Échec certbot renew --dry-run (code $STATUS)" >> "$LOGFILE"
  exit 1
fi

EXPIRING=$(certbot certificates 2>/dev/null | grep -B2 "INVALID\|EXPIRED\|VALID: [0-9]\{1,2\} day" | grep "Certificate Name" || true)
if [ -n "$EXPIRING" ]; then
  echo "[$DATE] ⚠️ Certificat proche expiration : $EXPIRING" >> "$LOGFILE"
  exit 2
fi

echo "[$DATE] ✅ Certbot OK - tous certificats valides" >> "$LOGFILE"
exit 0
