#!/bin/bash

# vim: tabstop=4 shiftwidth=4 softtabstop=4
# -*- sh-basic-offset: 4 -*-
#
# GITHUB BUILD PIPELINE - OS PREPARATION

# Pipeline build parameters are unavailable here
echo "BUILD PIPELINE - OS PREPARATION..."
echo "OS: $OS_NAME:$OS_RELEASE"
OS_VERSION_ID=$(cat /etc/os-release 2>/dev/null | grep ^VERSION_ID= | cut -f2 -d'=')

# Install build dependencies if Qt source/tarball defined
QT_DEV=
if [ -n "$QT_VERSION" ]; then
    QT_DEV=yes
elif [ -f "/var/tmp/"qt-everywhere-src-*.tar.* ]; then
    QT_DEV=yes
fi
if [ -n "$NO_QT_BUILD" ]; then
    QT_DEV=
fi

if [ "$OS_NAME" = "debian/eol" ]; then
    # jessie = 8
    DEBIAN_VERSION=$(cat /etc/debian_version | cut -f1 -d'.') # 8

    # Add newer Debian repositories because Debian 8 is too old
    # We want to keep old Debian libraries
    # Specifically, we need a newer gcc (version > 4)
    printf "deb http://deb.debian.org/debian/ stretch main contrib non-free" >/etc/apt/sources.list.d/stretch.list && \
    echo "" >/etc/apt/preferences.d/backports && \
    printf "Package: *\nPin: release a=jessie-backports\nPin-Priority: 650\n\n" >>/etc/apt/preferences.d/backports && \
    printf "Package: *\nPin: release a=stretch\nPin-Priority: 100\n\n" >>/etc/apt/preferences.d/backports && \
    printf "Package: *\nPin: origin deb.debian.org\nPin-Priority: 100\n\n" >>/etc/apt/preferences.d/backports
    sed -i 's/main$/main contrib non-free/g' /etc/apt/sources.list

    # Build essentials
    apt-get update && \
    apt-get install -y \
    flex bison gperf libicu-dev libxslt-dev ruby \
    libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev gperf bison nodejs \
    wget libclang-dev vim

    # MariaDB etc.
    apt-get install -y default-libmysqlclient-dev \
    libssl-dev libjasper-dev unixodbc-dev libmng-dev libpqxx-dev

    # OpenGL (optional)
    # ERROR: The OpenGL functionality tests failed!
    apt install -y -t stretch libgl1-mesa-dev libglu1-mesa-dev \
    '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
    libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev
    # E: Unable to locate package libgstreamer-plugins-good1.0-dev

    # gcc in jessie-backports is too old (version 4)
    apt-get install -y -t stretch build-essential perl python3 git g++



elif [ "$OS_NAME" = "debian" ]; then
    DEBIAN_VERSION=$(cat /etc/debian_version | cut -f1 -d'.') # 8

    if [ -n "$QT_DEV" ]; then
        # Build essentials
        apt-get update && \
        apt-get install -y \
        flex bison gperf libicu-dev libxslt-dev ruby \
        libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev gperf bison nodejs \
        wget libclang-dev vim

        # MariaDB etc.
        apt-get install -y default-libmysqlclient-dev \
        libssl-dev libjasper-dev unixodbc-dev libmng-dev libpqxx-dev

        # OpenGL (optional)
        # ERROR: The OpenGL functionality tests failed!
        apt install -y libgl1-mesa-dev libglu1-mesa-dev \
        '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
        libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev
        # E: Unable to locate package libgstreamer-plugins-good1.0-dev

        # gcc in jessie-backports is too old (version 4)
        apt-get install -y build-essential perl python3 git g++

    else
        apt-get install -y build-essential perl python3 git g++
        apt-get install -y qtbase5-dev
    fi



elif [ "$OS_NAME" = "ubuntu" ]; then
    DEBIAN_VERSION=$(cat /etc/debian_version | cut -f1 -d'.') # 8

    if [ -n "$QT_DEV" ]; then
        # build-dep
        # Build essentials
        apt-get update && \
        apt-get install -y \
        flex bison gperf libicu-dev libxslt-dev ruby \
        libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev gperf bison nodejs \
        wget libclang-dev vim

        # MariaDB etc.
        apt-get install -y default-libmysqlclient-dev \
        libssl-dev libjasper-dev unixodbc-dev libmng-dev libpqxx-dev

        # OpenGL (optional)
        # ERROR: The OpenGL functionality tests failed!
        apt install -y libgl1-mesa-dev libglu1-mesa-dev \
        '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
        libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev
        # E: Unable to locate package libgstreamer-plugins-good1.0-dev

        # gcc in jessie-backports is too old (version 4)
        apt-get install -y build-essential perl python3 git g++

    else
        # qtbase5-dev installs /usr/bin/qmake
        apt-get install -y build-dep perl python3 git g++
        apt-get install -y qtbase5-dev
    fi



elif [ "$OS_NAME" = "fedora" ]; then
    FEDORA_VERSION=$OS_VERSION_ID

    if [ -n "$QT_DEV" ]; then
        # Build essentials
        yum install -y \
        perl-version git gcc-c++ compat-openssl10-devel harfbuzz-devel double-conversion-devel libzstd-devel at-spi2-atk-devel dbus-devel mesa-libGL-devel

        # Libxcb
        yum install -y \
        libxcb libxcb-devel xcb-util xcb-util-devel xcb-util-*-devel libX11-devel libXrender-devel libxkbcommon-devel libxkbcommon-x11-devel libXi-devel libdrm-devel libXcursor-devel libXcomposite-devel

        # Multimedia
        yum install -y \
        pulseaudio-libs-devel alsa-lib-devel gstreamer1-devel gstreamer1-plugins-base-devel wayland-devel

        # WebKit
        yum install -y \
        flex bison gperf libicu-devel libxslt-devel ruby

        # WebEngine
        yum install -y \
        freetype-devel fontconfig-devel pciutils-devel nss-devel nspr-devel ninja-build gperf cups-devel pulseaudio-libs-devel libcap-devel alsa-lib-devel bison libXrandr-devel libXcomposite-devel libXcursor-devel libXtst-devel dbus-devel fontconfig-devel alsa-lib-devel rh-nodejs12-nodejs rh-nodejs12-nodejs-devel

    else
        yum install -y perl python3 git g++
        yum install -y qt5-qtbase
    fi
fi

OS_ID=$(cat /etc/os-release | grep ^ID | cut -f2 -d'=')
echo "$OS_ID"

#if (which apt-get && -n "$APT_INSTALL") >/dev/null 2>&1; then
#    echo "Installing other dependencies: $APT_INSTALL"
#    for p in $APT_INSTALL; do
#        apt-get install -y "$p" || exit $?
#    done
#fi
#if [ -n "$YUM_INSTALL" ] && (which yum >/dev/null 2>&1); then
#    echo "Installing other dependencies: $YUM_INSTALL"
#    for p in $YUM_INSTALL; do
#
#        if [[ $p != */* ]]; then
#            echo "Installing: $p"
#            yum install -y "$p" || exit $?
#        else
#            # variant1/variant2
#            echo "Installing any of $p..."
#            for i in $(echo $p | tr "/" "\n"); do
#                echo "Trying to install: $i"
#                if yum info "$i" >/dev/null 2>&1; then
#                    yum install -y "$i" || exit $?
#                    break
#                else
#                    echo "Optional package not found: $i"
#                fi
#            done
#        fi
#
#    done
#fi

