#!/usr/bin/env bash

set -e

required_variables=(
MYSQL_HOST
MYSQL_USER
MYSQL_PASSWORD
MYSQL_DATABASE
TITLE
BMLT_ROOT_SERVER
GOOGLE_MAPS_API_KEY
TWILIO_ACCOUNT_SID
TWILIO_AUTH_TOKEN
)

for varname in "${required_variables[@]}"; do
  if [[ -z "${!varname}" ]]; then
    echo "Error: ${varname} is required"
    exit 1
  fi
done

gomplate -f /tmp/config.php -o /var/www/html/config.php

apache2-foreground
