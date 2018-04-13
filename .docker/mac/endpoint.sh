#!/usr/bin/env bash
BUILD_DIR="/home/project"
HOSTS="x86_64-apple-darwin11"
WRAP_DIR=${BUILD_DIR}/wrapped
INSTALL_PATH=${BUILD_DIR}/installed/${HOSTS}
OUT_DIR=${BUILD_DIR}/realise/

MAKEOPTS="-j `nproc --all`"
CONFIGFLAGS="--enable-reduce-exports --disable-bench --disable-gui-tests GENISOIMAGE=$WRAP_DIR/genisoimage"
FAKETIME_HOST_PROGS=""
FAKETIME_PROGS="ar ranlib date dmg genisoimage"


mkdir -p ${WRAP_DIR}

export ZERO_AR_DATE=1

function create_global_faketime_wrappers {
    for prog in ${FAKETIME_PROGS}; do
        echo '#!/bin/bash' > ${WRAP_DIR}/${prog}
        echo "REAL=\`which -a ${prog} | grep -v ${WRAP_DIR}/${prog} | head -1\`" >> ${WRAP_DIR}/${prog}
        echo 'export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1' >> ${WRAP_DIR}/${prog}
        echo "export FAKETIME=\"$1\"" >> ${WRAP_DIR}/${prog}
        echo "\$REAL \$@" >> ${WRAP_DIR}/${prog}
        chmod +x ${WRAP_DIR}/${prog}
    done
}

function create_per-host_faketime_wrappers {
    for i in $HOSTS; do
        for prog in ${FAKETIME_HOST_PROGS}; do
            echo '#!/bin/bash' > ${WRAP_DIR}/${i}-${prog}
            echo "REAL=\`which -a ${i}-${prog} | grep -v ${WRAP_DIR}/${i}-${prog} | head -1\`" >> ${WRAP_DIR}/${i}-${prog}
            echo 'export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/faketime/libfaketime.so.1' >> ${WRAP_DIR}/${i}-${prog}
            echo "export FAKETIME=\"$1\"" >> ${WRAP_DIR}/${i}-${prog}
            echo "\$REAL \$@" >> ${WRAP_DIR}/${i}-${prog}
            chmod +x ${WRAP_DIR}/${i}-${prog}
        done
    done
}

function download_SDK {
    mkdir -p /home/project/depends/SDKs depends/sdk-sources

    if [ ! -f /home/project/depends/sdk-sources/MacOSX10.11.sdk.tar.gz ]; then
        curl --location --fail https://bitcoincore.org/depends-sources/sdks/MacOSX10.11.sdk.tar.gz -o /home/project/depends/sdk-sources/MacOSX10.11.sdk.tar.gz
        tar -C /home/project/depends/SDKs -xf /home/project/depends/sdk-sources/MacOSX10.11.sdk.tar.gz
    fi
}

# Faketime for depends so intermediate results are comparable
create_global_faketime_wrappers "2000-01-01 12:00:00"
create_per-host_faketime_wrappers "2000-01-01 12:00:00"
download_SDK
export PATH=${WRAP_DIR}:${PATH}


cd /home/project/


# Build dependencies
set +e
make ${MAKEOPTS} -C `pwd`/depends HOST="${HOSTS}" ${MAKEOPTS} || error=true
if [ ${error} ]
then
    exit -i
fi

cd /home/project/

export PATH=$PWD/depends/${HOSTS}/native/bin:${PATH}
./autogen.sh
CONFIG_SITE=$PWD/depends/${HOSTS}/share/config.site ./configure --prefix=/ --disable-ccache --disable-maintainer-mode --disable-dependency-tracking ${CONFIGFLAGS}

make clean
find . -type f -name '*.o' -delete

make ${MAKEOPTS}
make -C src check-security

mkdir -p ${INSTALL_PATH}
make install DESTDIR=${INSTALL_PATH}
make osx_volname
make deploydir
OSX_VOLNAME="$(cat osx_volname)"

mkdir -p unsigned-app-${HOSTS}
cp osx_volname unsigned-app-${HOSTS}/
cp contrib/macdeploy/detached-sig-apply.sh unsigned-app-${HOSTS}
cp contrib/macdeploy/detached-sig-create.sh unsigned-app-${HOSTS}
cp `pwd`/depends/${i}/native/bin/dmg `pwd`/depends/${HOSTS}/native/bin/genisoimage unsigned-app-${HOSTS}
cp `pwd`/depends/${i}/native/bin/${HOSTS}-codesign_allocate unsigned-app-${HOSTS}/codesign_allocate
cp `pwd`/depends/${i}/native/bin/${HOSTS}-pagestuff unsigned-app-${HOSTS}/pagestuff
mv dist unsigned-app-${HOSTS}
pushd unsigned-app-${HOSTS}
find . | sort | tar --no-recursion --mode='u+rw,go+r-w,a+X' --owner=0 --group=0 -c -T - | gzip -9n > ${OUT_DIR}/${HOSTS}-osx-unsigned.tar.gz
popd


make deploy
${WRAP_DIR}/dmg dmg "${OSX_VOLNAME}.dmg" ${INSTALL_PATH}/${HOSTS}-unsigned.dmg

cd ${BUILD_DIR}/installed
tar -czvf minexcoin-${HOSTS}.tar.gz -C ${HOSTS}/ .


