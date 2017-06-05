# Drupal Module Tester

Drupal 8 project for PHPUnit testing modules with docker quickly.

[ ![Codeship Status for ibrows/drupal_module_tester](https://app.codeship.com/projects/4bc3b300-e670-0134-b09a-26edd27a570b/status?branch=master)](https://app.codeship.com/projects/206815)

THIS DOES NOT RUN SIMPLETESTS!!!
WebTests are unsupported as no new modules should use them.

## How to use

If you use codeship it's easy.

If you want to get browser test log outputs check `/opt/app-root/testlog`
or use a volumes directive in your docker-compose file to link a local directory

## Execution time

Run testing dmt_tester module

- locally fresh install:        3:23.97 total
- locally with hot database:    1:40.02 total


## Codeship Example

Add these files to the module root and set the TEST_MODULE environmental variable key to your modules name

_codeship-services.yml_

```

# Codeship specific docker compose file for module tester

version: "2"

services:

  app:
    image: pwcsexperiencecenter/drupal-module-tester:latest
    cached: true
    links:
      - mariadb
    ports:
      - "8000"
    environment:
      - TEST_MODULE=REPLACE_WITH_YOUR_MODULE_NAME
    volumes:
      - ./:/opt/app-root/test

  mariadb:
    image: mariadb:latest
    cached: true
    ports:
      - "3306" # Map this dynamically on the ci, as parallel builds require it
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=site
      - MYSQL_USER=dbuser
      - MYSQL_PASSWORD=dbpass
```

_codeship-steps.yml_

```
# MODULE TEST - Codeship Steps
# This is the default configuration file to test a module with
# https://hub.docker.com/r/pwcsexperiencecenter/drupal-module-tester
- name: module_test
  tag: ^(master|develop|feature) #Run all tests on master, develop and feature branches
  service: app
  command: /opt/app-root/test.sh #only runs tests on our module
```

## Using without codeship
If you wanted to use this image locally, or in another ci environment you could do so from your module folder by running
```
docker-compose -f codeship-services.yml run --rm app /opt/app-root/test.sh
```

If you use something like [Dash](https://kapeli.com) you can make a convenient snippet!

Check browser test logs in `/opt/app-root/testlog`, it can be useful to link a local volume to this path to capture output data


## Testing locally

You can easily use this image to quickly iterate over standalone modules. Create a docker-compose.yml in your module folder

```
version: "2"

services:

  #In a local running configuration the db must be called dmtdb as it is expected in the scripts
  dmtdb:
    image: mariadb:latest
    ports:
      # Map this dynamically on the ci, as parallel builds require it
      - "3306"
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=site
      - MYSQL_USER=dbuser
      - MYSQL_PASSWORD=dbpass

  dmt_tester:
    image: pwcsexperiencecenter/drupal-module-tester:refactor
    #cached: true
    links:
      - dmtdb
    ports:
      - 8000:8000
    environment:
      - TEST_MODULE=dmt_tester
    volumes:
      - ./:/opt/app-root/test
      - ../logs:/opt/app-root/testlog
    entrypoint: /opt/app-root/scripts/debug.sh
```

Loading the debug script will hold the container open so that you can ssh in to it and execute the tests.
To execute the test scripts you should instead run
`/opt/app-root/runtime/test.sh`

The easiest way to do this is to use
`docker-compose run my_container_name /opt/app-root/scripts/test.sh`
(running from scripts/test.sh rather than runtime.sh will also do the module install etc...)

If running this multiple times the site will already be installed in the db, which will cause a non fatal error on container start
You will need to recreate the mariadb container to get a fresh install, however this will not affect the tests being run
Running like this will reduce the execution time by ~2m

### DM NOTE
If you use DM you may want to add the dm_bridge network to your local docker-compose file for everything to work properly.

To your docker-compose.yml add
```
networks:
  dm_bridge:
    external: true
```

and to each container definition that needs bridge access add
```
    networks:
        - dm_bridge
```

# How it works

The base image is an install of drupal built from composer. All the basics are provided as well as some nice testing extras.
This should be cachable in your ci, so you only need to build it once.

In the actual testing phase
* a new minimal site installation is created
* your module is installed
* phpunit is run against your module

## Customizing

The base drupal image is built from app/composer.json
So you can very easily create your own custom builds by forking this repo and making changes to that file

If you want to change the scripts run you could mount a custom scripts folder to `opt/app-root/runtime`
and add changes to `test.sh`
`opt/app-root/runtime` must also contain a phpunit.xml file, which will be used to run the tests

## Environmental Variables

The Dockerfile exposes the following environmental variables related to the Drupal configuration
```
ENV DRUPAL_LANGCODE=en \
    DRUPAL_DB_HOST="mariadb" \
    DRUPAL_DB_TYPE="mysql" \
    DRUPAL_DB_NAME="site" \
    DRUPAL_DB_USER="dbuser" \
    DRUPAL_DB_PASS="dbpass" \
    DRUPAL_DB_PORT=3306 \
    DRUPAL_DB_PREFIX="test" \
    DRUPAL_SITE_NAME="Drupal_Module_Tester" \
    DRUPAL_SITE_MAIL="null@void.com" \
    DRUPAL_ACCOUNT_NAME=admin \
    DRUPAL_ACCOUNT_MAIL="null@void.com" \
    DRUPAL_ACCOUNT_PASS="t0t4lly1n53cur3"
```

If you change the database user/pass note that you will also need to reconfigure the mariadb container variables in your codeship-service.yml file

Changing these values will also invalidate the default phpunit.xml file, you will need to additionally set the following environmental variables
```
SIMPLETEST_BASE_URL
SIMPLETEST_DB

```

## Dependencies

The easiest way to add dependencies is via your composer.json

## Debugging

Add this to codeship-steps.yml to hold the local container open using jet

```
########################################################################################################################
# CODESHIP JET - Local Interactive Debugging
#
# These tests only builds the app container and then blocks in order to allow interactive connections.
########################################################################################################################
- name: jet.debug
  tag: jet.debug
  service: app
  command: /opt/app-root/scripts/debug.sh
 ```

### Possible future additions

* include profile that installs behat modules and drupal coder
* include options for code sniffing and changing rulesets
* configure behat and write some tests to prove it works