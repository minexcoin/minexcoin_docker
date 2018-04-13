FROM ubuntu:14.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin

RUN apt update

RUN apt-get --yes install build-essential libtool autotools-dev automake pkg-config bsdmainutils curl ccache nsis python zip
RUN apt-get --yes install g++-mingw-w64-x86-64 mingw-w64-x86-64-dev

WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
ADD ./endpoint.sh /signer.sh
RUN chmod +x /endpoint.sh
RUN chmod +x /signer.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/

CMD /endpoint.sh