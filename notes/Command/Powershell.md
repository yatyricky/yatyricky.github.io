https://developers.weixin.qq.com/minigame/dev/api/getWXACode.html

``` powershell
$output = "$PSScriptRoot\1.png"
$postParams = '{"path":"?utm_campaign=minicode&utm_medium=free&utm_source=blackhole&utm_content=poster&utm_term=nmywgdcxpp"}'
Invoke-WebRequest -Uri https://api.weixin.qq.com/wxa/getwxacode?access_token=ACCESS_TOKEN -Method POST -Body $postParams -OutFile $output
```