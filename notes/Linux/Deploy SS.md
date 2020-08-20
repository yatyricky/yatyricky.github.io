# SS

``` sh
apt update
apt install shadowsocks-libev
vim /etc/shadowsocks-libev/config.json
{
    "server":"0.0.0.0",
    "server_port":6666,
    "local_port":1080,
    "password":"y0urPa55W0rd",
    "timeout":60,
    "method":"aes-256-cfb"
}
# rc4-md5, aes-128-gcm, aes-192-gcm, aes-256-gcm, aes-128-cfb, aes-192-cfb, aes-256-cfb, aes-128-ctr, aes-192-ctr, aes-256-ctr, camellia-128-cfb, camellia-192-cfb, camellia-256-cfb, bf-cfb, chacha20-poly1305, chacha20-ietf-poly1305, salsa20, chacha20, chacha20-ietf
systemctl restart shadowsocks-libev
systemctl status shadowsocks-libev
```

# BBR Speed up

``` sh
wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.9/linux-image-4.10.9-041009-generic_4.10.9-041009.201704080516_amd64.deb
dpkg -i linux-image-4.*.deb
update-grub
reboot
uname -r # 4.9 or higher
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p # save
sysctl net.ipv4.tcp_available_congestion_control # see bbr
sysctl net.ipv4.tcp_congestion_control # see bbr
lsmod | grep bbr # see tcp_bbr
```

# Security (optional)

``` sh
ufw status verbose
ufw default deny incoming
ufw default allow outgoing
ufw allow 22 # SSH
ufw allow 2333 # SS port
ufw enable # or ufw reload
```