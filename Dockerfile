FROM ubuntu:22.04
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y
RUN apt-get install -y        mingw-w64
RUN apt-get install -y             git
RUN apt-get install -y             wget
RUN apt-get install -y             dtrx
RUN apt-get install -y             autoconf2.64
RUN apt-get install -y         build-essential
RUN apt-get install -y         netpbm
RUN apt-get install -y         libmpc-dev
RUN apt-get install -y         libmpfr-dev
RUN apt-get install -y      libgmp-dev
RUN apt-get install -y      libmpfr6
RUN apt-get install -y      texinfo
RUN apt-get install -y      doxygen
RUN apt-get install -y      flex
RUN apt-get install -y      bison
RUN apt-get install -y      libexpat1-dev
RUN apt-get install -y      slang-xfig
RUN   apt-get clean \
       && rm -rf /var/lib/apt/lists/*

ADD avr.sh avr.sh
ADD avr-win.sh avr-win.sh

