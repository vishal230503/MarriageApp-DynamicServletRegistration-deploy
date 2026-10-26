#!/bin/bash
set -e
source "$(dirname "$0")/env.sh"
mkdir -p "$DEPLOY_DIR"
# Backup current WAR for quick rollback
if [ -f "$TOMCAT_WEBAPPS/$APP_NAME.war" ]; then
  cp "$TOMCAT_WEBAPPS/$APP_NAME.war" "$DEPLOY_DIR/$APP_NAME.war.bak"
fi
# Remove old exploded app so the new WAR is unpacked fresh
rm -rf "$TOMCAT_WEBAPPS/$APP_NAME" "$TOMCAT_WEBAPPS/$APP_NAME.war"
