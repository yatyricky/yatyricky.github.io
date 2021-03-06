---
layout: post
title: 搭建SS并优化网络
categories: [linux,ss]
---

> 从0开始搭建你的SS服务器并提供两种网络优化方案。

## Step 1 - 购买VPS

经朋友推荐，我选择了[Vultr](https://www.vultr.com/)的VPS，作为SS的服务器。推荐日本或者洛杉矶的节点，选择最便宜的方案即可，操作系统选择Ubuntu 17.04 x64。

[这里](https://doub.io/vps-tj/)有更加完整的VPS服务商列表，可作为SS的服务器的替代选项。

## Step 2 - 安装SS

完整的SS部署教程在[这里](https://github.com/shadowsocks/shadowsocks-libev)，下文只针对Ubuntu 17.04 x64进行说明。

1. 使用[PuTTY](http://www.putty.org/)或者[Xshell](https://www.netsarang.com/products/xsh_overview.html)等工具登录到你的VPS，为方便起见，直接使用root登录
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
        "server_port":6666,
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

但是为了获得更好的网络体验，强烈建议对网络进行优化。

## Step 3 - 优化网络

网络优化指的是降低延迟，提高带宽，这里讲两种我用过的方案：

1. 国内部署VPS进行转发。优点：延迟低，带宽大；缺点：**贵！**
2. BBR加速。优点：配置简单，便宜，速度尚可

两种方案任选其一即可。

### 方案1. 国内中转

经个人测试，我选择了[腾讯云](https://www.qcloud.com/)，作为国内转发服务器。请购买基础服务器，选择以流量计费的套餐（￥0.31/小时，￥0.8/G），操作系统我选择的是Ubuntu 16.04 x64。

转发的解决方案一般有：

方案 | 支持TCP | 支持UDP | 支持多端口 | 配置简易
---|---|---|---|---
Haproxy | √ | × | √ | √
Socat | √ | √ | × | √
iptables | √ | √ | √ | ×

因为我是个人使用，就选择了Socat来作为转发程序。

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

3. 配置SS客户端

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

### 方案2. BBR加速

> 转载：[开启TCP BBR拥塞控制算法](https://github.com/iMeiji/shadowsocks_install/wiki/%E5%BC%80%E5%90%AFTCP-BBR%E6%8B%A5%E5%A1%9E%E6%8E%A7%E5%88%B6%E7%AE%97%E6%B3%95)，作者：wangqr

BBR 目的是要尽量跑满带宽, 并且尽量不要有排队的情况, 效果并不比速锐差，Linux kernel 4.9+ 已支持 tcp_bbr 下面简单讲述基于KVM架构VPS如何开启。

下面是ubuntu系统下的步骤：

**更新系统**

1. 下载最新内核

    ```bash
    wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.9/linux-image-4.10.9-041009-generic_4.10.9-041009.201704080516_amd64.deb
    ```

2. 安装内核

    ```bash
    dpkg -i linux-image-4.*.deb
    ```

3. 删除旧内核（可选）

    ```bash
    dpkg -l|grep linux-image 
    apt-get purge 旧内核
    ```

4. 更新 grub 系统引导文件并重启

    ```bash
    update-grub
    reboot
    ```

**启用BBR**

1. 确认内核是否是4.9及以上

    ```bash
    uname -r
    ```

2. 执行

    ```bash
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    ```

3. 保存生效

    ```bash
    sysctl -p
    ```

4. 执行

    ```bash
    sysctl net.ipv4.tcp_available_congestion_control
    sysctl net.ipv4.tcp_congestion_control
    ```

    如果结果都有bbr，则证明你的内核已开启BBR。

5. 执行

    ```bash
    lsmod | grep bbr
    ```

    看到有 tcp_bbr 模块即说明bbr已启动

**现在开始使用科学的方式接入互联网吧:)**

## （可选）提高安全性

另外，建议开启ufw防火墙以提高安全性。

1. 查看ufw是否开启

    ```bash
    ufw status verbose
    ```

    一般来说是关闭状态，你会看到```Status: inactive```。

2. 设置默认规则

    ```bash
    ufw default deny incoming
    ufw default allow outgoing
    ```

3. 允许SSH端口和你的SS端口

    ```bash
    ufw allow 22
    ufw allow 2333
    ```

    如果不允许22端口，你以后就没法连接这台服务器了；如果不允许你的SS端口，你也没法连接其SS服务了。

4. 开启ufw

    ```bash
    ufw enable
    ```

    如果一开始你的ufw就是开启的，```ufw reload```即可。

## 致谢与参考资料

* [GitHub - shadowsocks](https://github.com/shadowsocks/shadowsocks-libev)
* [doveccl](https://ecl.me/)
* [wangqr: 开启TCP BBR拥塞控制算法](https://github.com/iMeiji/shadowsocks_install/wiki/%E5%BC%80%E5%90%AFTCP-BBR%E6%8B%A5%E5%A1%9E%E6%8E%A7%E5%88%B6%E7%AE%97%E6%B3%95)
* [Shadowsocks利用 Socat 实现单端口 中继(中转/端口转发)加速](https://doub.io/ss-jc40/)