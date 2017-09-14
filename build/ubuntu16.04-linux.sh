#!/usr/bin/env bash
docker build -t minex_coin_16_linux minexcoin_docker/.docker16/linux/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_16_linux /endpoint.sh 2>&1 >> $(pwd)/minexcoin_docker/logs/minex_coin_16_linux.log

mkdir $(pwd)/minexcoin_docker/out/minex_coin_16_linux
cp minexcoin/src/bitcoind $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/bitcoin-cli $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/bitcoin-tx $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/qt/bitcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_16_linux/