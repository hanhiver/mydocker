FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Dong HAN

# setup GPU driver library env, needs only for CUDA image >= 10.0
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# install dependency
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    wget \
    git \
    vim \
    cmake \
    build-essential \
    libboost-all-dev \
    openssh-server \
    libgflags-dev \
    libprotobuf-dev \
    libgoogle-glog-dev \
    protobuf-compiler \
    libssl-dev \
    libwebsocketpp-dev \
    zlib1g-dev \
    libopenblas-dev \
    libeigen3-dev \
    autoconf automake libtool curl make g++ python-pip  \
    libcurl4-openssl-dev libjansson-dev libjansson4 libcurl4  \
    unzip \
    libavformat-dev \
    liblapacke-dev build-essential checkinstall \
    cmake pkg-config git gfortran libjpeg8-dev \
    libpng-dev libgtk-3-dev libtbb-dev qt5-default \
    libavcodec-dev libavformat-dev libswscale-dev \
    libv4l-dev libdc1394-22-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libatlas-base-dev \
    liblapacke-dev libmp3lame-dev libtheora-dev \
    libxvidcore-dev libx264-dev libopencore-amrnb-dev \
    libopencore-amrwb-dev libgphoto2-dev libeigen3-dev \
    libhdf5-dev doxygen x264 v4l-utils python-dev \
    python-numpy libtbb2 libtbb-dev libjpeg-dev \
    libpng-dev libtiff-dev pylint \
    dnsutils \
    iputils-ping \
    net-tools \
    tcpdump \
    ethtool \
    mtr \
    iproute2 \
    x11-apps \
    iftop && \
    rm -rf /var/lib/apt/lists/*

RUN pip install wheel
RUN pip install setuptools
RUN pip install numpy

#build opencv from source
#ADD OpenCVFindLAPACK.cmake /tmp/OpenCVFindLAPACK.cmake
#ADD FindCUDA.cmake /tmp/FindCUDA.cmake
#ADD OpenCVDetectCUDA.cmake /tmp/OpenCVDetectCUDA.cmake
#ADD warp_shuffle.hpp /tmp/warp_shuffle.hpp
#ADD shuffle.hpp /tmp/shuffle.hpp

RUN mkdir -p /tmp/opencv

#copy the opencv source code instead of git download. 
ADD opencv_clean_2019.12.22.tar.gz /tmp 

ADD build_opencv.sh /tmp/build_opencv.sh

RUN cd /tmp/opencv && \
    cp /tmp/build_opencv.sh . 
#    cp /tmp/build_opencv.sh ./ && \
#    ./build_opencv.sh 

#RUN rm -rf /tmp/opencv/opencv

ADD start_app.sh /start_app.sh

# make image be compatible with NVIDIA device plugin
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility

# default command
CMD /start_app.sh


