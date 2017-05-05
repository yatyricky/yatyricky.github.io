---
layout: post
title: 搭建LEMP并开启HTTPS
categories: [linux,nginx,mysql,php]
---

> 从0开始搭建你的LEMP网站并开启HTTPS。

## 环境与最终结果

- Ubuntu 16.10 x64
- nginx
- MySQL
- PHP7
- 开启HTTPS

## 配置LEMP

1. 安装nginx

    ```bash
    apt update
    apt install nginx
    ```

2. 安装MySQL

    ```bash
    apt install mysql-server
    ```

    可以输入如下命令来进行快速配置

    ```bash
    mysql_secure_installation
    ```

3. 安装PHP

    ```bash
    apt install php-fpm php-mysql
    ```

    配置

    ```bash
    vim /etc/php/7.0/fpm/php.ini
    ```

    找到如下字段并设置为0

    ```bash
    cgi.fix_pathinfo=0
    ```

    重启PHP以使配置生效

    ```bash
    systemctl restart php7.0-fpm
    ```

4. 配置nginx启用PHP

    ```bash
    vim /etc/nginx/sites-available/default
    ```

    默认配置如下

    ```
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
            try_files $uri $uri/ =404;
        }
    }
    ```

    开启PHP的配置如下

    ```
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        index index.php index.html;

        server_name server_domain_or_IP;

        location / {
            try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }

        location ~ /\.ht {
            deny all;
        }
    }
    ```

    测试配置是否合法

    ```bash
    nginx -t
    ```

    重新加载配置以生效

    ```bash
    systemctl reload nginx
    ```

5. 测试页面

    下面创建一个PHPinfo页面查看是否成功

    ```bash
    vim /var/www/html/info.php
    ```

    输入如下代码

    ```php
    <?php
    phpinfo();
    ```

    保存退出，然后进入这个页面查看，如果能看到PHP信息页，那么说明配置生效啦。

    ```
    http://your.domain/info.php
    ```

## 启用HTTPS

使用免费的LetsEncrypt来为你的网站启用HTTPS

1. 安装Let's Encrypt

    ```bash
    apt install letsencrypt
    ```

2. 关闭nginx & 获取证书

    ```bash
    systemctl stop nginx
    letsencrypt certonly --standalone -d your.domian
    ```

3. 配置nginx以启用HTTPS

    ```bash
    vim /etc/nginx/sites-available/default
    ```

    添加一个server

    ```
    server {
        listen 443;
        listen [::]:443;
        server_name your.domain;
        ssl on;
        ssl_certificate /etc/letsencrypt/live/your.domain/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/your.domain/privkey.pem;
        ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
        ssl_prefer_server_ciphers on;

        # other config

        root /var/www/html;

        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }

        location ~ /\.ht {
            deny all;
        }

    }
    ```

    在原server中开启重定向到https的server

    ```
    server {
        listen 80;
        listen [::]:80;
        server_name your.domain;
        return 301 https://$server_name$request_uri;
    }
    ```

    开启nginx

    ```bash
    systemctl start nginx
    ```

    查看https启用的php测试页

    ```
    https://your.domain/info.php
    ```

    一切正常后就可以将```info.php```删掉了。

## 致谢与参考资料

* [https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04)
* [https://c.ecl.me/archives/install-letsencrypt-certificate.html](https://c.ecl.me/archives/install-letsencrypt-certificate.html)
