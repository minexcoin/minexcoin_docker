FROM ubuntu:16.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt update

RUN apt --yes install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev

RUN apt --yes install autoconf curl

WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
RUN chmod 755 /endpoint.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/