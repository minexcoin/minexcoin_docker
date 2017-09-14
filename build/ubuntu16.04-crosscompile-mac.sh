#!/usr/bin/env bash
docker build -t minex_coin_16_mac minexcoin_docker/.docker16/mac/

docker run  --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_16_mac /endpoint.sh 2>&1 >> $(pwd)/minexcoin_docker/logs/minex_coin_16_mac.log

mkdir $(pwd)/minexcoin_docker/out/minex_coin_16_mac
cp minexcoin/Minexcoin-Core.dmg $(pwd)/minexcoin_docker/out/minex_coin_16_mac/
cp -R minexcoin/Minexcoin-Qt.app $(pwd)/minexcoin_docker/out/minex_coin_16_mac/

