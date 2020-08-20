``` shell
apt update
apt install xfce4 xfce4-goodies
apt install tightvncserver
```

```
vncserver
vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup.bak

nano ~/.vnc/xstartup
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &

chmod +x ~/.vnc/xstartup

vncserver
```

from local
```
ssh -L 5901:127.0.0.1:5901 -C -N -l sammy your_server_ip
```

install asian language
```
# sudo apt-get install language-pack-ja
# sudo apt-get install japan*
apt-get install language-pack-zh*
apt-get install chinese*
# sudo apt-get install language-pack-ko
# sudo apt-get install korean*
apt-get install fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core
```

install chrome
```
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb

google-chrome
```