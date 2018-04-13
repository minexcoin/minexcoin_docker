FROM ubuntu:14.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN add-apt-repository ppa:chris-lea/libsodium;
RUN apt update

RUN apt --yes install libsodium-dev

RUN apt --yes install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev

RUN apt --yes install bsdmainutils libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libzmq3-dev

RUN apt --yes install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

RUN apt --yes install autoconf curl

WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
RUN chmod 755 /endpoint.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/

CMD /endpoint.sh