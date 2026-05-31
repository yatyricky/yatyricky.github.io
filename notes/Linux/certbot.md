Snap 安装（官方推荐，首选）

# 1. 确保系统更新
sudo apt update && sudo apt upgrade -y

# 2. 安装 snapd（Ubuntu 24.04 默认已安装，但确认一下）
sudo apt install snapd -y

# 3. 确保 snap 核心组件最新
sudo snap install core
sudo snap refresh core

# 4. 移除旧版 certbot（如果存在）
sudo apt remove certbot python3-certbot-nginx python3-certbot-apache --purge -y

# 5. 安装最新版 Certbot
sudo snap install --classic certbot

# 6. 创建符号链接（让 certbot 命令全局可用）
sudo ln -sf /snap/bin/certbot /usr/local/bin/certbot

# 7. 验证安装
certbot --version

🔧 根据 Web 服务器选择插件 Nginx 用户：

# 安装 Nginx 插件（如果使用 Snap 安装的 certbot）
sudo snap set certbot trust-plugin-with-root=ok
sudo snap install certbot-dns-nginx

🚀 快速获取证书（以 Nginx 为例）
前提条件检查：

# 1. 确认域名解析正确
nslookup yourdomain.com

# 2. 确认 80/443 端口开放
sudo ufw status
# 如果防火墙启用，确保开放端口
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 3. 确认 Nginx/Apache 正在运行
sudo systemctl status nginx

自动获取并配置证书：

# Nginx 自动配置（推荐）
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

⚙️ 自动续期配置（必须设置）

# 查看现有的定时器
systemctl list-timers | grep certbot

# 手动测试续期
sudo certbot renew --dry-run

# 如果 Snap 安装，定时器已自动配置
# 查看日志确认
sudo snap logs certbot