#!/usr/bin/env bash

source /opt/app-root/scripts/util/hostname.sh

if [ "$BOOTSTRAP" == "true" ]; then
    source /opt/app-root/scripts/util/bootstrap.sh
fi

source /opt/app-root/scripts/util/hold.sh