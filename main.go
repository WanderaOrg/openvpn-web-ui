package main

import (
	"openvpn-web-ui/lib"
	_ "openvpn-web-ui/routers"
	"github.com/astaxie/beego"
)

func main() {
	lib.AddFuncMaps()
	beego.Run()
}
