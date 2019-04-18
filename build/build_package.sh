#!/bin/bash

set -e

GOOS=linux
GOARCH=amd64
GOHOSTOS=linux
CGO_ENABLED=1
PKGFILE=openvpn-web-ui.tar.gz

OPTS=""

for arg in "$@"; do
  key=$(echo $arg | cut -f1 -d=)
  value=$(echo $arg | cut -f2 -d=)

  case "$key" in
    CC)
      OPTS="${OPTS} ${arg}" ;;
    GOOS)
      GOOS="${value}" ;;
    GOARCH)
      GOARCH="${value}" ;;
    GOHOSTOS)
      GOHOSTOS="${value}" ;;
    CGO_ENABLED)
      CGO_ENABLED="${value}" ;;
    *)
      ;;
  esac
done

OPTS="${OPTS} GOOS=${GOOS} GOARCH=${GOARCH} GOHOSTOS=${GOHOSTOS} CGO_ENABLED=${CGO_ENABLED}"

cd ..
env ${OPTS} go build -o openvpn-web-ui -a  .
tar -czf ${PKGFILE} LICENSE conf static/ swagger/ views/ openvpn-web-ui controllers lib models/ routers/
