#!/usr/bin/env bash
cd /home/project/

INSTALLPATH=`pwd`/installed/x86_64-linux-gnu

cd depends
set +e
make HOST=x86_64-linux-gnu -j `nproc --all` || error=true
exit;
if [ ${error} ]
then
    exit -i
fi
cd ..
make clean
find . -type f -name '*.o' -delete
./autogen.sh
CONFIG_SITE=$PWD/depends/x86_64-linux-gnu/share/config.site ./configure --prefix=/ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking
make -j `nproc --all`
make -C src check-security

mkdir -p ${INSTALLPATH}
make install DESTDIR=${INSTALLPATH}
cd installed
find . -name "lib*.la" -delete
find . -name "lib*.a" -delete

tar -czvf minexcoin-x86_64-linux-gnu.tar.gz .