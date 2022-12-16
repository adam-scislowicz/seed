#!/bin/sh

apt update
apt install -y \
    build-essential \
    easy-rsa \
    git \
    iptables \
    netcat \
    openvpn \
    wireguard

cd /root
git clone https://github.com/rofl0r/microsocks.git

cd microsocks && make -j2 && cd ..

cat > /etc/init.d/microsocks <<EOF
#!/bin/sh

case "\$1" in
    start)
        nohup /root/microsocks/run_microsocks.sh &> /dev/null &
        ;;
    stop)
        echo "Not implemented"
        ;;
esac

exit 0
EOF

chmod 755 /etc/init.d/microsocks

cat > /root/microsocks/run_microsocks.sh <<EOF
#!/bin/sh

cd /root/microsocks

while true; do
    ./microsocks -q
done
EOF
chmod 755 /root/microsocks/run_microsocks.sh

#mkdir -p easy-rsa
#ln -s /usr/share/easy-rsa/* /root/easy-rsa/
#cd easy-rsa

#cat > vars <<EOF
#set_var EASYRSA_ALGO "ec"
#set_var EASYRSA_DIGEST "sha512"
#EOF

#./easyrsa init-pki
#./easyrsa gen-req server nopass

#cp pki/private/server.key /etc/openvpn/server/

#wg genkey | tee /etc/wireguard/private.key
#chmod go= /etc/wireguard/private.key
#cat /etc/wireguard/private.key | wg pubkey | tee /etc/wireguard/public.key

#cat > /etc/wireguard/wg0.conf.template <<EOF
#[Interface]
#PrivateKey = <PRIVATE_KEY>
#Address = 10.8.0.1/24
#ListenPort = 51820
#SaveConfig = true

#PostUp = ufw route allow in on wg0 out on ens4
#PostUp = iptables -t nat -I POSTROUTING -o ens4 -j MASQUERADE
#PreDown = ufw route delete allow in on wg0 out on ens4
#PreDown = iptables -t nat -D POSTROUTING -o ens4 -j MASQUERADE
#EOF
#PRIVATE_KEY=`cat /etc/wireguard/private.key` && sed 's/<PRIVATE_KEY>/'$PRIVATE_KEY'/' \
#    /etc/wireguard/wg0.conf.template > /etc/wireguard/wg0.conf

#cat >> /etc/sysctl.conf <<EOF
#net.ipv4.ip_forward=1
#EOF

#sysctl -p

#ufw allow 51820/udp
#ufw allow 1080/tcp
#ufw allow 22/tcp
#ufw disable
#ufw enable

systemctl reload microsocks
systemctl enable microsocks
systemctl start microsocks

#systemctl enable wg-quick@wg0.service
#systemctl start wg-quick@wg0.service
