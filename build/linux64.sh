#!/usr/bin/env bash
docker build -t minex_coin_linux64 minexcoin_docker/.docker/linux64/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_linux64

mkdir -p $(pwd)/minexcoin_docker/out/minex_coin_linux64

cp -v minexcoin/installed/minexcoin-x86_64-linux-gnu.tar.gz $(pwd)/minexcoin_docker/out/minex_coin_linux64/
