#!/bin/bash
# This script cross-compiles owncloudcmd for Remarkable Tablet.
# Installing the toolchain:
#   curl https://remarkable.engineering/deploy/sdk/poky-glibc-x86_64-meta-toolchain-qt5-cortexa9hf-neon-toolchain-2.1.3.sh -o install-toolchain.sh
#   chmod +x install-toolchain.sh
#   ./install-toolchain
# See https://remarkablewiki.com/devel/qt_creator for instructions on how to use this with QtCreator.
# For building owncloud we don't need QtCreator, we just build using CMake and Ninja.
# Prerequisites:
#   sudo apt install cmake ninja-build

# Default path to POKY toolchain
POKYDIR=/opt/poky/2.1.3
source $POKYDIR/environment-setup-cortexa9hf-neon-poky-linux-gnueabi
source $POKYDIR/sysroots/x86_64-pokysdk-linux/usr/bin/oe-find-native-sysroot
source $POKYDIR/sysroots/x86_64-pokysdk-linux/environment-setup.d/qt5.sh
export SYSROOTS=$POKYDIR/sysroots

echo OECORE_NATIVE_SYSROOT=$OECORE_NATIVE_SYSROOT
echo OE_QMAKE_PATH_HOST_BINS=$OE_QMAKE_PATH_HOST_BINS

BLDDIR=bldRemarkable
DISTDIR=$PWD/distRemarkable
BUILD_TYPE=Debug
# CMake options
OPTIONS="-GNinja"
# token auth only to avoid Qt5KeyChain dependency
OPTIONS="$OPTIONS -DTOKEN_AUTH_ONLY=on"
# disable GUI stuff we don't need
OPTIONS="$OPTIONS -DBUILD_GUI=off"
OPTIONS="$OPTIONS -DBUILD_SHELL_INTEGRATION=off"
OPTIONS="$OPTIONS -DBUILD_SHELL_INTEGRATION_DOLPHIN=off"
OPTIONS="$OPTIONS -DBUILD_SHELL_INTEGRATION_ICONS=off"
OPTIONS="$OPTIONS -DBUILD_SHELL_INTEGRATION_NAUTILUS=off"
#OPTIONS="$OPTIONS -DCMAKE_PREFIX_PATH=$SYSROOTS/cortexa9hf-neon-poky-linux-gnueabi/usr"
#OPTIONS="$OPTIONS -DQt5_DIR=$SYSROOTS/cortexa9hf-neon-poky-linux-gnueabi/usr/lib/cmake/Qt5"
#OPTIONS="$OPTIONS -DQT_QMAKE_EXECUTABLE=$SYSROOTS/x86_64-pokysdk-linux/usr/bin/qt5/qmake"
# Necessary for Remarkable's Open Embedded Qt version
OPTIONS="$OPTIONS -DOE_QMAKE_PATH_EXTERNAL_HOST_BINS=$OE_QMAKE_PATH_HOST_BINS"
TOOLCHAIN=$PWD/toolchain-linux-yocto-cortex-a9.cmake

# stop on error
set -e
# optional clean build
if [ "$1" == "clean" ]; then
    rm -rf $BLDDIR
fi

mkdir -p $BLDDIR
cd $BLDDIR
[ -f build.ninja ] || cmake $OPTIONS -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$DISTDIR ..
ninja
ninja install

