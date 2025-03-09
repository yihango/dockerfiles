# 创建 appconfig.prod.json
if ($env:APPCONFIG) {
    @"
$env:APPCONFIG
"@ | Out-File -FilePath "/nginx/html/assets/appconfig.prod.json"
}