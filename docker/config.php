<?php
static $mysql_hostname      = {{ getenv "MYSQL_HOST" | quote }};
static $mysql_username      = {{ getenv "MYSQL_USER" | quote }};
static $mysql_password      = {{ getenv "MYSQL_PASSWORD" | quote }};
static $mysql_database      = {{ getenv "MYSQL_DATABASE" | quote }};
static $title               = {{ getenv "TITLE" | quote }};
static $bmlt_root_server    = {{ getenv "BMLT_ROOT_SERVER" | quote }};
static $google_maps_api_key = {{ getenv "GOOGLE_MAPS_API_KEY" | quote }};
static $twilio_account_sid  = {{ getenv "TWILIO_ACCOUNT_SID" | quote }};
static $twilio_auth_token   = {{ getenv "TWILIO_AUTH_TOKEN" | quote }};
static $voice               = "Polly.Kimberly";
static $infinite_searching  = true;
static $debug               = false;
