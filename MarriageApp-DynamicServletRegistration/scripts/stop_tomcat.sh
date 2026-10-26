#!/bin/bash
source "$(dirname "$0")/env.sh"
if systemctl is-active --quiet "$TOMCAT_SERVICE"; then
  systemctl stop "$TOMCAT_SERVICE"
fi
exit 0
