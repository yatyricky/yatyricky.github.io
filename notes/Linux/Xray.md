1. Register a new domain name
2. Resolve class A record to this ip address
3. Run `certbot certonly --standalone -d your.domian`
   New certs are saved at `/etc/letsencrypt/live/your.domain/`
   `cert.pem` and `privkey.pem` are what we needed.
4. Edit `/etc/nginx/conf.d/your.domain.conf`
5. Edit `/etc/v2ray/config.json`
6. Restart nginx
7. Restart v2ray
