#!/usr/bin/env bash
# This script actions the test run. Which means:
#   Perform a MINIMAL install of drupal
#   Installs the module under test, your module should require via its composer.json any dependencies that it has
#   Starts nginx
#   Runs PHPUNIT from the folder of the module under test

set -e

# Install Drupal etc....
source /opt/app-root/scripts/util/bootstrap.sh

#Start the services and run the tests
pushd /opt/app-root/src/app/docroot
    # Run the tests. This executes a custom test suite that points to the module under tests folder
    source /opt/app-root/runtime/test.sh
popd