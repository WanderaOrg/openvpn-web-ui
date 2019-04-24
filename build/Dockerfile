FROM ubuntu:16.04
#FROM debian:latest
WORKDIR /opt
EXPOSE 8080

RUN apt-get update && apt-get install -y easy-rsa musl
RUN chmod 755 /usr/share/easy-rsa/*
ADD assets/start.sh /opt/start.sh
ADD assets/v3.ext /tmp/v3.ext
ADD assets/generate_ca_and_server_certs.sh /opt/scripts/generate_ca_and_server_certs.sh
ADD assets/vars.template /opt/scripts/

ADD openvpn-web-ui.tar.gz /opt/openvpn-gui/
RUN rm -f /opt/openvpn-gui/data.db
ADD assets/app.conf /opt/openvpn-gui/conf/app.conf
ADD assets/secrets.json /opt/openvpn-gui/secrets.json

CMD /opt/start.sh
