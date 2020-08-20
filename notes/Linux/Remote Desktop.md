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