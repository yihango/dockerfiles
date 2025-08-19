#!/usr/bin/env pwsh

Write-Host "测试修复后的路径分割逻辑" -ForegroundColor Cyan

# 加载函数库
. ".\functions-manifest.ps1"

# 测试路径
$testPath = "src/playwright/v1.54.0-jammy"
Write-Host "`n测试路径: '$testPath'" -ForegroundColor Yellow

# 测试 GetManifestImageTag
Write-Host "`n测试 GetManifestImageTag:" -ForegroundColor Blue
$result1 = GetManifestImageTag -DockerfileDir $testPath -Registry "docker.io" -Namespace "ltm0203"
Write-Host "结果: $result1" -ForegroundColor Green

# 测试 GetTargetManifestImageTag
Write-Host "`n测试 GetTargetManifestImageTag:" -ForegroundColor Blue
$result2 = GetTargetManifestImageTag -DockerfileDir $testPath -Registry "registry.cn-chengdu.aliyuncs.com/yoyosoft" -Namespace "yoyosoft" -SourceNamespace "ltm0203"
Write-Host "结果: $result2" -ForegroundColor Green

# 预期结果
$expected1 = "docker.io/ltm0203/playwright:v1.54.0-jammy"
$expected2 = "registry.cn-chengdu.aliyuncs.com/yoyosoft/playwright:v1.54.0-jammy"

Write-Host "`n验证结果:" -ForegroundColor Blue
Write-Host "测试1: $($result1 -eq $expected1 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result1 -eq $expected1) { 'Green' } else { 'Red' })
Write-Host "测试2: $($result2 -eq $expected2 ? '✓ 通过' : '✗ 失败')" -ForegroundColor $(if ($result2 -eq $expected2) { 'Green' } else { 'Red' })

if ($result1 -eq $expected1 -and $result2 -eq $expected2) {
    Write-Host "`n🎉 所有测试通过！路径分割逻辑修复成功！" -ForegroundColor Green
} else {
    Write-Host "`n❌ 仍有测试失败，需要进一步调试" -ForegroundColor Red
}
