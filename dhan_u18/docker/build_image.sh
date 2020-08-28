#!/bin/bash -x

DIR=$(cd `dirname $0`; pwd)

CPU_ARCH=$(uname -m)

if [ $CPU_ARCH == "x86_64" ]; then
    image_release_name=dhan_u18
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
docker build --network host \
    --build-arg https_proxy=$https_proxy --build-arg http_proxy=$http_proxy \
    --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTP_PROXY \
    --build-arg NO_PROXY=$NO_PROXY  --build-arg no_proxy=$no_proxy \
    -t ${image_release_name}:${image_release_ver} -f ${dockerfile} .

# -t ${image_release_name}:${image_release_ver} -f ${dockerfile} .
