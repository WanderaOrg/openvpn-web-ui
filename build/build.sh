#!/bin/bash

set -e

if [[ $# -gt 0 ]]; then
  GIT_VERSION=":$1"
fi

echo "GIT_VERSION = $GIT_VERSION"

PKGFILE=openvpn-web-ui.tar.gz
current_dir=$(pwd)

./build_package.sh $@

cd $current_dir
cp -f ../$PKGFILE ./
docker build -t wandera-openvpn-web-ui$GIT_VERSION .
rm -f $PKGFILE
