#!/usr/bin/env bash
mkdir -p /home/project/depends/SDKs depends/sdk-sources

if [ ! -f /home/project/depends/sdk-sources/MacOSX10.11.sdk.tar.gz ]; then
    curl --location --fail https://bitcoincore.org/depends-sources/sdks/MacOSX10.11.sdk.tar.gz -o /home/project/depends/sdk-sources/MacOSX10.11.sdk.tar.gz
    tar -C /home/project/depends/SDKs -xf /home/project/depends/sdk-sources/MacOSX10.11.sdk.tar.gz
fi
cd /home/project/depends

set +e
make HOST=x86_64-apple-darwin11 -j `nproc --all`|| error=true
if [ ${error} ]
then
    exit -i
fi

cd /home/project/
#make clean
#find . -type f -name '*.o' -delete
./autogen.sh
CONFIG_SITE=$PWD/depends/x86_64-apple-darwin11/share/config.site ./configure --prefix=/
make -i -j `nproc --all`
make deploy

#make install-strip DESTDIR=
#make osx_volname
#make deploydir