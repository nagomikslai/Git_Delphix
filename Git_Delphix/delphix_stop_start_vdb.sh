#!/bin/bash
#
# sample script to start or stop a VDB.
#
# set this to the FQDN or IP address of the Delphix Engine
DE="192.168.1.78"
# set this to the Delphix admin user name
DELPHIX_ADMIN="admin"
# set this to the password for the Delphix admin user
DELPHIX_PASS="P@ssw0rd123#"
# set this to the object reference for the VDB
VDB="VDBUAT5"
#
# create our session
curl -s -X POST -k --data @- http://${DE}/resources/json/delphix/session \
    -c ~/cookies.txt -H "Content-Type: application/json" <<EOF
{
    "type": "APISession",
    "version": {
        "type": "APIVersion",
        "major": 1,
        "minor": 11,
        "micro": 8
    }
}
EOF
echo
#
# authenticate to the DE
curl -s -X POST -k --data @- http://${DE}/resources/json/delphix/login \
    -c ~/cookies.txt -b ~/cookies.txt -H "Content-Type: application/json" <<EOF
{
    "type": "LoginRequest",
    "username": "${DELPHIX_ADMIN}",
    "password": "${DELPHIX_PASS}"
}
EOF
echo
#
# start or stop the vdb based on the argument passed to the script
case $1 in
start)
  curl -s -X POST -k http://${DE}/resources/json/delphix/source/${VDB}/start \
    -c ~/cookies.txt -b ~/cookies.txt -H "Content-Type: application/json"
;;
stop)
  curl -s -X POST -k http://${DE}/resources/json/delphix/source/${VDB}/stop \
    -c ~/cookies.txt -b ~/cookies.txt -H "Content-Type: application/json"
;;
*)
  echo "Unknown option: $1"
;;
esac
echo