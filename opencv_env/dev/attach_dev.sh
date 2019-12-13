#!/bin/bash

# Attach to local development environment.
# You can also use "docker exec -it <dev-name> /bin/bash" to attach to local development environment.

set -e

ROOT_DIR=$(cd `dirname $0`/..; pwd)

if [ ! $1 ]
then
    echo "usage: $0 <dev-name>"
    exit 1
fi

docker exec -it $1 /bin/bash

