version: '2'
services:
  openvpn:
    cap_add:
      - NET_ADMIN
    image: ${OPENVPN_IMAGE}
    container_name: openvpn
    ports:
      - "1194:1194/udp"
    restart: always
    depends_on:
      - "gui"
    volumes:
      - ./openvpn-data-wandera/conf:/etc/openvpn

  gui:
    image: ${OPENVPN_GUI_IMAGE}
    container_name: openvpn-gui
    expose:
      - "8080"
    restart: always
    volumes:
      - ./openvpn-data-wandera/conf:/etc/openvpn
      - ./openvpn-data-wandera/db:/opt/openvpn-gui/db
      - ~/.wandera/.wandera_self_signed_ca:/.wandera_self_signed_ca

  gui-proxy:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./proxy/src/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./openvpn-data-wandera/conf:/etc/ssl
    depends_on:
      - "gui"
    restart: always
    container_name: gui-proxy
