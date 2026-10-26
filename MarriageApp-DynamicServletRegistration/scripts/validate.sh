#!/bin/bash
source "$(dirname "$0")/env.sh"
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w '%{http_code}' "$HEALTH_URL")
  if [ "$code" = "200" ]; then echo "Healthy ($HEALTH_URL)"; exit 0; fi
  echo "Waiting for app... attempt $i (HTTP $code)"; sleep 5
done
echo "Validation failed"; exit 1
