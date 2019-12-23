#!/bin/bash
set -ex

PWD1="/tmp/opencv"
#apt-get update
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends liblapacke-dev

### install developer tools
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential checkinstall cmake pkg-config
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git gfortran
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends

### install image I/O packages for loading various image file formats from disk
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libjpeg8-dev libpng-dev

#add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
#apt install libjasper1 libjasper-dev

###  GTK development library to build Graphical User Interfaces
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libgtk-3-dev libtbb-dev qt5-default

### Other dependcies
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libdc1394-22-dev
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libatlas-base-dev liblapacke-dev
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libmp3lame-dev libtheora-dev
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libxvidcore-dev libx264-dev
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libopencore-amrnb-dev libopencore-amrwb-dev
#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libgphoto2-dev libeigen3-dev libhdf5-dev doxygen x264 v4l-utils

#DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev pylint

#rm -rf /var/lib/apt/lists/*

#git clone https://github.com/opencv/opencv.git
#git clone https://github.com/opencv/opencv_contrib.git opencv/opencv_contrib

#pip install wheel
#pip install setuptools
#pip install numpy
cd /tmp/opencv 

ls -l 
#copy the opencv source code instead of git download. 
#tar -xvf opencv.tar.gz 

cd opencv
#git checkout 3.2.0
#cd opencv_contrib
#git checkout 3.2.0
#cd ..

cp /tmp/OpenCVFindLAPACK.cmake cmake/
cp /tmp/FindCUDA.cmake cmake/
cp /tmp/OpenCVDetectCUDA.cmake cmake/

mkdir -p build
cd build
sed -i '/cuda_stream_accessor.hpp/a #include "cuda_fp16.h"'  ../modules/cudev/include/opencv2/cudev/common.hpp

cmake \
-DCMAKE_BUILD_TYPE=None \
-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON \
-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON \
-DCMAKE_C_FLAGS_RELEASE="-g -O3 -fdebug-prefix-map=${PWD1}/opencv=. -fstack-protector-strong -Wformat -Werror=format-security" \
-DCMAKE_CXX_FLAGS_RELEASE="-g -O3 -fdebug-prefix-map=${PWD1}/opencv=. -fstack-protector-strong -Wformat -Werror=format-security" \
-DCMAKE_EXE_LINKER_FLAGS_RELEASE="-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now"  \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_EXAMPLES=ON \
-DINSTALL_C_EXAMPLES=ON \
-DINSTALL_PYTHON_EXAMPLES=ON \
-DWITH_FFMPEG=ON \
-DWITH_GSTREAMER=OFF \
-DWITH_GTK=ON \
-DWITH_JASPER=OFF \
-DWITH_JPEG=ON \
-DWITH_PNG=ON \
-DWITH_TIFF=ON \
-DWITH_OPENEXR=ON \
-DWITH_PVAPI=ON \
-DWITH_UNICAP=OFF \
-DWITH_EIGEN=ON \
-DWITH_VTK=ON \
-DWITH_GDAL=ON \
-DWITH_GDCM=ON \
-DWITH_XINE=OFF \
-DWITH_IPP=OFF \
-DBUILD_TESTS=OFF \
-DCMAKE_SKIP_RPATH=ON \
-DWITH_CUDA=ON \
-DENABLE_PRECOMPILED_HEADERS=OFF -DWITH_IPP=OFF \
-DWITH_CAROTENE=OFF \
-DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules/ \
-DWITH_TBB=ON \
-DWITH_V4L=ON \
-DCMAKE_SHARED_LINKER_FLAGS_RELEASE="-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now" \
-DBUILD_SHARED_LIBS=ON \
-DBUILD_DOCS=ON \
-DWITH_OPENGL=ON  \
-DLAPACKE_H_PATH=/usr/include \
-DCUDA_CUDA_LIBRARY=/usr/local/cuda/lib64/stubs/libcuda.so \
../ 

rm -rf ../opencv_contrib/modules/cnn_3dobj
make -j16
make install
cd ../..
