## Core

``` powershell
# Enable run scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

## WebRequest

https://developers.weixin.qq.com/minigame/dev/api/getWXACode.html

``` powershell
$output = "$PSScriptRoot\1.png"
$postParams = '{"path":"?utm_campaign=minicode&utm_medium=free&utm_source=blackhole&utm_content=poster&utm_term=nmywgdcxpp"}'
Invoke-WebRequest -Uri https://api.weixin.qq.com/wxa/getwxacode?access_token=ACCESS_TOKEN -Method POST -Body $postParams -OutFile $output
```

``` powershell
$postParams = '{"key": "value"}'
Invoke-WebRequest -Uri https://my.request -Method POST -Headers @{"Content-Type"="application/json"} -Body $postParams | Select-Object -Expand Content
```

## SSH

``` powershell
# Generate SSH Keys
ssh-keygen -t rsa -C "Key Name"
```

1. 在服务器上创建普通用户

# 登录服务器（暂时仍用 root）
ssh root@example.com

# 创建新用户（如命名为 admin）
sudo adduser admin
# 或非交互式创建
sudo useradd -m -s /bin/bash admin

# 设置强密码（用于 sudo 提权，后续可配置免密）
sudo passwd admin


2. 将你的公钥添加到普通用户

# 在服务器上切换到 admin 用户
sudo -u admin bash

# 创建 .ssh 目录并设置权限
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 添加公钥（从你的本地复制内容）
echo "ssh-rsa AAAAB3NzaC1yc2E...（你的公钥内容）" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# 退出 admin shell
exit


3. 配置 sudo 权限（关键）

# 将 admin 用户添加到 sudo 组
sudo usermod -aG sudo admin

# 验证
sudo -l -U admin


🔧 两种提权方式配置

方案A：使用 sudo（推荐）

# 编辑 sudoers 配置
sudo visudo

# 在文件末尾添加（允许 admin 用户无需密码执行所有命令）
admin ALL=(ALL) NOPASSWD:ALL

# 或更安全的限制（仅允许特定命令）
# admin ALL=(ALL) NOPASSWD:/bin/systemctl,/usr/bin/apt


使用方式：
# 登录后直接使用 sudo 无需密码
ssh admin@nefandfriends.com
sudo apt update  # 无需输入密码
sudo -i          # 直接进入 root shell


方案B：使用 su（需记住 root 密码）

# 登录后切换用户
ssh admin@nefandfriends.com
su -  # 输入 root 密码

# 或直接执行命令
su -c "apt update"


⚙️ 服务器端 SSH 加固配置

禁用 root 直接登录和密码登录

sudo nano /etc/ssh/sshd_config


修改以下配置：
# 禁用 root 直接 SSH 登录
PermitRootLogin no

# 禁用密码认证（强制密钥登录）
PasswordAuthentication no

# 允许的公钥认证方式
PubkeyAuthentication yes

# 指定允许登录的用户（可选白名单）
AllowUsers admin
# 或允许用户组
AllowGroups ssh-users


重启 SSH 服务：
sudo systemctl restart ssh
# 保持当前会话不断开，新开窗口测试


🧪 测试新配置

1. 测试普通用户密钥登录

# 从你的 Windows 客户端测试
ssh -i ~/.ssh/id_rsa admin@nefandfriends.com
# 应该直接登录，无需密码


2. 测试 sudo 提权

# 登录后测试
sudo whoami
# 应返回 "root"


3. 验证 root 登录已禁用

# 尝试 root 登录应失败
ssh root@nefandfriends.com
# 应提示 "Permission denied"


🔐 关于 root 密码的解决方案

方案1：设置超强密码并离线保存

# 生成随机强密码（在本地）
openssl rand -base64 32
# 复制到安全位置（密码管理器/纸质备份）

# 在服务器设置
sudo passwd root
# 粘贴生成的强密码


方案2：禁用 root 密码（仅 sudo 提权）

# 锁定 root 密码（无法通过密码登录）
sudo passwd -l root

# 恢复方法（如果还有其他 sudo 用户）
sudo passwd -u root


方案3：配置紧急恢复

保留一个备用 sudo 用户，其密钥单独保管：
# 创建恢复用户
sudo adduser recovery
sudo usermod -aG sudo recovery
# 配置不同的密钥，存储在安全位置


📁 客户端简化配置

在 ~/.ssh/config 中添加：
Host nef-admin
    HostName nefandfriends.com
    User admin
    IdentityFile ~/.ssh/id_rsa
    ServerAliveInterval 60

Host nef-root  # 备用，通过 admin 跳转
    HostName nefandfriends.com
    User admin
    IdentityFile ~/.ssh/id_rsa
    RemoteCommand sudo -i
    RequestTTY yes


使用：
# 登录 admin 用户
ssh nef-admin

# 直接获得 root shell（通过配置的 RemoteCommand）
ssh nef-root


🚨 重要安全提醒

1. 先测试再断开：在禁用 root 登录前，确保新用户能正常登录和提权
2. 备份 authorized_keys：
   sudo cp /home/admin/.ssh/authorized_keys /home/admin/.ssh/authorized_keys.backup
   
3. 保留至少两个访问途径：避免单点故障
4. 定期轮换密钥：建议每 3-6 个月更新一次密钥对

💡 最佳实践：使用 sudo 而非 su，配置 NOPASSWD 避免记忆 root 密码，同时通过 sudo 日志保留完整的操作审计轨迹。这样既安全又方便，是生产环境的标配做法。

## Pipe

```powershell
git status | findstr "prefab" | measure-object -line

```

## Copy
New-Item -ItemType File -Path $destination -Force
Copy-Item $source $destination -Force

## which
Get-Command
