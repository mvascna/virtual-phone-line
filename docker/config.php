<?php
static $mysql_hostname         = {{ getenv "MYSQL_HOST" | quote }};
static $mysql_username         = {{ getenv "MYSQL_USER" | quote }};
static $mysql_password         = {{ getenv "MYSQL_PASSWORD" | quote }};
static $mysql_database         = {{ getenv "MYSQL_DATABASE" | quote }};
static $title                  = {{ getenv "TITLE" | quote }};
static $bmlt_root_server       = {{ getenv "BMLT_ROOT_SERVER" | quote }};
static $google_maps_api_key    = {{ getenv "GOOGLE_MAPS_API_KEY" | quote }};
static $twilio_account_sid     = {{ getenv "TWILIO_ACCOUNT_SID" | quote }};
static $twilio_auth_token      = {{ getenv "TWILIO_AUTH_TOKEN" | quote }};
static $en_US_voice            = {{ getenv "VOICE" "Polly.Kendra" | quote }};
static $language               = {{ getenv "LANGUAGE" "en" | quote }};
static $infinite_searching     = {{ getenv "INFINITE_SEARCHING" "false" }};
static $jft_option             = {{ getenv "JFT_OPTION" "true" }};
static $bmlt_auth              = {{ getenv "BMLT_AUTH" "true" }};
static $darkModeFeatureToggle  = {{ getenv "DARK_MODE" "true" }};
static $sms_summary_page       = {{ getenv "SMS_SUMMARY_PAGE" "false" }};
static $virtual                = {{ getenv "VIRTUAL" "true" }};
static $grace_minutes          = {{ getenv "GRACE_MINUTES" "15" }};
static $result_count_max       = {{ getenv "RESULT_COUNT_MAX" "3" }};
static $sms_combine            = {{ getenv "SMS_COMBINE" "true" }};
static $debug                  = {{ getenv "DEBUG" "false"}};
static $suppress_voice_results = {{ getenv "SUPPRESS_VOICE_RESULTS" "true"}};
{{ if getenv "DIGIT_MAP_SEARCH_TYPE" }}
static $digit_map_search_type = {{ getenv "DIGIT_MAP_SEARCH_TYPE" }};
{{ end }}
{{ if getenv "CUSTOM_QUERY" }}
static $custom_query          = {{ getenv "CUSTOM_QUERY" | quote }};
{{ end }}
{{ if getenv "TIME_FORMAT" }}
static $time_format           = {{ getenv "TIME_FORMAT" | quote }};
{{ end }}
