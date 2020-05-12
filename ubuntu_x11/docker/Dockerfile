FROM ubuntu:18.04
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
    vim \
    openssh-server \
    unzip \
    dnsutils \
    iputils-ping \
    net-tools \
    tcpdump \
    ethtool \
    iproute2 \
    x11-apps \
    iftop htop && \
    rm -rf /var/lib/apt/lists/*

ADD ssh_config /etc/ssh/
ADD sshd_config /etc/ssh/
RUN service ssh start

