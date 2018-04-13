#!/usr/bin/env bash
cd /home/project/
MAKEOPTS="-j `nproc --all`"
HOSTS="i686-w64-mingw32"
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
make deploy

mkdir -p ${INSTALLPATH}
make install DESTDIR=${INSTALLPATH}
cd installed
mv ${INSTALLPATH}/bin/*.dll ${INSTALLPATH}/lib/
find . -name "lib*.la" -delete
find . -name "lib*.a" -delete
rm -rf ${INSTALLPATH}/lib/pkgconfig
cd ${INSTALLPATH}
zip -r minexcoin-${HOSTS}.zip .
cd ../../


rename 's/-setup\.exe$/-setup-unsigned.exe/' *-setup.exe
mv *-setup-unsigned.exe `pwd`/installed/
