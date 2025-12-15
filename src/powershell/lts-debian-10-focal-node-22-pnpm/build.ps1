#!/usr/bin/env pwsh

# PowerShell 构建脚本
# 构建 PowerShell + Node.js 22 + pnpm 镜像

param(
    [string]$ImageName = "ltm0203/powershell:lts-debian-10-focal-node-22-pnpm",
    [string]$Dockerfile = "Dockerfile.linux-arm64.linux-amd64"
)

Write-Host "开始构建镜像: $ImageName" -ForegroundColor Green

# 构建多平台镜像
docker buildx build `
    --platform linux/arm64,linux/amd64 `
    -t $ImageName `
    -f $Dockerfile `
    --push `
    .

if ($LASTEXITCODE -eq 0) {
    Write-Host "镜像构建成功: $ImageName" -ForegroundColor Green
} else {
    Write-Host "镜像构建失败: $ImageName" -ForegroundColor Red
    exit 1
}

Write-Host "构建完成!" -ForegroundColor Green
