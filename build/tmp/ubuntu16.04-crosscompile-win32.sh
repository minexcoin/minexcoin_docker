#!/usr/bin/env bash
docker build -t minex_coin_16_win32 minexcoin_docker/.docker16/win32/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_16_win32 /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_16_win32
cp minexcoin/src/minexcoind.exe $(pwd)/minexcoin_docker/out/minex_coin_16_win32/
cp minexcoin/src/minexcoin-cli.exe $(pwd)/minexcoin_docker/out/minex_coin_16_win32/
cp minexcoin/src/minexcoin-tx.exe $(pwd)/minexcoin_docker/out/minex_coin_16_win32/
cp minexcoin/src/qt/minexcoin-qt.exe $(pwd)/minexcoin_docker/out/minex_coin_16_win32/