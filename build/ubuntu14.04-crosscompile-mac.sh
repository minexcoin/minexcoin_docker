#!/usr/bin/env bash
docker build -t minex_coin_mac minexcoin_docker/.docker/mac/

docker run --user $(id -u) -v $(pwd)/minexcoin/:/home/project/ minex_coin_mac /endpoint.sh

mkdir $(pwd)/minexcoin_docker/out/minex_coin_mac

cp -v minexcoin/MinexWallet.dmg $(pwd)/minexcoin_docker/out/minex_coin_mac/
cp -v minexcoin/installed/minexcoin-x86_64-apple-darwin11.tar.gz $(pwd)/minexcoin_docker/out/minex_coin_mac/