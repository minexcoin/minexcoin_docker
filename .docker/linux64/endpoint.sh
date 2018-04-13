#!/usr/bin/env bash
cd /home/project/
MAKEOPTS="-j `nproc --all`"
HOSTS="x86_64-linux-gnu"
INSTALLPATH=`pwd`/installed/${HOSTS}


set +e
make HOST=${HOSTS} ${MAKEOPTS} || error=true
if [ ${error} ]
then
    exit -i
fi


./autogen.sh
CONFIG_SITE=$PWD/depends/${HOSTS}/share/config.site ./configure --prefix=/ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking

make clean
find . -type f -name '*.o' -delete

make ${MAKEOPTS}
make -C src check-security

mkdir -p ${INSTALLPATH}
make install DESTDIR=${INSTALLPATH}
cd installed
find . -name "lib*.la" -delete
find . -name "lib*.a" -delete

tar -czvf minexcoin-${HOSTS}.tar.gz -C ${INSTALLPATH} .