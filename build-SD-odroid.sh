#!/bin/bash

# Batch creation of NextCloudPlus image for the Odroid HC1
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage: ./build-SD-odroid.sh <DHCP QEMU image IP>
#

set -e

# get armbian
[[ -d armbian ]] || git clone https://github.com/armbian/build armbian

# get NCP modifications
mkdir -p armbian/userpatches
wget https://raw.githubusercontent.com/nextcloud/nextcloudpi/master/armbian.sh \
  -O armbian/userpatches/customize-image.sh

# generate image
armbian/compile.sh docker \
  BOARD=odroidxu4\
  BRANCH=next\
  KERNEL_ONLY=no\
  KERNEL_CONFIGURE=no\
  RELEASE=stretch\
  BUILD_DESKTOP=no\
  CLEAN_LEVEL=""\
  USE_CCACHE=yes\
  NO_APT_CACHER=no

# pack image
IMGNAME="NextCloudPlus_OdroidHC2_$( date  "+%m-%d-%y" )"
IMGFILE="$( ls -1t armbian/output/images/*.img | head -1 )"
pack_image "$IMGFILE" "$IMGNAME.img" 

# testing
# TODO

# uploading
create_torrent "${IMGNAME}.tar.bz2"
upload_ftp "$IMGNAME" || true
