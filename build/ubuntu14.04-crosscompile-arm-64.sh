#!/usr/bin/env bash
docker build -t minex_coin_arm64 minexcoin_docker/.docker/arm64/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_arm64 /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_arm64

cp  -v minexcoin/installed/minexcoin-aarch64-linux-gnu.tar.gz $(pwd)/minexcoin_docker/out/minex_coin_arm64/
