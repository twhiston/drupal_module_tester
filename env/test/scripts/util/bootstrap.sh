#!/usr/bin/env bash

set -e

pushd /opt/app-root/src/app
    #This will fetch dependencies but not screw up the base installation
    /opt/app-root/src/composer.phar update --lock
    /opt/app-root/src/app/vendor/bin/drupal init
popd

#wait for db to be available
/opt/app-root/scripts/util/wait-for-it.sh ${DRUPAL_DB_HOST}:3306 -s -t 240 || exit 1

#Install drupal and install our contrib module for testing
pushd /opt/app-root/src/app/docroot
    php -d memory_limit=1024M /opt/app-root/src/app/vendor/bin/drupal site:install --force minimal --langcode ${DRUPAL_LANGCODE} --db-type ${DRUPAL_DB_TYPE} --db-host ${DRUPAL_DB_HOST} --db-name ${DRUPAL_DB_NAME} --db-user ${DRUPAL_DB_USER} --db-pass ${DRUPAL_DB_PASS} --db-port ${DRUPAL_DB_PORT} --db-prefix ${DRUPAL_DB_PREFIX} --site-name ${DRUPAL_SITE_NAME} --site-mail ${DRUPAL_SITE_MAIL} --account-name ${DRUPAL_ACCOUNT_NAME} --account-mail ${DRUPAL_ACCOUNT_MAIL} --account-pass ${DRUPAL_ACCOUNT_PASS}
    php -d memory_limit=1024M /opt/app-root/src/app/vendor/bin/drupal module:install ${TEST_MODULE}
popd

#Start the services
/bin/sh /opt/app-root/services.sh &