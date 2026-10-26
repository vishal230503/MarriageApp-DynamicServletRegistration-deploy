#!/bin/bash
set -e
source "$(dirname "$0")/env.sh"
systemctl start "$TOMCAT_SERVICE"
