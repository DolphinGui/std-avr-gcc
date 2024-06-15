FROM debian:12.5
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y   \
    gcc-12=12.2.0-14     \
    mingw-w64=10.0.0-3   \
    git=1:2.39.2-1.1     \
    wget=1.21.3-1+b2        \
    dtrx=8.4.0-2         \
    autoconf2.64         \
    g++=4:12.2.0-3       \
    dpkg-dev=1.21.22     \
    libc6-dev=2.36-9+deb12u7 \
    make=4.3-4.1         \
    netpbm=2:11.01.00-2   \
    libmpc-dev=1.3.1-1   \
    libmpfr-dev=4.2.0-1  \
    libgmp-dev=2:6.2.1+dfsg1-1.1 \
    libmpfr6=4.2.0-1     \
    texinfo=6.8-6+b1       \
    doxygen=1.9.4-4      \
    flex=2.6.4-8.2  \
    bison=2:3.8.2+dfsg-1+b1 \
    libexpat1-dev=2.5.0-1 \
    slang-xfig=0.2.0~.136-2 \
    meson=1.0.1-5        \
    ninja-build=1.11.1-1 \
    pkg-config=1.8.1-1
RUN   apt-get clean \
       && rm -rf /var/lib/apt/lists/*

ADD avr.sh avr.sh
ADD work.sh work.sh
ADD patches patches
ADD apply-paches.sh apply-patches.sh
ADD meson-windows.txt meson-windows.txt