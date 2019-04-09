#!/bin/bash -e

SERVER_NAME="vpn-101-dev.eu-west-1a.ie.wandera.co.uk"
ca_certs_dir="/.wandera_self_signed_ca"
KEY_DIR="/etc/openvpn/keys"
new_cert="no"

mkdir -p /etc/openvpn/keys
if [[ ! -f /etc/openvpn/keys/index.txt ]]; then
  touch /etc/openvpn/keys/index.txt
  echo 01 > /etc/openvpn/keys/serial
fi
cp -f /opt/scripts/vars.template /etc/openvpn/keys/vars

if [[ ! -f ${KEY_DIR}/ca.crt || `diff ${ca_certs_dir}/cacert/wanderaCA.pem ${KEY_DIR}/ca.crt` ]]; then
  new_cert="yes"
  rm -rf ${KEY_DIR}/ca.crt ${KEY_DIR}/ca.key
  cp -p ${ca_certs_dir}/cacert/wanderaCA.pem ${KEY_DIR}/ca.crt
  cp -p ${ca_certs_dir}/private/wanderaCA.key ${KEY_DIR}/ca.key
fi

if [[ $new_cert == "yes" || ! -f ${KEY_DIR}/${SERVER_NAME}.pem ]]; then
  SUBJECT="${SUBJECT}/CN=${SERVER_NAME}"
  openssl req -new -nodes -newkey rsa:4096 -subj "${SUBJECT}" -keyout ${KEY_DIR}/${SERVER_NAME}.key -out ${KEY_DIR}/${SERVER_NAME}.csr
  openssl x509 -CA ${ca_certs_dir}/cacert/wanderaCA.pem -CAkey ${ca_certs_dir}/private/wanderaCA.key -CAcreateserial -req -days 3650 -in ${KEY_DIR}/${SERVER_NAME}.csr -out ${KEY_DIR}/${SERVER_NAME}.crt
  cat ${KEY_DIR}/${SERVER_NAME}.key ${KEY_DIR}/${SERVER_NAME}.crt > ${KEY_DIR}/${SERVER_NAME}.pem

  for ext in crt csr key; do
    rm -rf ${KEY_DIR}/server.${ext}
    cp -p ${KEY_DIR}/${SERVER_NAME}.${ext} ${KEY_DIR}/server.${ext}
  done

  chmod 400 ${KEY_DIR}/server.key
fi
