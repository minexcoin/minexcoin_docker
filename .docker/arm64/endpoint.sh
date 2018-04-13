#!/usr/bin/env bash
cd /home/project/
MAKEOPTS="-j `nproc --all`"
HOSTS="aarch64-linux-gnu"
INSTALLPATH=`pwd`/installed/${HOSTS}



set +e
make ${MAKEOPTS} -C `pwd`/depends HOST="${HOSTS}" || error=true
if [ ${error} ]
then
    exit -i
fi

./autogen.sh
CONFIG_SITE=$PWD/depends/${HOSTS}/share/config.site ./configure --prefix=/ --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking

make clean
find . -type f -name '*.o' -delete

make all -i -j `nproc --all`
make -C src check-security
make deploy

mkdir -p ${INSTALLPATH}
make install DESTDIR=${INSTALLPATH}

cd installed
find . -name "lib*.la" -delete
find . -name "lib*.a" -delete

tar -czvf minexcoin-${HOSTS}.tar.gz -C ${INSTALLPATH} .