#!/usr/bin/env bash
docker build -t minex_coin_win32 minexcoin_docker/.docker/win32/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_win32 /endpoint.sh

mkdir -p $(pwd)/minexcoin_docker/out/minex_coin_win32

cp -v minexcoin/installed/i686-w64-mingw32/i686-w64-mingw32.zip $(pwd)/minexcoin_docker/out/minex_coin_win32/
cp -v minexcoin/installed/minexcoin-1.3.1-win32-setup-unsigned.exe $(pwd)/minexcoin_docker/out/minex_coin_win32/
