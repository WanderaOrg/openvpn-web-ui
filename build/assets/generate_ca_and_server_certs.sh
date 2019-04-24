#!/bin/bash -e

SERVER_NAME="vpn-101-dev.eu-west-1a.ie.wandera.co.uk"
ca_certs_dir="/.wandera_self_signed_ca"
KEY_DIR="/etc/openvpn/keys"
new_cert="no"

sed -i -e 's/\[ usr_cert \]/[ usr_cert ] \
authorityInfoAccess = OCSP;URI:http:\/\/openvpn.wandera.com/g' /etc/ssl/openssl.cnf

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

if [[ $new_cert == "yes" || ! -f ${KEY_DIR}/trusted_chain.crt ]]; then
  # Create browser cert
  DOMAIN="wandera.com"
  COMMON_NAME="*.$DOMAIN"
  SUBJECT=$(echo "$SUBJECT" | sed -e "s/CN=.*/CN=$COMMON_NAME/g")
  NUM_OF_DAYS=999

  openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout ${KEY_DIR}/browser.key -subj "$SUBJECT" -out ${KEY_DIR}/browser.csr

  cat /tmp/v3.ext | sed s/%%DOMAIN%%/"$COMMON_NAME"/g > /tmp/__v3.ext

  openssl x509 -req -in ${KEY_DIR}/browser.csr -CA ${ca_certs_dir}/cacert/wanderaCA.pem -CAkey ${ca_certs_dir}/private/wanderaCA.key -CAcreateserial -out ${KEY_DIR}/browser.crt -days 3650 -sha256 -extfile /tmp/__v3.ext

  cat ${KEY_DIR}/browser.csr ${KEY_DIR}/browser.crt ${ca_certs_dir}/cacert/wanderaCA.pem > ${KEY_DIR}/trusted_chain.crt
fi
