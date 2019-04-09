package main

import (
	"./lib"
	_ "./routers"
	"github.com/astaxie/beego"
)

func main() {
	lib.AddFuncMaps()
	beego.Run()
}
