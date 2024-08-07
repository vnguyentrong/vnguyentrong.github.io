---
title: "android: Setup environment to build drm_hwcomposer"
description: >-
    Setup environment and build drm-hwcomposer
date: 2024-08-07 10:41 PM +07
categories: [android,hwcomposer]
tags: [android,graphic,drm_hwcomposer]
post_asset: https://github.com/vnguyentrong/vnguyentrong.github.io/blob/icode_master/_posts/assets/2024-08-07-setup-environment-drm-hwcomposer
---

## About drm_hwcomposer

drm-hwcomposer is a hardware composer module for Android that uses the Direct Rendering Manager (DRM) subsystem in the Linux kernel. It is an alternative to the standard Android Hardware Composer (HWC) and is designed to work on devices that use DRM for graphics display management.

[source on gitlab.freedesktop](https://gitlab.freedesktop.org/drm-hwcomposer/drm-hwcomposer)

Currently, merge request for drm-hwcomposer3 is available here
[drm-hwcomposer3-merge-request](https://gitlab.freedesktop.org/drm-hwcomposer/drm-hwcomposer/-/merge_requests/238)

## Setup environment for development


```bash

git clone git@gitlab.freedesktop.org:vnguyentrong/drm-hwcomposer.git

cd drm-hwcomposer

# type make to see make options
make

# make with ci_fast
make ci_fast

```

```txt
vinhnt@u22:~/work/drm-hwcomposer$ make
  help            Show this help
  prepare         Build and run Docker image
  shell           Start shell into a container
  ci_fast         Run meson build for arm64 in docker container
  ci              Run presubmit within the docker container
  ci_cleanup      Cleanup after 'make ci'
  build_deploy    Build for Andoid and deploy onto the target device (require active adb device connected)
  bd              Alias for build_deploy
vinhnt@u22:~/work/drm-hwcomposer$ 
```

After build successfully, the output should be:
```txt
...
[0/1] Installing files.
Installing hwc2_device/hwcomposer.drm.so to /home/user/aospless/install/vendor/lib64/hw
Installing hwc3/android.hardware.composer.hwc3-service.drm to /home/user/aospless/install/vendor/bin/hw
Installing /home/user/aospless/build/hwc3/hwc3-drm.rc to /home/user/aospless/install/vendor/etc/init
Installing /home/user/aospless/build/hwc3/hwc3-drm.xml to /home/user/aospless/install/vendor/etc/vintf/manifest
make: Leaving directory '/home/user/aospless'

```

To check the output:

```bash
# run docker
make shell

# go to docker container: user@u22:~/drm_hwcomposer$
find /home/user/aospless/install/* -type f

```
output should be:

```txt
user@u22:~/drm_hwcomposer$ find /home/user/aospless/install/* -type f
/home/user/aospless/install/vendor/etc/vintf/manifest/hwc3-drm.xml
/home/user/aospless/install/vendor/etc/init/hwc3-drm.rc
/home/user/aospless/install/vendor/bin/hw/android.hardware.composer.hwc3-service.drm
/home/user/aospless/install/vendor/lib64/hw/hwcomposer.drm.so
user@u22:~/drm_hwcomposer$
```
