#!/usr/bin/env pwsh

# 加载函数库
. ".\functions-manifest.ps1"

Write-Host "简单路径解析测试" -ForegroundColor Cyan

# 测试路径解析
$testPath = "src/playwright/v1.54.0-jammy"
Write-Host "测试路径: $testPath" -ForegroundColor Yellow

# 测试 GetManifestImageTag
$result1 = GetManifestImageTag -DockerfileDir $testPath -Registry "docker.io" -Namespace "ltm0203"
Write-Host "GetManifestImageTag 结果: $result1" -ForegroundColor Green

# 测试 GetTargetManifestImageTag
$result2 = GetTargetManifestImageTag -DockerfileDir $testPath -Registry "registry.cn-chengdu.aliyuncs.com/yoyosoft" -Namespace "yoyosoft" -SourceNamespace "ltm0203"
Write-Host "GetTargetManifestImageTag 结果: $result2" -ForegroundColor Green

# 预期结果
$expected1 = "docker.io/ltm0203/playwright:v1.54.0-jammy"
$expected2 = "registry.cn-chengdu.aliyuncs.com/yoyosoft/playwright:v1.54.0-jammy"

Write-Host "`n验证结果:" -ForegroundColor Blue
Write-Host "测试1: $($result1 -eq $expected1 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result1 -eq $expected1) { 'Green' } else { 'Red' })
Write-Host "测试2: $($result2 -eq $expected2 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result2 -eq $expected2) { 'Green' } else { 'Red' })
