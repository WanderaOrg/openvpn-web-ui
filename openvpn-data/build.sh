#!/bin/bash

set -e

current_dir=$(pwd)
PKGFILE=openvpn-web-ui.tar.gz

web_ui_dir="${current_dir}/.."
openvpn_dir="${current_dir}/docker-openvpn"

if [[ $# -ge 1 ]]; then
  GIT_VERSION=":$1"
fi

install_dependencies() {
  echo "$(date): Installing dependencies"
  cd $web_ui_dir/build
  ./install_dependencies.sh
}

create_web_ui_package() {
  echo "$(date): Creating WEB UI package"
  cd $web_ui_dir/build
  ./build_package.sh $@
}

build_web_ui_image() {
  echo "$(date): Building WEB UI image"
  cd $web_ui_dir/build
  cp -f ../$PKGFILE ./
  docker build -t wandera-openvpn-web-ui$GIT_VERSION .
  rm -f $PKGFILE
}

build_openvpn_image() {
  echo "$(date): Building OPENVPN image"
  cd $openvpn_dir
  docker build -t wandera-openvpn$GIT_VERSION .
}

install_dependencies && \
create_web_ui_package $@ && \
build_web_ui_image && \
build_openvpn_image && \
cd $current_dir

if [[ $? -ne 0 ]]; then
  echo
  echo "FAILED TO BUILD"
  cd $current_dir
  exit 1
fi
