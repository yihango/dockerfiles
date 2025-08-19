#!/usr/bin/env pwsh

Write-Host "路径分割调试脚本" -ForegroundColor Cyan

# 测试路径
$testPath = "src/playwright/v1.54.0-jammy"
Write-Host "`n测试路径: '$testPath'" -ForegroundColor Yellow

# 方法1: 使用 Split 和 DirectorySeparatorChar
Write-Host "`n方法1: Split + DirectorySeparatorChar" -ForegroundColor Blue
$separator = [System.IO.Path]::DirectorySeparatorChar
Write-Host "分隔符: '$separator'" -ForegroundColor Gray

$array1 = $testPath.Split($separator)
Write-Host "分割结果: $($array1 -join ', ')" -ForegroundColor Gray
Write-Host "数组长度: $($array1.Length)" -ForegroundColor Gray

# 过滤空字符串
$filtered1 = $array1 | Where-Object { $_ -ne "" }
Write-Host "过滤后: $($filtered1 -join ', ')" -ForegroundColor Gray
Write-Host "过滤后长度: $($filtered1.Length)" -ForegroundColor Gray

if ($filtered1.Length -ge 2) {
    Write-Host "倒数第二个元素: $($filtered1[-2])" -ForegroundColor Green
    Write-Host "最后一个元素: $($filtered1[-1])" -ForegroundColor Green
} else {
    Write-Host "数组长度不足，无法获取倒数第二个元素" -ForegroundColor Red
}

# 方法2: 使用 Path.GetFileName 和 Path.GetDirectoryName
Write-Host "`n方法2: Path.GetFileName 和 Path.GetDirectoryName" -ForegroundColor Blue
try {
    $fileName = [System.IO.Path]::GetFileName($testPath)
    $dirName = [System.IO.Path]::GetDirectoryName($testPath)
    $parentDir = [System.IO.Path]::GetFileName($dirName)
    
    Write-Host "文件名: $fileName" -ForegroundColor Gray
    Write-Host "目录名: $dirName" -ForegroundColor Gray
    Write-Host "父目录名: $parentDir" -ForegroundColor Gray
} catch {
    Write-Host "Path 方法失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 方法3: 手动分割
Write-Host "`n方法3: 手动分割" -ForegroundColor Blue
$parts = $testPath -split '/'
Write-Host "手动分割结果: $($parts -join ', ')" -ForegroundColor Gray
Write-Host "手动分割长度: $($parts.Length)" -ForegroundColor Gray

if ($parts.Length -ge 2) {
    Write-Host "倒数第二个元素: $($parts[-2])" -ForegroundColor Green
    Write-Host "最后一个元素: $($parts[-1])" -ForegroundColor Green
} else {
    Write-Host "手动分割长度不足" -ForegroundColor Red
}

# 方法4: 使用正则表达式
Write-Host "`n方法4: 正则表达式" -ForegroundColor Blue
if ($testPath -match '^(.+)/([^/]+)$') {
    Write-Host "匹配成功!" -ForegroundColor Green
    Write-Host "完整路径: $($matches[0])" -ForegroundColor Gray
    Write-Host "父目录: $($matches[1])" -ForegroundColor Gray
    Write-Host "目录名: $($matches[2])" -ForegroundColor Gray
} else {
    Write-Host "正则表达式匹配失败" -ForegroundColor Red
}
