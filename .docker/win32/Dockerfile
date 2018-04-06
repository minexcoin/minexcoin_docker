FROM ubuntu:14.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin

RUN apt update

RUN apt-get --yes install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl autoconf ccache nsis python zip
RUN apt-get --yes install g++-mingw-w64-i686 mingw-w64-i686-dev

WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
RUN chmod 755 /endpoint.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/

CMD /endpoint.sh