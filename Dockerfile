# Copyright (C) 2017 Kazumasa Kohtaka <kkohtaka@gmail.com> All right reserved
# This file is available under the MIT license.

FROM golang:1.8.4 AS golang

WORKDIR /go/src/github.com/kkohtaka/cratedb-prometheus-adapter
COPY vendor vendor
RUN CGO_ENABLED=0 GOOS=linux go build \
  -a \
  -o cratedb-prometheus-adapter \
  ./vendor/github.com/crate/crate_adapter

FROM alpine:3.6 as alpine
RUN apk add -U --no-cache ca-certificates

FROM scratch
WORKDIR /root
COPY --from=golang /go/src/github.com/kkohtaka/cratedb-prometheus-adapter /bin/
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["/bin/cratedb-prometheus-adapter"]
CMD ["--help"]
