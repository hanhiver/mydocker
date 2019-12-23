#!/bin/bash

# Destroy a local development environment.
# The docker container name is <dev-name>

set -e

if [ ! $1 ]
then
    echo "usage: $0 <dev-name>"
    exit 1
fi

# destroy docker container as development environment.
# TODO: take care of GPU resource and volume injection.
docker rm -f $1
