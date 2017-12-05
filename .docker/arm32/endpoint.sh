#!/usr/bin/env bash
cd /home/project/
cd depends

set +e
make HOST=arm-linux-gnueabihf -j `nproc --all` || error=true
if [ ${error} ]
then
    exit -i
fi

cd ..
make clean
#find . -type f -name '*.o' -delete
./autogen.sh
./configure --prefix=$PWD/depends/arm-linux-gnueabihf --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++
make all -i -j `nproc --all`