package main

import (
	"github.com/WanderaOrg/openvpn-web-ui/lib"
	_ "github.com/WanderaOrg/openvpn-web-ui/routers"
	"github.com/astaxie/beego"
)

func main() {
	lib.AddFuncMaps()
	beego.Run()
}
