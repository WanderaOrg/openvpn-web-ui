package models

import (
	"os"
	"io/ioutil"

	"github.com/adamwalach/go-openvpn/server/config"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/logs"
	"gopkg.in/yaml.v2"
)

var GlobalCfg Settings

type Configuration struct {
    Hash string `yaml:"admin_password_hash"`
}

func init() {
	initDB()
	createDefaultUsers()
	createDefaultSettings()
	createDefaultOVConfig()
}

func initDB() {
	orm.RegisterDriver("sqlite3", orm.DRSqlite)
	dbSource := "file:" + beego.AppConfig.String("dbPath")

	err := orm.RegisterDataBase("default", "sqlite3", dbSource)
	if err != nil {
		panic(err)
	}
	orm.Debug = true
	orm.RegisterModel(
		new(User),
		new(Settings),
		new(OVConfig),
	)

	// Database alias.
	name := "default"
	// Drop table and re-create.
	force := false
	// Print log.
	verbose := true

	err = orm.RunSyncdb(name, force, verbose)
	if err != nil {
		logs.Error(err)
		return
	}
}

func createDefaultUsers() {
	var configuration Configuration
	config_file := "/opt/openvpn-gui/secrets.json"

	data, err := ioutil.ReadFile(config_file)
	if err != nil {
		panic(err)
	}
	err = yaml.Unmarshal(data, &configuration)
	hash := configuration.Hash
	if err != nil {
		logs.Error("Failed to get hash pwd")
		panic(err)
	}
	user := User{
		Id:       1,
		Login:    "admin",
		Name:     "Administrator",
		Email:    "ops-notify@wandera.com",
		Password: hash,
	}
	o := orm.NewOrm()
	if created, _, err := o.ReadOrCreate(&user, "Name"); err == nil {
		if created {
			logs.Info("Default admin account created")
		} else {
			logs.Debug(user)
		}
	}

}

func createDefaultSettings() {
	s := Settings{
		Profile:       "default",
		MIAddress:     "openvpn:2080",
		MINetwork:     "tcp",
		ServerAddress: "127.0.0.1",
		OVConfigPath:  "/etc/openvpn/",
	}
	o := orm.NewOrm()
	if created, _, err := o.ReadOrCreate(&s, "Profile"); err == nil {
		GlobalCfg = s

		if created {
			logs.Info("New settings profile created")
		} else {
			logs.Debug(s)
		}
	} else {
		logs.Error(err)
	}
}

func createDefaultOVConfig() {
	c := OVConfig{
		Profile: "default",
		Config: config.Config{
			Port:                1194,
			Proto:               "udp",
			Cipher:              "AES-256-CBC",
			Keysize:             256,
			Auth:                "SHA256",
			Dh:                  "dh2048.pem",
			Keepalive:           "10 120",
			IfconfigPoolPersist: "ipp.txt",
			Management:          "0.0.0.0 2080",
			MaxClients:          100,
			Server:              "10.8.0.0 255.255.255.0",
			Ca:                  "keys/ca.crt",
			Cert:                "keys/server.crt",
			Key:                 "keys/server.key",
		},
	}
	o := orm.NewOrm()
	if created, _, err := o.ReadOrCreate(&c, "Profile"); err == nil {
		if created {
			logs.Info("New settings profile created")
		} else {
			logs.Debug(c)
		}
		path := GlobalCfg.OVConfigPath + "/server.conf"
		if _, err = os.Stat(path); os.IsNotExist(err) {
			destPath := GlobalCfg.OVConfigPath + "/server.conf"
			if err = config.SaveToFile("conf/openvpn-server-config.tpl",
				c.Config, destPath); err != nil {
				logs.Error(err)
			}
		}
	} else {
		logs.Error(err)
	}
}
