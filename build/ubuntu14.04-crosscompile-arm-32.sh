#!/usr/bin/env bash
docker build -t minex_coin_14_arm32 minexcoin_docker/.docker/arm32/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_arm32 /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_14_arm32l

cp minexcoin/src/minexcoind  $(pwd)/minexcoin_docker/out/minex_coin_14_arm32/
cp minexcoin/src/minexcoin-cli  $(pwd)/minexcoin_docker/out/minex_coin_14_arm32/
cp minexcoin/src/minexcoin-tx  $(pwd)/minexcoin_docker/out/minex_coin_14_arm32/
cp minexcoin/src/bench/bench_bitcoin  $(pwd)/minexcoin_docker/out/minex_coin_14_arm32/
cp minexcoin/src/test/test_bitcoin_fuzzy  $(pwd)/minexcoin_docker/out/minex_coin_14_arm32/
cp minexcoin/src/test/test_bitcoin  $(pwd)/minexcoin_docker/out/minex_coin_14_arm32/
