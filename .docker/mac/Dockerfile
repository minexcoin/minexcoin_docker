FROM ubuntu:14.04
RUN apt update
RUN apt --yes install software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin

RUN apt update

RUN apt --yes install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3

RUN apt --yes install cmake imagemagick libcap-dev librsvg2-bin libz-dev libbz2-dev libtiff-tools python-dev python-setuptools

RUN apt --yes install autoconf curl ccache faketime genisoimage


WORKDIR /home/project
ADD ./endpoint.sh /endpoint.sh
RUN chmod 755 /endpoint.sh

RUN mkdir /.ccache/
RUN mkdir /.ccache/tmp
RUN chmod -R 0777 /.ccache/

CMD /endpoint.sh