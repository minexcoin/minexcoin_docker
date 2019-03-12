FROM debian:stretch

ADD https://github.com/minexcoin/minexcoin/releases/download/v1.3.1/minexcoin-v1.3.1.0-x86_64-linux-gnu.tar.gz /node/tmp/node.tar.gz

RUN apt update \
  && apt install -y curl \
  && mkdir /data \
  && cd /node/tmp \
  && tar -xf node.tar.gz --strip-components=1 \
  && mv /node/tmp/x86_64-linux-gnu/bin/minexcoin-cli /node \
  && mv /node/tmp/x86_64-linux-gnu/bin/minexcoind /node \
  && rm -rf /node/tmp \
  && /node/minexcoind -version \
  && SUDO_FORCE_REMOVE=yes \
  apt-get purge -y --auto-remove \
  -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

CMD /node/minexcoind \
  -datadir=/data \
  -printtoconsole \
  -txindex=1 \
  -server=1 \
  -listen=1 \
  -rpcuser=${RPCUSER:-user} \
  -rpcpassword=${RPCPASSWORD:-password} \
  -rpcbind=0.0.0.0 \
  -rpcallowip=0.0.0.0/0 \
  -rpcport=${RPCPORT:-8337} \
  -rpcthreads=${RPCTHREADS:-16}