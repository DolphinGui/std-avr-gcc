FROM debian:12.5
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y      gcc-12
RUN apt-get install -y      mingw-w64
RUN apt-get install -y      git
RUN apt-get install -y      wget
RUN apt-get install -y      dtrx
RUN apt-get install -y      autoconf2.64
RUN apt-get install -y      build-essential
RUN apt-get install -y      netpbm
RUN apt-get install -y      libmpc-dev
RUN apt-get install -y      libmpfr-dev
RUN apt-get install -y      libgmp-dev
RUN apt-get install -y      libmpfr6
RUN apt-get install -y      texinfo
RUN apt-get install -y      doxygen
RUN apt-get install -y      flex
RUN apt-get install -y      bison
RUN apt-get install -y      libexpat1-dev
RUN apt-get install -y      slang-xfig
RUN apt-get install -y      meson
RUN apt-get install -y      ninja-build
RUN apt-get install -y      pkg-config
RUN apt-get install -y      libz-dev
RUN apt-get install -y      libz-mingw-w64-dev
RUN   apt-get clean \
       && rm -rf /var/lib/apt/lists/*

ADD avr.sh avr.sh
ADD work.sh work.sh
ADD patches patches
ADD apply-paches.sh apply-patches.sh
ADD fae.sh fae.sh
ADD faework.sh faework.sh
ADD meson-windows.txt meson-windows.txt