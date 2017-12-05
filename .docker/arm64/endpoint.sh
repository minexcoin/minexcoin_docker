#!/usr/bin/env bash
cd /home/project/
cd depends

set +e
make HOST=aarch64-linux-gnu -j `nproc --all` || error=true
if [ ${error} ]
then
    exit -i
fi

cd ..
make clean
#find . -type f -name '*.o' -delete
./autogen.sh
./configure --prefix=$PWD/depends/aarch64-linux-gnu --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++
make all -i -j `nproc --all`