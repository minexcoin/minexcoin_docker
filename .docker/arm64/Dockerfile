FROM ubuntu:14.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin

RUN apt update

RUN apt-get --yes install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl ccache
RUN apt-get --yes install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

RUN apt-get --yes python

WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
RUN chmod 755 /endpoint.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/