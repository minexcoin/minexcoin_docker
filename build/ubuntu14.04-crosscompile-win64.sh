#!/usr/bin/env bash

docker build -t minex_coin_14_win64 minexcoin_docker/.docker16/win64/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_win64 /endpoint.sh 2>&1 >> $(pwd)/minexcoin_docker/logs/minex_coin_14_win64.log

mkdir $(pwd)/minexcoin_docker/out/minex_coin_14_win64
cp minexcoin/src/bitcoind.exe $(pwd)/minexcoin_docker/out/minex_coin_14_win64/
cp minexcoin/src/bitcoin-cli.exe $(pwd)/minexcoin_docker/out/minex_coin_14_win64/
cp minexcoin/src/bitcoin-tx.exe $(pwd)/minexcoin_docker/out/minex_coin_14_win64/
cp minexcoin/src/qt/bitcoin-qt.exe $(pwd)/minexcoin_docker/out/minex_coin_14_win64/