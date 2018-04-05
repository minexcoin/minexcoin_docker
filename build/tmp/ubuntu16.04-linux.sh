#!/usr/bin/env bash
docker build -t minex_coin_16_linux minexcoin_docker/.docker16/linux/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_16_linux /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_16_linux

cp minexcoin/src/minexcoin-cli $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/minexcoin-tx $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/test/test_bitcoin $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/bench/bench_bitcoin $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/test/test_bitcoin_fuzzy $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/minexcoind $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/qt/minexcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_16_linux/
cp minexcoin/src/qt/test/test_bitcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_16_linux/