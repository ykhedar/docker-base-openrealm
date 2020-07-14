#!/bin/bash
#set -ex

# Check CMake version and update if necessary
OUTPUT=$(cmake --version)
read CMAKE_VERSION_MAJOR CMAKE_VERSION_MINOR CMAKE_VERSION_PATCH <<< ${OUTPUT//[^0-9]/ }

if [ "${CMAKE_VERSION_MINOR}" -le 9 ]; then

  echo 'CMake Version is too old! Trying to download newer version '

  CMAKE_FILE="cmake-3.10.3-Linux-x86_64"

  # Check if file already exists
  if [ ! -e "${CMAKE_FILE}.tar.gz" ]; then
    wget https://cmake.org/files/v3.10/${CMAKE_FILE}.tar.gz
  fi

  # Remove existing unpacked cmake folder
  if [ -d "${CMAKE_FILE}" ]; then
    rm -r ${CMAKE_FILE}
  fi

  tar xvzf ${CMAKE_FILE}.tar.gz

  export PATH="`pwd`/${CMAKE_FILE}/bin:$PATH"
fi
export DEBIAN_FRONTEND=noninteractive
# Update the Apt Cache
apt-get update

# General packages
apt-get install -y -q --no-install-recommends apt-utils ca-certificates lsb-release gnupg2 curl libproj-dev

#sudo apt-get install -y -q libopencv-dev
# Eigen3 for several linear algebra problems
apt-get install -y -q --no-install-recommends libeigen3-dev

# Gdal library for conversions between UTM and WGS84
apt-get install -y -q --no-install-recommends gdal-bin

# Cgal library for delauney 2.5D triangulation and mesh creation
apt-get install -y -q --no-install-recommends libcgal-dev
apt-get install -y -q --no-install-recommends libcgal-qt5-dev

# PCL for writing point clouds and mesh data
apt-get install -y -q --no-install-recommends libpcl-dev

# Exiv2 for Exif tagging.
apt-get install -y -q --no-install-recommends exiv2 libexiv2-dev apt-utils

# Used by Pangolin/OpenGL
apt-get install -y -q --no-install-recommends libglew-dev libxkbcommon-dev libglu1-mesa-dev freeglut3-dev mesa-common-dev
apt-get install -y -q --no-install-recommends libxi-dev libxmu-dev libxmu-headers x11proto-input-dev

if [[ $(lsb_release -rs) == "16.04" ]]; then

       echo "Its Ubuntu 16.04. Repairing the Links for libproj"
       ln -s /usr/lib/x86_64-linux-gnu/libvtkCommonCore-6.2.so /usr/lib/libvtkproj4.so
else
       echo "No problems to repair."
fi


# Pangolin
cd ~ && mkdir Pangolin && cd Pangolin
git clone https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin && mkdir build && cd build && cmake ..
make -j $(nproc --all) && make install && cd ~ && rm -rf Pangolin/*

# OpenCV
cd ~ && git clone -b 3.3.1 https://github.com/opencv/opencv.git \
&& cd ~/opencv && mkdir build && cd build \
&& cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. \
&& make && make install && cd ~ && rm -rf opencv/*