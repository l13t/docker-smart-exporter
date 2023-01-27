FROM golang:1.19 as builder

RUN cd / && \
    git clone https://github.com/alexdzyoba/smart_exporter

WORKDIR /smart_exporter

RUN go get -v ./... && \
    CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o smart_exporter -installsuffix cgo .

FROM alpine:3.17

RUN apk add --no-cache smartmontools
COPY --from=builder /smart_exporter/smart_exporter /smart_exporter

EXPOSE 9649

ENTRYPOINT ["/smart_exporter"]
