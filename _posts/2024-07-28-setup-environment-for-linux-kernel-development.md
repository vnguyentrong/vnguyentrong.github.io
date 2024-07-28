---
title: Beaglebone - Setup environment for Linux kernel development
author: vnguyentrong
date: 2024-07-28 05:24 PM +07
categories: [environment]
tags: [environment,linux-kernel,beaglebone]

---

## Setup Docker

1. Setup docker repository:

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

2. Install docker packages:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

3. Verify docker installation:

```bash
sudo docker run hello-world
```

4. Configure docker runs with non-root users

```bash
# Add the docker group if it doesn't already exist.
sudo groupadd docker

# Add the connected user "$USER" to the docker group.
sudo gpasswd -a $USER docker

# run Docker without sudo.
docker run hello-world
```

## Create Docker image to build Linux kernel

1. Create a docker file

- Docker image is based on ubuntu 22.04.

```bash
# Description: Docker image for building linux kernel for beaglebone black
# Author     : vnguyentrong
# Date       : Mar 14, 2024

FROM ubuntu:22.04

ENV BRANCH 2.2
ENV RSTUDIO 1.4.1103

ENV DEBIAN_FRONTEND noninteractive

# Install.
RUN \
  apt-get update && \
  apt-get install -y make pkg-config locales apt-utils && \
  useradd -ms /bin/bash vinhnt && \
  apt-get install sudo vim git cmake tree bash-completion -y

RUN echo "root:1" | chpasswd

RUN echo "vinhnt:1" | chpasswd

RUN usermod -aG sudo vinhnt

# git configuration
RUN git config --global user.name "Vinh Nguyen Trong" && \
    git config --global user.email "vinhnt2410@gmail.com"

RUN echo "alias gs='git status'" >> /home/vinhnt/.bashrc && \
    echo "alias gb='git branch'" >> /home/vinhnt/.bashrc

# install dependencies
RUN \
  apt-get update && \
  apt-get install python3-pip -y && \
  apt-get install gcc-arm-linux-gnueabihf flex bison bc libssl-dev -y && \
  apt-get install kmod -y

```

## Build and run docker image

```bash
# build docker image
docker build -t bb-kernel-build .

# run docker image
docker run --rm -it --hostname u22 --user vinhnt --name ubuntu -v $HOME:/home/vinhnt bb-kernel-build:latest /bin/bash

```

## Build Linux kernel for beaglebone

1. Clone source code from github: [Linux source for beaglebone](https://github.com/beagleboard/linux)

I'm using my forked repo: [vnguyentrong/linux_bb](https://github.com/vnguyentrong/linux_bb)

2. Build Linux kernel

First we need to run the docker Image, then go to the Linux folder to build Linux kernel

```bash

################################################################################
# export ARCH=arm
# export CROSS_COMPILE=arm-linux-gnueabihf-
# help 
# make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -h

# make .config
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- omap2plus_defconfig

# make image, modules, dtbs
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules -j4
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs -j4
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=modules modules_install

```

3. Replace the kernel and modules to the beaglebone target
