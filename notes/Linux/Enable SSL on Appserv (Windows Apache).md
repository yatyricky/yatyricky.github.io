# Source

https://www.youtube.com/watch?v=Zdl68h_N2lc

# Environment

- The AppServ Open Project - 8.6.0 for Windows
- Windows 10 Pro
- Apache 2.4

# Steps

## Generate your certificate and key

Assume your ```openssl.cnf``` path is ```C:\openssl-0.9.8k_X64\openssl.cnf```

Assume you have installed Appserv under D:\

Or you can change the paths below accordingly.

``` bash
# set environment variable manually or through the following command
set OPENSSL_CONF=C:\openssl-0.9.8k_X64\openssl.cnf

openssl req -config C:\openssl-0.9.8k_X64\openssl.cnf -new -out D:\AppServ\Apache24\conf\server.csr -keyout D:\AppServ\Apache24\conf\server.pem
openssl rsa -in D:\AppServ\Apache24\conf\server.pem -out D:\AppServ\Apache24\conf\server.key
openssl x509 -req -signkey D:\AppServ\Apache24\conf\server.key -days 1024 -in D:\AppServ\Apache24\conf\server.csr -out D:\AppServ\Apache24\conf\server.crt
```

Now you have:

- server.csr
- server.pem
- **server.key**
- **server.crt**

We want the certificate and the key for most cases(?)

## Edit httpd.conf

These 2 lines should be uncommented:

```
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so
LoadModule ssl_module modules/mod_ssl.so
```

The Include should be uncommented:

```
<IfModule ssl_module>
Include conf/extra/httpd-ahssl.conf
</IfModule>
```

## Restart your Apache

https://localhost/ should be working now.