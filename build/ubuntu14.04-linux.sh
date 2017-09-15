#!/usr/bin/env bash
docker build -t minex_coin_14_linux minexcoin_docker/.docker/linux/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_linux /endpoint.sh 2>&1 >> $(pwd)/minexcoin_docker/logs/minex_coin_14_linux.log

mkdir $(pwd)/minexcoin_docker/out/minex_coin_14_linux

cp minexcoin/src/minexcoin-cli $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/minexcoin-tx $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/test/test_bitcoin $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/bench/bench_bitcoin $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/test/test_bitcoin_fuzzy $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/minexcoind $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/qt/minexcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_14_linux/
cp minexcoin/src/qt/test/test_bitcoin-qt $(pwd)/minexcoin_docker/out/minex_coin_14_linux/