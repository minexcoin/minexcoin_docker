#!/usr/bin/env bash
docker build -t minex_coin_arm32 minexcoin_docker/.docker/arm32/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_arm32 /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_arm32

cp  -v minexcoin/installed/minexcoin-arm-linux-gnueabihf.tar.gz $(pwd)/minexcoin_docker/out/minex_coin_arm32/