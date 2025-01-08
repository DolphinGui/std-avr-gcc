FROM crossbuild:latest
# modified from https://github.com/rleh/docker-avr-gcc/tree/master
LABEL maintainer="Shin Umeda <umeda.shin@gmail.com>"
LABEL Description="Image for building AVR GCC toolchain"
WORKDIR /work

COPY avr.sh avr.sh
COPY work.sh work.sh
COPY patches patches
COPY apply-paches.sh apply-patches.sh

