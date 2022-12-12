#!/bin/sh

add-apt-repository ppa:anton+/dnscrypt

apt-get update -y
apt-get install -y dnscrypt-proxy openvpn

service dnscrypt-proxy start

cat >/etc/resolv.conf <<EOF
nameserver 127.0.0.2
EOF
