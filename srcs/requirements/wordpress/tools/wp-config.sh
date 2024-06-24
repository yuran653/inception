#!/bin/sh

echo "WP_VERSION=$(wp core version --allow-root --path=/var/www)"

if [ -f "/var/www/wp-config.php" ]; then
    $@
    exit 0
fi

echo "Creating wp-config.php ..."

DB_NAME=$(cat /run/secrets/db_creds | grep DB_NAME | cut -d '=' -f2 | tr -d '\n')
DB_USER=$(cat /run/secrets/db_creds | grep DB_USER | cut -d '=' -f2 | tr -d '\n')
DB_PASS=$(cat /run/secrets/db_creds | grep DB_PASS | cut -d '=' -f2 | tr -d '\n')

cat << EOF > /var/www/wp-config.php
<?php
define( 'DB_NAME', '${DB_NAME}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASS}' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
define('FS_METHOD','direct');
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
define( 'ABSPATH', __DIR__ . '/' );}
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_REDIS_TIMEOUT', 1 );
define( 'WP_REDIS_READ_TIMEOUT', 1 );
define( 'WP_REDIS_DATABASE', 0 );
require_once ABSPATH . 'wp-settings.php';
EOF

echo "Success: wp-config.php is created"

echo "Waiting for MariaDB to be ready..."
while ! nc -z mariadb 3306; do
    :
done

URL=$(cat /run/secrets/wp_creds | grep URL | cut -d '=' -f2 | tr -d '\n')
TITLE=$(cat /run/secrets/wp_creds | grep TITLE | cut -d '=' -f2 | tr -d '\n')
ADMIN_LOGIN=$(cat /run/secrets/wp_creds | grep ADMIN_LOGIN | cut -d '=' -f2 | tr -d '\n')
ADMIN_PASS=$(cat /run/secrets/wp_creds | grep ADMIN_PASS | cut -d '=' -f2 | tr -d '\n')
ADMIN_MAIL=$(cat /run/secrets/wp_creds | grep ADMIN_MAIL | cut -d '=' -f2 | tr -d '\n')

wp core install --allow-root --path=/var/www \
                --url=$URL \
                --title=$TITLE \
                --admin_user=$ADMIN_LOGIN \
                --admin_password=$ADMIN_PASS \
                --admin_email=$ADMIN_MAIL

USER1_LOGIN=$(cat /run/secrets/wp_creds | grep USER1_LOGIN | cut -d '=' -f2 | tr -d '\n')
USER1_PASS=$(cat /run/secrets/wp_creds | grep USER1_PASS | cut -d '=' -f2 | tr -d '\n')
USER1_ROLE=$(cat /run/secrets/wp_creds | grep USER1_ROLE | cut -d '=' -f2 | tr -d '\n')
USER1_MAIL=$(cat /run/secrets/wp_creds | grep USER1_MAIL | cut -d '=' -f2 | tr -d '\n')

wp user create  --allow-root --path=/var/www \
                $USER1_LOGIN \
                $USER1_MAIL \
                --user_pass=$USER1_MAIL \
                --role=$USER1_ROLE

wp plugin update --allow-root --path=/var/www --all
wp plugin install wp-redis --allow-root --path=/var/www --activate
wp redis enable --allow-root --path=/var/www

$@
