# 创建 appconfig.prod.json
if ($env:APPCONFIG) {
    @"
$env:APPCONFIG
"@ | Out-File -FilePath "/nginx/html/static/assets/appconfig.prod.json"
}