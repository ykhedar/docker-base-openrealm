#!/bin/bash
set -ex
export DEBIAN_FRONTEND=noninteractive

cd ~ && git clone -b 3.3.1 https://github.com/opencv/opencv.git \
&& cd ~/opencv && mkdir build && cd build \
&& cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. \
&& make && make install && cd ~ && rm -rf opencv/*