FROM  ghcr.io/shepherdjerred/macos-cross-compiler:latest
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y   \
    gcc-12  \
    mingw-w64  \
    git  \
    wget  \
    autoconf2.64         \
    g++  \
    dpkg-dev  \
    libc6-dev  \
    make  \
    libmpc-dev  \
    libmpfr-dev  \
    libgmp-dev  \
    libmpfr6  \
    texinfo  \
    flex  \
    bison \
    atool \
    parallel
RUN   apt-get clean \
       && rm -rf /var/lib/apt/lists/*

COPY avr.sh avr.sh
COPY work.sh work.sh
COPY patches patches
COPY apply-paches.sh apply-patches.sh
COPY out /out
