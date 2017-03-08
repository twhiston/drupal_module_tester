#!/bin/bash

echo "--- Drupal 8 Docker Module Tester ---"
echo "  By PwC's Experience Center Zurich "

export_vars=$(cgroup-limits); export $export_vars

php-fpm
nginx -c /opt/app-root/etc/conf.d/nginx/nginx.conf