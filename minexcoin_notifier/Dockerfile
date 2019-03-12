FROM golang as build

WORKDIR /go/src/minexcoin_notifier
COPY minexcoin_notifier/minexcoin_notifier.go .

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

RUN go get -d -v && go build -v

FROM alpine:latest
COPY --from=build /go/src/minexcoin_notifier/minexcoin_notifier /bin/minexcoin_notifier

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
CMD minexcoin_notifier