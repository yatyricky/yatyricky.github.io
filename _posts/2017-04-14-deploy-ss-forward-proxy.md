---
layout: post
title: 搭建SS并使用国内VPS中转
categories: [linux,ss]
---

> 从0开始搭建你的SS服务器并使用国内服务器转发。

## Step 1 - 购买VPS

经朋友推荐，我选择了[Vultr](https://www.vultr.com/)的VPS，作为SS的服务器。请购买其洛杉矶的节点，选择最便宜的方案即可，操作系统选择Ubuntu 16.10 x64。

经个人测试，我选择了[腾讯云](https://www.qcloud.com/)，作为国内转发服务器。请购买基础服务器，选择以流量计费的套餐，操作系统我选择的是Ubuntu 16.04 x64。

[这里](https://doub.io/vps-tj/)有更加完整的VPS服务商列表，可作为SS的服务器的替代选项。

## Step 2 - 安装SS

完整的SS部署教程在[这里](https://github.com/shadowsocks/shadowsocks-libev)，下文只针对Ubuntu 16.10 x64进行说明。

1. 使用[PuTTY](http://www.putty.org/)或者[Xshell](https://www.netsarang.com/products/xsh_overview.html)等工具登录到你的VPS，为方便起见，使用root即可
2. 安装shadowsocks-libev

```bash
apt update 
apt install shadowsocks-libev
```

3. 编辑配置文件

```bash
vim /etc/shadowsocks-libev/config.json
```

```javascript
{
    "server":"0.0.0.0",
    "server_port":23333,
    "local_port":1080,
    "password":"y0urPa55W0rd",
    "timeout":60,
    "method":"aes-256-cfb"
}
```

> 未说明的字段保持不变即可：  
> server_port: 你的SS端口，随便写  
> password: 你的SS密码，随便写  
> method: 任选其一，rc4-md5, aes-128-gcm, aes-192-gcm, aes-256-gcm, aes-128-cfb, aes-192-cfb, aes-256-cfb, aes-128-ctr, aes-192-ctr, aes-256-ctr, camellia-128-cfb, camellia-192-cfb, camellia-256-cfb, bf-cfb, chacha20-poly1305, chacha20-ietf-poly1305, salsa20, chacha20, chacha20-ietf

注：[加密方式速度对比](https://github.com/shadowsocks/libQtShadowsocks/wiki/Comparison-of-Encryption-Methods'-Speed)

4. 启动服务

```bash
systemctl start shadowsocks-libev # 启动SS服务
systemctl status shadowsocks-libev # 查看运行状态
```

**至此，你的SS服务器部分已经配置完成。请使用SS客户端测试连接，如有问题请参考[这里](https://github.com/shadowsocks/shadowsocks-libev)。**

## Step 3 - 部署转发服务器

经挑选，我选择了Socat来作为转发程序，因为配置简单，并且同时支持TCP和UDP，满足我的个人需求。

1. 安装Socat

```bash
apt-get update
apt-get install -y socat
```

2. 启动Socat

```bash
nohup socat TCP4-LISTEN:2333,reuseaddr,fork TCP4:2.2.2.2:6666 >> /root/socat.log 2>&1 &
nohup socat UDP4-LISTEN:2333,reuseaddr,fork UDP4:2.2.2.2:6666 >> /root/socat.log 2>&1 &
```

> 2333是你的转发服务器的端口，随便填，作为SS客户端中填写的端口
> 2.2.2.2是你的SS服务器IP地址
> 6666是你的SS服务器的端口

## Step 4 - 配置SS客户端

```javascript
{
    "server": "1.1.1.1",
    "server_port": 2333,
    "password": "y0urPa55W0rd",
    "method": "aes-256-cfb",
    "timeout": 5
}
```

> 未说明的字段保持不变即可：  
> server: 你的转发服务器IP地址  
> server_port: 你的转发服务器端口，与Socat参数中一致  
> password: 与你的SS服务器中配置的密码一致  
> method: 与你的SS服务器中配置的加密方式一致

**现在开始使用科学的方式接入互联网吧:)**

## 致谢

* [GitHub - shadowsocks](https://github.com/shadowsocks/shadowsocks-libev)
* [doveccl](https://ecl.me/)
* [Shadowsocks利用 Socat 实现单端口 中继(中转/端口转发)加速](https://doub.io/ss-jc40/)