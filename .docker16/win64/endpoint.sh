#!/usr/bin/env bash
cd /home/project/
cd depends

set +e
make HOST=x86_64-w64-mingw32 -j `nproc --all` || error=true
if [ ${error} ]
then
    exit -i
fi

cd ..
#make clean
#find . -type f -name '*.o' -delete
./autogen.sh
CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/
make all -j `nproc --all`