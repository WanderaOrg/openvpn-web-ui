package routers

import (
	"github.com/astaxie/beego"
)

func init() {

	beego.GlobalControllerRouter["../controllers:APISessionController"] = append(beego.GlobalControllerRouter["../controllers:APISessionController"],
		beego.ControllerComments{
			Method: "Get",
			Router: `/`,
			AllowHTTPMethods: []string{"get"},
			Params: nil})

	beego.GlobalControllerRouter["../controllers:APISessionController"] = append(beego.GlobalControllerRouter["../controllers:APISessionController"],
		beego.ControllerComments{
			Method: "Kill",
			Router: `/`,
			AllowHTTPMethods: []string{"delete"},
			Params: nil})

	beego.GlobalControllerRouter["../controllers:APISignalController"] = append(beego.GlobalControllerRouter["../controllers:APISignalController"],
		beego.ControllerComments{
			Method: "Send",
			Router: `/`,
			AllowHTTPMethods: []string{"post"},
			Params: nil})

	beego.GlobalControllerRouter["../controllers:APISysloadController"] = append(beego.GlobalControllerRouter["../controllers:APISysloadController"],
		beego.ControllerComments{
			Method: "Get",
			Router: `/`,
			AllowHTTPMethods: []string{"get"},
			Params: nil})

	beego.GlobalControllerRouter["../controllers:CertificatesController"] = append(beego.GlobalControllerRouter["../controllers:CertificatesController"],
		beego.ControllerComments{
			Method: "Download",
			Router: `/certificates/:key`,
			AllowHTTPMethods: []string{"get"},
			Params: nil})

	beego.GlobalControllerRouter["../controllers:CertificatesController"] = append(beego.GlobalControllerRouter["../controllers:CertificatesController"],
		beego.ControllerComments{
			Method: "Get",
			Router: `/certificates`,
			AllowHTTPMethods: []string{"get"},
			Params: nil})

	beego.GlobalControllerRouter["../controllers:CertificatesController"] = append(beego.GlobalControllerRouter["../controllers:CertificatesController"],
		beego.ControllerComments{
			Method: "Post",
			Router: `/certificates`,
			AllowHTTPMethods: []string{"post"},
			Params: nil})

}
