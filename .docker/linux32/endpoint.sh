#!/usr/bin/env bash
cd /home/project/

INSTALLPATH=`pwd`/installed

cd depends
set +e
make HOST=i686-pc-linux-gnu -j `nproc --all` || error=true
if [ ${error} ]
then
    exit 1
fi
cd ..
make clean
find . -type f -name '*.o' -delete
./autogen.sh
CONFIG_SITE=$PWD/depends/i686-pc-linux-gnu/share/config.site ./configure --prefix=/ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking
make -j `nproc --all`
make -C src check-security

mkdir -p ${INSTALLPATH}
make install DESTDIR=${INSTALLPATH}
cd installed
find . -name "lib*.la" -delete
find . -name "lib*.a" -delete

tar -czvf minexcoin-i686-pc-linux-gnu.tar.gz .