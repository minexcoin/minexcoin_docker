#!/usr/bin/env bash
docker build -t minex_coin_14_mac minexcoin_docker/.docker/mac/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_mac /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_14_mac

cp minexcoin/MinexWallet.dmg $(pwd)/out/minex_coin_14_mac/
cp minexcoin/src/minexcoin-cli $(pwd)/minexcoin_docker/out/minex_coin_14_mac/
cp minexcoin/src/minexcoin-tx $(pwd)/minexcoin_docker/out/minex_coin_14_mac/
cp minexcoin/src/bench/bench_bitcoin $(pwd)/minexcoin_docker/out/minex_coin_14_mac/
cp minexcoin/src/minexcoind $(pwd)/minexcoin_docker/out/minex_coin_14_mac/
cp minexcoin/src/qt/minexcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_14_mac/
