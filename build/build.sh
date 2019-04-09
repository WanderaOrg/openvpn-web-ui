#!/bin/bash

set -e

if [[ $# -eq 1 ]]; then
  GIT_VERSION=":$1"
fi

PKGFILE=openvpn-web-ui.tar.gz

cp -f ../$PKGFILE ./

docker build -t wandera-openvpn-web-ui$GIT_VERSION .

rm -f $PKGFILE
