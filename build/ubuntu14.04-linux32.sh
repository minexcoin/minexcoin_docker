#!/usr/bin/env bash
docker build -t minex_coin_14_linux32 minexcoin_docker/.docker/linux32/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_linux32

mkdir -p $(pwd)/minexcoin_docker/out/minex_coin_linux32

cp minexcoin/installed/minexcoin-i686-pc-linux-gnu.tar.gz $(pwd)/minexcoin_docker/out/minex_coin_linux32/