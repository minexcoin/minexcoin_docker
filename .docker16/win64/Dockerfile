FROM ubuntu:16.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin

RUN apt update

RUN apt-get --yes install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl ccache
RUN apt-get --yes install g++-mingw-w64-x86-64 mingw-w64-x86-64-dev

RUN printf "1\n" | update-alternatives --config x86_64-w64-mingw32-gcc
RUN printf "1\n" | update-alternatives --config x86_64-w64-mingw32-g++

WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
RUN chmod 755 /endpoint.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/