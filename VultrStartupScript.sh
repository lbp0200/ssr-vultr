#!/bin/sh

PWD=pwd
PORT=443

apt update
apt install -y curl git python2.7

modprobe tcp_bbr
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p

cd /opt
git clone https://github.com/shadowsocksr-rm/shadowsocksr.git

curl -L -H "Cache-Control: no-cache" -o /opt/shadowsocksr/config.server.json https://raw.githubusercontent.com/lbp0200/ssr-vultr/master/config.json
curl -L -H "Cache-Control: no-cache" -o /etc/systemd/system/ssr.service https://raw.githubusercontent.com/lbp0200/ssr-vultr/master/ssr.service

sed -i "s/pwd/${PWD}/g" "/opt/shadowsocksr/config.server.json"
sed -i "s/443/${PORT}/g" "/opt/shadowsocksr/config.server.json"

systemctl enable ssr.service
systemctl start ssr.service