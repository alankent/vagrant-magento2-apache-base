#!/bin/sh

# Show what we execute
set -x

cd /var/www/magento2/

# Wipe out all caches
/bin/rm -rf var/*

# Set up, rebuilding database from scratch.
# Port 8080 must match what you expose via Vagrantfile.
php bin/magento setup:install \
        --cleanup-database \
        --db-host=localhost \
        --db-name=magento \
        --db-user=magento \
        --db-password=secret \
        --backend-frontname=admin \
        --base-url=http://127.0.0.1:8080/ \
        --language=en_US \
        --timezone=America/Los_Angeles \
        --currency=USD \
        --admin-lastname=Smith \
        --admin-firstname=John \
        --admin-email=john.smith@example.com \
        --admin-user=admin \
        --admin-password=admin123 \
        --use-secure=0
