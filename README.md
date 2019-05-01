# OpenVPN-web-ui

## Summary
OpenVPN server web administration interface.

Goal: create quick to deploy and easy to use solution that makes work with small OpenVPN environments a breeze.

If you have docker and docker-compose installed, you can jump directly to [installation](#Prod).

![Status page](docs/images/preview_status.png?raw=true)

Please note this project is in alpha stage. It still needs some work to make it secure and feature complete.

## Motivation



## Features

* status page that shows server statistics and list of connected clients
* easy creation of client certificates
* ability to download client certificates as a zip package with client configuration inside
* log preview
* modification of OpenVPN configuration file through web interface

## Screenshots

[Screenshots](docs/screenshots.md)

## Usage

After startup web service is visible on port 8080. To login use the following default credentials:

* username: admin
* password: created by admin and hashed via openvpn-web-ui/build/assets/encrypt_pwd.go

### Prod

Requirements:
* docker and docker-compose
* on firewall open ports: 1194/udp and 8080/tcp

Execute commands

    cd openvpn-data
    ./build.sh X.X.X CC=/usr/local/bin/x86_64-linux-musl-gcc # if new image required
    ./run.sh X.X.X

It starts 3 docker containers.
- One with OpenVPN server
- second with OpenVPNAdmin web application
- and third a nginx proxy for https access

Through a docker volume it creates following directory structure:

    .
    ├── docker-compose.yml
    └── openvpn-data-wandera
        ├── conf
        │   ├── dh2048.pem
        │   ├── ipp.txt
        │   ├── keys
        │   │   ├── 01.pem
        │   │   ├── ca.crt
        │   │   ├── ca.key
        │   │   ├── index.txt
        │   │   ├── index.txt.attr
        │   │   ├── index.txt.old
        │   │   ├── serial
        │   │   ├── serial.old
        │   │   ├── server.crt
        │   │   ├── server.csr
        │   │   ├── server.key
        │   │   └── vars
        │   ├── openvpn.log
        │   └── server.conf
        └── db
            └── data.db



### Dev

Requirements:
* golang environments
* All modules required are installed during the build

## Todo

* add unit tests
* add option to modify certificate properties
* add versioning
* add certificate revokation: base function RevokeCertificates created in openvpn-web-ui/lib/certificates.go, need to finish the CertificatesController Revoke in openvpn-web-ui/controllers/certificates.go


## License

This project uses [MIT license](LICENSE)
