FROM golang:latest as build

WORKDIR /go/src/minexcoin_exporter
COPY minexcoin_exporter.go .

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

RUN cd /go/src/minexcoin_exporter \
    && go get -d -v \
    && go build -v 

FROM alpine:latest
COPY --from=build /go/src/minexcoin_exporter/minexcoin_exporter /bin/minexcoin_exporter
CMD minexcoin_exporter
