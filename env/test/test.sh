#!/usr/bin/env bash

popd /opt/app-root/src/app
    #This will fetch dependencies but not screw up the base installation
    /opt/app-root/src/composer.phar update --lock
pushd

popd /opt/app-root/src/app/docroot
    php -d memory_limit=1024M /opt/app-root/src/app/vendor/bin/drupal site:install standard --langcode ${DRUPAL_LANGCODE} --db-type ${DRUPAL_DB_TYPE} --db-host ${DRUPAL_DB_HOST} --db-name ${DRUPAL_DB_NAME} --db-user ${DRUPAL_DB_USER} --db-pass ${DRUPAL_DB_PASS} --db-port ${DRUPAL_DB_PORT} --db-prefix ${DRUPAL_DB_PREFIX} --site-name ${DRUPAL_SITE_NAME} --site-mail ${DRUPAL_SITE_MAIL} --account-name ${DRUPAL_ACCOUNT_NAME} --account-mail ${DRUPAL_ACCOUNT_MAIL} --account-pass ${DRUPAL_ACCOUNT_PASS}
    php -d memory_limit=1024M /opt/app-root/src/app/vendor/bin/drupal module:install ${TEST_MODULE}
    php -d memory_limit=1024M /opt/app-root/src/app/vendor/bin/phpunit /opt/app-root/test
pushd