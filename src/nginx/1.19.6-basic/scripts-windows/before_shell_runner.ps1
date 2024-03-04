# 创建 shell 文件夹
New-Item -ItemType Directory -Path "/beforeshell" -Force | Out-Null

# 创建 before_shell.sh
if ($env:RUN_BEFORE_SHELL) {
    @"
$env:RUN_BEFORE_SHELL
"@ | Out-File -FilePath "/beforeshell/before_shell.sh"
}

# 进入 beforeshell 目录
Set-Location "/beforeshell" -ErrorAction SilentlyContinue

# 运行 before_shell.sh
if (Test-Path "./before_shell.sh") {
    & "before_shell.sh"
}
