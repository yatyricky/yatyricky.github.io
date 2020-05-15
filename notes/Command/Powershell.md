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

## Pipe

```powershell
git status | findstr "prefab" | measure-object -line

```
