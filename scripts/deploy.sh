#!/bin/sh

# Show what we execute
set -x

cd /var/www/magento2/

# Wipe out all caches
/bin/rm -rf var/*

# Set up, rebuilding database from scratch.
# Port 8080 must match what you expose via Vagrantfile.
php -f setup/index.php install \
        --cleanup_database \
        --db_host=localhost \
        --db_name=magento \
        --db_user=magento \
        --db_pass=secret \
        --backend_frontname=admin \
        --base_url=http://127.0.0.1:8080/ \
        --language=en_US \
        --timezone=America/Los_Angeles \
        --currency=USD \
        --admin_lastname=Smith \
        --admin_firstname=John \
        --admin_email=john.smith@example.com \
        --admin_username=admin \
        --admin_password=admin123 \
        --use_secure=0
