#!/usr/bin/env bash
docker build -t minex_coin_14_arm64 minexcoin_docker/.docker/arm64/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_arm64 /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_14_arm64


#cp minexcoin/src/minexcoind  $(pwd)/minexcoin_docker/out/minex_coin_14_arm64/
#cp minexcoin/src/minexcoin-cli  $(pwd)/minexcoin_docker/out/minex_coin_14_arm64/
#cp minexcoin/src/minexcoin-tx  $(pwd)/minexcoin_docker/out/minex_coin_14_arm64/
#cp minexcoin/src/bench/bench_bitcoin  $(pwd)/minexcoin_docker/out/minex_coin_14_arm64/
#cp minexcoin/src/test/test_bitcoin_fuzzy  $(pwd)/minexcoin_docker/out/minex_coin_14_arm64/
#cp minexcoin/src/test/test_bitcoin  $(pwd)/minexcoin_docker/out/minex_coin_14_arm64/