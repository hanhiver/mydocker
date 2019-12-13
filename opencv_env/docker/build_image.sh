#!/bin/bash -x

DIR=$(cd `dirname $0`; pwd)

CPU_ARCH=$(uname -m)

if [ $CPU_ARCH == "x86_64" ]; then
    image_release_name=ws_build_env
    dockerfile=Dockerfile
else
    echo "Unsupported CPU architecture: $CPU_ARCH"
    exit 1
fi

if [ $VERSION ]; then
    image_release_ver=$VERSION
else
    image_release_ver=dev
fi

# Build release package image
docker build -t ${image_release_name}:${image_release_ver} -f ${dockerfile} .
