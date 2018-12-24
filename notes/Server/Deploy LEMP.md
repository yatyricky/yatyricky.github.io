# LEMP

``` sh
apt update
apt install nginx
apt install mysql-server
mysql_secure_installation
apt install php-fpm php-mysql
vim /etc/php/7.0/fpm/php.ini
cgi.fix_pathinfo=0
systemctl restart php7.0-fpm
vim /etc/nginx/sites-available/default
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
nginx -t # test
systemctl reload nginx
vim /var/www/html/info.php
<?php
phpinfo();
http://your.domain/info.php # PHP test
```

# HTTPS

``` sh
apt install letsencrypt
systemctl stop nginx
letsencrypt certonly --standalone -d your.domian
vim /etc/nginx/sites-available/default
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
server {
    listen 80;
    listen [::]:80;
    server_name your.domain;
    return 301 https://$server_name$request_uri;
}
systemctl start nginx
https://your.domain/info.php
rm /var/www/html/info.php
```