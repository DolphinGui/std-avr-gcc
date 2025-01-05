FROM ubuntu:jammy
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y   \
    gcc-12   \
    mingw-w64   \
    git    \
    wget    \
    atool        \
    autoconf2.64         \
    g++     \
    libc6-dev \
    make         \
    libmpc-dev   \
    libmpfr-dev  \
    libgmp-dev \
    libmpfr6     \
    texinfo       \
    flex \
    bison \
    zstd \
    parallel

RUN   apt-get clean \
       && rm -rf /var/lib/apt/lists/*

ADD avr.sh avr.sh
ADD work.sh work.sh
ADD patches patches
ADD apply-paches.sh apply-patches.sh
