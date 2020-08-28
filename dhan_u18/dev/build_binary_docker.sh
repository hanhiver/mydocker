#!/bin/bash

MOUNT_ROOT=/opt/opencv_env
BUILD_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" >/dev/null 2>&1 && pwd )"
BUILD_DOCKER="build_opencv"

if [ x${BINARY_OUTPUT_PATH} == x ]; then
    BINARY_OUTPUT_PATH=${BUILD_ROOT}/output
    if [ ! -d ${BINARY_OUTPUT_PATH} ]; then
        mkdir -p ${BINARY_OUTPUT_PATH}
    fi
fi

# update docker image.
cd ${BUILD_ROOT}/docker
mkdir lib bin configs labelmap
VERSION="build" ./build_image.sh
rm -r lib bin configs labelmap

cd ${BUILD_ROOT}/dev
VERSION="build" ./create_dev.sh $BUILD_DOCKER

docker rm -f $BUILD_DOCKER
exit $ret
