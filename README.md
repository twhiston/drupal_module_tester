# Drupal Module Tester

Drupal 8 project for PHPUnit testing modules with docker quickly.

[ ![Codeship Status for ibrows/drupal_module_tester](https://app.codeship.com/projects/4bc3b300-e670-0134-b09a-26edd27a570b/status?branch=master)](https://app.codeship.com/projects/206815)

THIS DOES NOT RUN SIMPLETESTS!!!

# How to use

If you use codeship it's easy.


## Codeship Example

Add this file to the module root and set the TEST_MODULE environmental variable key to your modules name

codeship-services.yml

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

codeship-steps.yml

Simply add this file to your module root

```
# MODULE TEST - Codeship Steps
# This is the default configuration file to test a module with
# https://hub.docker.com/r/pwcsexperiencecenter/drupal-module-tester
- name: module_test
  tag: ^(master|develop|feature) #Run all tests on master, develop and feature branches
  service: app
  command: /opt/app-root/test.sh #only runs tests on our module
```

# How it works

The base image is an install of drupal built from composer. All the basics are provided as well as some nice testing extras.
This should be cachable in your ci, so you only need to build it once.

In the actual testing phase
* a new minimal site installation is created
* your module is installed
* phpunit is run against your modules folder

## Customizing

The base drupal image is built from app/composer.json
So you can very easily create your own custom builds by forking this repo and making changes to that file

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
  command: /opt/app-root/services.sh
 ```

## TODO

* include profile that installs behat modules and drupal coder
* include options for code sniffing and changing rulesets