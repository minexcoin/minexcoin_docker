#!/usr/bin/env bash
docker build -t minex_coin_14_mac minexcoin_docker/.docker/mac/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_14_mac /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_14_mac
cp minexcoin/Minexcoin-Core.dmg out/minex_coin_14_mac/