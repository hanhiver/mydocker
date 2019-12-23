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

git checkout 4.1.2
cd opencv_contrib
git checkout 4.1.2
cd ..

mkdir -p build
cd build

cmake \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr/local \
-DOPENCV_GENERATE_PKGCONFIG=ON \
-DOPENCV_EXTRA_MODULES_PATH=/tmp/opencv/opencv_contrib/modules \
-DBUILD_DOCS=ON \
-DBUILD_EXAMPLES=ON \
-DINSTALL_C_EXAMPLES=ON \
-DWITH_GSTREAMER=ON \
-DOPENCV_ENABLE_NONFREE=ON \
-DBUILD_opencv_python2=OFF \
-DBUILD_opencv_python3=OFF \
-DWITH_LAPACK=ON \
-DWITH_EIGEN=ON \
-DWITH_OPENGL=ON \
-DWITH_CUDA=ON \
-WITH_CUFFT=ON \
-DWITH_CUBLAS=ON \
-DWITH_CUDNN=ON \
-WITH_NVCUVID=ON \
../ 

make -j16
make install
cd ../..

rm -rf /tmp/opencv 

