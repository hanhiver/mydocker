#!/bin/bash

# Create a local development environment.
# The docker container name is <dev-name>
set -x
set -e

ROOT_DIR=$(cd `dirname $0`/..; pwd)
DEV_DIR=$ROOT_DIR/dev
DNN_ROOT=/opt/ws_build

if [ ! $1 ]
then
    echo "usage: $0 <dev-name>"
    exit 1
fi

CPU_ARCH=$(uname -m)

if [ $CPU_ARCH == "x86_64" ]; then
    IMAGE_NAME=ws_build_env
else
    echo "Unsupported CPU architecture: $CPU_ARCH"
    exit 1
fi

if [ $VERSION ]; then
    IMAGE_TAG=$VERSION
else
    IMAGE_TAG=dev
fi

GPU_DRIVER_VERION=$(nvidia-smi | grep Driver | awk '{print $3}')
GPU_DRIVER_PATH=$DEV_DIR/nvidia-driver/$GPU_DRIVER_VERION

# detect and collect GPU driver volume
if [ -d $GPU_DRIVER_PATH ] && [ $(ls $GPU_DRIVER_PATH | wc -l) != 0 ]
then
    echo "GPU driver volume $GPU_DRIVER_PATH already exists, skip re-collecting..."
else
    echo "Collecting GPU driver volume on $GPU_DRIVER_PATH..."
    $DEV_DIR/gpu_driver_collect.sh $GPU_DRIVER_PATH
fi

# create docker container as development environment.
# TODO: take care of GPU resource and volume injection.
docker run -idt \
    --net=host \
    -v $ROOT_DIR:$DNN_ROOT:rw,z \
    --name $1 \
    --env DEV=true \
    --device /dev/nvidia0:/dev/nvidia0:mrw \
    --device /dev/nvidiactl:/dev/nvidiactl:mrw \
    --device /dev/nvidia-uvm:/dev/nvidia-uvm:mrw \
    --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    -v $GPU_DRIVER_PATH:/usr/local/nvidia:ro,z \
    $IMAGE_NAME:$IMAGE_TAG \
    /bin/bash
