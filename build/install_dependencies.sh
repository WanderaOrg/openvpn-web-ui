#!/bin/bash

packages=(
  "github.com/Sirupsen/logrus"
  "github.com/adamwalach/go-openvpn/client/config"
  "github.com/adamwalach/go-openvpn/server/config"
  "github.com/astaxie/beego"
  "github.com/astaxie/beego/config"
  "github.com/astaxie/beego/context"
  "github.com/astaxie/beego/grace"
  "github.com/astaxie/beego/logs"
  "github.com/astaxie/beego/orm"
  "github.com/astaxie/beego/session"
  "github.com/astaxie/beego/toolbox"
  "github.com/astaxie/beego/utils"
  "github.com/astaxie/beego/validation"
  "gopkg.in/yaml.v2"
  "github.com/cloudfoundry/gosigar"
  "github.com/mattn/go-sqlite3"
  "gopkg.in/hlandau/passlib.v1"
)

for package in "${packages[@]}"; do
  go get $package
done
