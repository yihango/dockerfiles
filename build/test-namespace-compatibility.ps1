#!/usr/bin/env pwsh
<#
.SYNOPSIS
    测试命名空间兼容性修复的脚本

.DESCRIPTION
    此脚本用于测试 GetTargetManifestImageTag 函数的命名空间兼容性逻辑，
    验证是否能正确处理各种命名空间组合情况。

.EXAMPLE
    .\test-namespace-compatibility.ps1
#>

# 加载函数库
. ".\functions-manifest.ps1"

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "命名空间兼容性测试" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# 测试用例1：目标仓库包含源命名空间
Write-Host "`n测试用例1: 目标仓库包含源命名空间" -ForegroundColor Yellow
$testDir1 = "src/playwright/v1.54.0-jammy"
$sourceNamespace1 = "ltm0203"
$targetRegistry1 = "registry.cn-chengdu.aliyuncs.com/yoyosoft"
$targetNamespace1 = "yoyosoft"

$result1 = GetTargetManifestImageTag -DockerfileDir $testDir1 -Registry $targetRegistry1 -Namespace $targetNamespace1 -SourceNamespace $sourceNamespace1
Write-Host "源命名空间: $sourceNamespace1" -ForegroundColor Gray
Write-Host "目标仓库: $targetRegistry1" -ForegroundColor Gray
Write-Host "目标命名空间: $targetNamespace1" -ForegroundColor Gray
Write-Host "结果: $result1" -ForegroundColor Green

# 测试用例2：目标仓库不包含源命名空间
Write-Host "`n测试用例2: 目标仓库不包含源命名空间" -ForegroundColor Yellow
$testDir2 = "src/nginx/1.19.6"
$sourceNamespace2 = "staneee"
$targetRegistry2 = "registry.cn-hangzhou.aliyuncs.com"
$targetNamespace2 = "company"

$result2 = GetTargetManifestImageTag -DockerfileDir $testDir2 -Registry $targetRegistry2 -Namespace $targetNamespace2 -SourceNamespace $sourceNamespace2
Write-Host "源命名空间: $sourceNamespace2" -ForegroundColor Gray
Write-Host "目标仓库: $targetRegistry2" -ForegroundColor Gray
Write-Host "目标命名空间: $targetNamespace2" -ForegroundColor Gray
Write-Host "结果: $result2" -ForegroundColor Green

# 测试用例3：目标仓库与源命名空间相同
Write-Host "`n测试用例3: 目标仓库与源命名空间相同" -ForegroundColor Yellow
$testDir3 = "src/dotnet/6-focal"
$sourceNamespace3 = "staneee"
$targetRegistry3 = "docker.io/staneee"
$targetNamespace3 = "staneee"

$result3 = GetTargetManifestImageTag -DockerfileDir $testDir3 -Registry $targetRegistry3 -Namespace $targetNamespace3 -SourceNamespace $sourceNamespace3
Write-Host "源命名空间: $sourceNamespace3" -ForegroundColor Gray
Write-Host "目标仓库: $targetRegistry3" -ForegroundColor Gray
Write-Host "目标命名空间: $targetNamespace3" -ForegroundColor Gray
Write-Host "结果: $result3" -ForegroundColor Green

Write-Host "`n===============================================" -ForegroundColor Cyan
Write-Host "测试完成" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# 验证预期结果
$expected1 = "registry.cn-chengdu.aliyuncs.com/yoyosoft/playwright:v1.54.0-jammy"
$expected2 = "registry.cn-hangzhou.aliyuncs.com/company/nginx:1.19.6"
$expected3 = "docker.io/staneee/dotnet:6-focal"

Write-Host "`n验证结果:" -ForegroundColor Blue
Write-Host "测试用例1: $($result1 -eq $expected1 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result1 -eq $expected1) { 'Green' } else { 'Red' })
Write-Host "测试用例2: $($result2 -eq $expected2 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result2 -eq $expected2) { 'Green' } else { 'Red' })
Write-Host "测试用例3: $($result3 -eq $expected3 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result3 -eq $expected3) { 'Green' } else { 'Red' })
