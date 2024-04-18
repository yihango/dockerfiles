# 创建 frpc.ini
if ($env:FRPC_INI) {
    @"
$env:FRPC_INI
"@ | Out-File -FilePath "/frpc/frpc.ini"
}