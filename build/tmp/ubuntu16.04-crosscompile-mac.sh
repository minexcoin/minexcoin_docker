#!/usr/bin/env bash
docker build -t minex_coin_16_mac minexcoin_docker/.docker16/mac/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_16_mac /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_16_mac

cp minexcoin/MinexWallet.dmg out/minex_coin_16_mac/
cp minexcoin/src/minexcoin-cli $(pwd)/minexcoin_docker/out/minex_coin_16_mac/
cp minexcoin/src/minexcoin-tx $(pwd)/minexcoin_docker/out/minex_coin_16_mac/
cp minexcoin/src/bench/bench_bitcoin $(pwd)/minexcoin_docker/out/minex_coin_16_mac/
cp minexcoin/src/minexcoind $(pwd)/minexcoin_docker/out/minex_coin_16_mac/
cp minexcoin/src/qt/minexcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_16_mac/
