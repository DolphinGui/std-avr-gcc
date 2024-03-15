FROM ubuntu:22.04
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        git \
        wget \
        autoconf2.64 \
        build-essential \
        netpbm \
        libmpc-dev \
        libmpfr-dev \
        libgmp-dev \
        libmpfr6 \
        texinfo \
        doxygen \
        flex \
        bison \
        libexpat1-dev \
        slang-xfig \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD avr.sh avr.sh
ADD avr-win.sh avr-win.sh
RUN sh avr.sh

