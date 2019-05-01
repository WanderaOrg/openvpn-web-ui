#!/bin/bash

set -e

if [[ $# -eq 1 ]]; then
  GIT_VERSION=":$1"
fi

OPENVPN_GUI_IMAGE="wandera-openvpn-web-ui$GIT_VERSION"
#OPENVPN_IMAGE="awalach/openvpn"
OPENVPN_IMAGE="wandera-openvpn$GIT_VERSION"

export OPENVPN_GUI_IMAGE=$OPENVPN_GUI_IMAGE
export OPENVPN_IMAGE=$OPENVPN_IMAGE

cat docker-compose.yml.tpl | envsubst > docker-compose.yml

docker-compose up
