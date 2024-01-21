#!/bin/bash
apt update
apt-get -y install udev cmake gcc git breeze-icon-theme build-essential cdbs cmake dkms extra-cmake-modules fxload gettext git kdoctools5 kinit-dev kio libavcodec-dev libavdevice-dev libboost-dev libboost-regex-dev libcfitsio-dev libcurl4-gnutls-dev libdc1394-22-dev libeigen3-dev libfftw3-dev libftdi1-dev libftdi-dev libgmock-dev libgphoto2-dev libgps-dev libgsl0-dev libgsl-dev libgtest-dev libindi-dev libjpeg-dev libkf5crash-dev libkf5newstuff-dev libkf5notifications-dev libkf5notifyconfig-dev libkf5plotting-dev libkf5xmlgui-dev libkrb5-dev liblimesuite-dev libnova-dev libqt5svg5-dev libqt5websockets5-dev libraw-dev librtlsdr-dev libsecret-1-dev libtheora-dev libtiff-dev libusb-1.0-0-dev libusb-dev qt5keychain-dev qtdeclarative5-dev wcslib-dev xplanet xplanet-images zlib1g-dev aria2 axel wget qtbase5-dev  libev-dev
pip install importlib_metadata
echo "Done installing the required packages for building astronomy software "

echo "Building and installing GSC"
pwd
mkdir gsc 
cd gsc 
wget -q -O bincats_GSC_1.2.tar.gz http://cdsarc.u-strasbg.fr/viz-bin/nph-Cat/tar.gz?bincats/GSC_1.2
tar -zxvf bincats_GSC_1.2.tar.gz
cd src 
mv /build/gsc-Makefile Makefile
make
mv gsc.exe gsc
cp gsc /usr/bin
cd ../../
cp -r gsc /usr/share/ 
mv /usr/share/gsc /GSC 
rm -r /GSC/bin-dos 
rm -r /GSC/src
rm -r /GSC/bincats_GSC_1.2.tar.gz
rm -r /GSC/bin/gsc.exe
rm -r /GSC/bin/decode
rm -r gsc
echo "Done building and installing gsc"

mkdir kstars_src && cd kstars_src
git clone --depth 1 https://github.com/indilib/indi.git
cd indi && mkdir -p build
echo "Your current directory is `pwd`. preparing and building.."
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug -B build/
cd build
make -j $(nproc)
make -j $(nproc) install
cd ../../

git clone --depth=1 https://github.com/indilib/indi-3rdparty
cd  indi-3rdparty 


mkdir -p indi-3rdparty-build-libraries
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug -DBUILD_LIBS=1 -B indi-3rdparty-build-libraries
cd indi-3rdparty-build-libraries
make -j $(nproc)
make -j $(nproc) install
cd ..
mkdir -p indi-3rdparty-build-drivers
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug -B indi-3rdparty-build-drivers
cd indi-3rdparty-build-drivers
make -j $(nproc)
make -j $(nproc) install
cd ../../

git clone https://github.com/rlancaste/stellarsolver.git
cd stellarsolver
mkdir -p build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTER=ON -B build
cd build
make -j $(nproc)
make -j $(nproc) install
cd ../../



