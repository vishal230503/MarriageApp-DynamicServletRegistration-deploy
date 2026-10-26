#!/bin/bash
# Shared settings. Adjust to match your EC2 AMI (Tomcat installed as a systemd service named "tomcat").
export APP_NAME="MarriageApp"
export TOMCAT_SERVICE="tomcat"
export TOMCAT_WEBAPPS="/opt/tomcat/webapps"
export DEPLOY_DIR="/opt/deploy"
export HEALTH_URL="http://localhost:8080/${APP_NAME}/"
