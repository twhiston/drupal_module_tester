# Drupal Module Tester

Drupal 8 project for testing modules with docker quickly.

# How to use

If you use codeship it's easy.



If not then your ci config is up to you but the basics are:


# How it works

The base image is an install of drupal built from composer. All the basics are provided as well as some nice testing extras.

This is all installed during the docker image phase, which means that the site is immediately ready for installation and usage in your testing

# Customizing

The base drupal image is built from app/composer.json
So you can very easily create your own custom builds by forking this repo and making changes to that file


# TODO

* include profile that installs behat modules and drupal coder