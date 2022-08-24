Powershell in Admin mode

> first
``` powershell
netsh int ipv4 set dynamicport tcp start=49152 num=16383
netsh int ipv4 set dynamicport udp start=49152 num=16383
```

> if not working then
``` powershell
net stop winnat
net start winnat
```