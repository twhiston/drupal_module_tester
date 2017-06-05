#!/usr/bin/env bash
# Execute the test scripts
# This is kept in a different folder to the other scripts so that it can be easily overridden by mounting a volume in your container
# Which allows additional flexibility around the test running, without having to go near the bootstrapping code
# This script will be executed in the site docroot.
php -d memory_limit=1024M /opt/app-root/src/app/vendor/bin/phpunit -v --testsuite custom --printer="\Drupal\Tests\Listeners\HtmlOutputPrinter"
