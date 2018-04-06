#!/usr/bin/env bash

docker build -t minex_coin_14_win64 minexcoin_docker/.docker/win64/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_win64

mkdir -p $(pwd)/minexcoin_docker/out/minex_coin_win64

cp minexcoin/installed/x86_64-w64-mingw32/x86_64-w64-mingw32.zip $(pwd)/minexcoin_docker/out/minex_coin_win64/
cp minexcoin/installed/minexcoin-1.3.1-win64-setup-unsigned.exe $(pwd)/minexcoin_docker/out/minex_coin_win64/