#!/bin/bash
set -e
source "$(dirname "$0")/env.sh"
cp "$DEPLOY_DIR/$APP_NAME.war" "$TOMCAT_WEBAPPS/$APP_NAME.war"
chown tomcat:tomcat "$TOMCAT_WEBAPPS/$APP_NAME.war" 2>/dev/null || true
