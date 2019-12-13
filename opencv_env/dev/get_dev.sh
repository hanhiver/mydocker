# !/bin/bash
# *****************************************************************
#
# IBM Confidential
# OCO Source Materials
#
# (C) Copyright IBM Corp. 2017
#
# The source code for this program is not published or otherwise
# divested of its trade secrets, irrespective of what has been
# deposited with the U.S. Copyright Office.
#
# *****************************************************************

# Pull one docker image to docker repository

set -e

DOCKER_REPO=harbor.sl.cloud9.ibm.com
DOCKER_REPO_NS=hkaa

CPU_ARCH=$(uname -m)

if [ $CPU_ARCH == "x86_64" ]; then
    IMAGE_NAME=ws_build_env
else
    echo "Unsupported CPU architecture: $CPU_ARCH"
    exit 1
fi

IMAGE_TAG=dev

docker pull $DOCKER_REPO/$DOCKER_REPO_NS/$IMAGE_NAME:$IMAGE_TAG
docker tag $DOCKER_REPO/$DOCKER_REPO_NS/$IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:$IMAGE_TAG
docker rmi $DOCKER_REPO/$DOCKER_REPO_NS/$IMAGE_NAME:$IMAGE_TAG
