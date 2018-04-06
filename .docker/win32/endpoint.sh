#!/usr/bin/env bash
cd /home/project/
INSTALLPATH=`pwd`/installed/i686-w64-mingw32

cd depends
set +e
make HOST=i686-w64-mingw32 -j `nproc --all` || error=true
exit;
if [ ${error} ]
then
    exit -i
fi

cd ..
make clean
find . -type f -name '*.o' -delete
./autogen.sh
CONFIG_SITE=$PWD/depends/i686-w64-mingw32/share/config.site ./configure --prefix=/ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking
make all -i -j `nproc --all`
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
zip -r i686-w64-mingw32.zip .
cd ../../


rename 's/-setup\.exe$/-setup-unsigned.exe/' *-setup.exe
mv *-setup-unsigned.exe `pwd`/installed/
