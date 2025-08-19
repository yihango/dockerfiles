#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Docker 镜像构建和推送脚本

.DESCRIPTION
    此脚本用于自动化构建和推送 Docker 镜像到指定的镜像仓库。
    支持多平台构建 (linux/arm64, linux/amd64, windows/amd64)，
    并自动创建多平台镜像清单。

.PARAMETER Registry
    目标镜像仓库地址，例如：
    - "docker.io" (Docker Hub)
    - "registry.cn-hangzhou.aliyuncs.com" (阿里云)
    - "registry.hk.aliyuncs.com" (阿里云香港)

.PARAMETER Namespace
    镜像命名空间，默认为 "ltm0203"

.EXAMPLE
    # 构建并推送到 Docker Hub
    .\build-push.ps1 -Registry "docker.io"

.EXAMPLE
    # 构建并推送到阿里云镜像仓库
    .\build-push.ps1 -Registry "registry.cn-hangzhou.aliyuncs.com"

.NOTES
    作者: Dockerfiles 项目团队
    版本: 1.0
    依赖: 
    - Docker Buildx
    - PowerShell 7+
    - 相关函数库文件

.LINK
    https://github.com/ltm0203/dockerfiles
#>

param(
    # 镜像仓库地址 - 可选参数，默认为 "docker.io"
    [Parameter(Mandatory = $false, HelpMessage = "目标镜像仓库地址")]
    [string]$Registry = "docker.io",
    
    # 镜像命名空间 - 可选参数，默认为 "ltm0203"
    [Parameter(Mandatory = $false, HelpMessage = "镜像命名空间")]
    [string]$Namespace = "ltm0203"
)

# =============================================================================
# 脚本执行开始
# =============================================================================

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "Docker 镜像构建和推送脚本启动" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "目标仓库: $Registry" -ForegroundColor Yellow
Write-Host "命名空间: $Namespace" -ForegroundColor Yellow
Write-Host "开始时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Cyan

# =============================================================================
# 第一步：加载依赖函数库
# =============================================================================

Write-Host "正在加载依赖函数库..." -ForegroundColor Blue

try {
    # 加载通用函数库 - 包含基础构建函数
    . ".\functions-common.ps1"
    Write-Host "✓ 通用函数库加载成功" -ForegroundColor Green
    
    # 加载镜像清单管理函数库 - 包含多平台镜像清单创建函数
    . ".\functions-manifest.ps1"
    Write-Host "✓ 镜像清单管理函数库加载成功" -ForegroundColor Green
    
    # 加载镜像定义配置 - 包含要构建的镜像列表
    . ".\build-images-define.ps1"
    Write-Host "✓ 镜像定义配置加载成功" -ForegroundColor Green
    
} catch {
    Write-Host "✗ 函数库加载失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请检查以下文件是否存在:" -ForegroundColor Red
    Write-Host "  - functions-common.ps1" -ForegroundColor Red
    Write-Host "  - functions-manifest.ps1" -ForegroundColor Red
    Write-Host "  - build-images-define.ps1" -ForegroundColor Red
    exit 1
}

# =============================================================================
# 第二步：保存当前工作目录
# =============================================================================

Write-Host "保存当前工作目录..." -ForegroundColor Blue
$currentPath = (Get-Location).Path
Write-Host "当前目录: $currentPath" -ForegroundColor Gray

# =============================================================================
# 第三步：初始化 Docker Buildx
# =============================================================================

Write-Host "正在初始化 Docker Buildx..." -ForegroundColor Blue

try {
    # 调用通用函数库中的 InitBuildX 函数
    # 此函数会检查并配置 Docker Buildx 环境
    InitBuildX
    Write-Host "✓ Docker Buildx 初始化成功" -ForegroundColor Green
    
} catch {
    Write-Host "✗ Docker Buildx 初始化失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请检查 Docker 环境是否正确配置" -ForegroundColor Red
    exit 1
}

# =============================================================================
# 第四步：获取镜像构建信息
# =============================================================================

Write-Host "正在获取镜像构建信息..." -ForegroundColor Blue

try {
    # 调用镜像清单管理函数库中的 GetImagesInfo 函数
    # 此函数会解析镜像定义配置，返回镜像路径映射
    $imageInfo = GetImagesInfo
    Write-Host "✓ 镜像信息获取成功，共找到 $($imageInfo.Count) 个镜像" -ForegroundColor Green
    
} catch {
    Write-Host "✗ 镜像信息获取失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# =============================================================================
# 第五步：显示本次构建的镜像列表
# =============================================================================

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "本次构建镜像列表:" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# 从 build-images-define.ps1 中获取的镜像列表
$buildImageList | ForEach-Object { 
    if ($_ -ne "") {
        Write-Host "  - $_" -ForegroundColor White
    }
}

Write-Host "===============================================" -ForegroundColor Cyan

# =============================================================================
# 第六步：遍历镜像并执行构建
# =============================================================================

Write-Host "开始构建镜像..." -ForegroundColor Blue

# 构建计数器
$buildCount = 0
$successCount = 0
$failCount = 0

# 遍历镜像列表中的每个镜像
foreach ($imgName in $buildImageList) {
    # 跳过空字符串
    if ($imgName -eq "") {
        continue
    }
    
    $buildCount++
    Write-Host "===============================================" -ForegroundColor Magenta
    Write-Host "正在构建第 $buildCount 个镜像: $imgName" -ForegroundColor Magenta
    Write-Host "===============================================" -ForegroundColor Magenta
    
    try {
        # 获取镜像对应的 Dockerfile 目录
        $dockerfileDir = $imageInfo[$imgName]
        
        if (-not $dockerfileDir) {
            Write-Host "✗ 未找到镜像 $imgName 的构建目录" -ForegroundColor Red
            $failCount++
            continue
        }
        
        Write-Host "构建目录: $dockerfileDir" -ForegroundColor Gray
        
        # 调用镜像清单管理函数库中的 ImagesBuildManifest 函数
        # 此函数会执行多平台构建并创建镜像清单
        ImagesBuildManifest -DockerfileDir $dockerfileDir `
            -Registry $Registry `
            -Namespace $Namespace
        
        Write-Host "✓ 镜像 $imgName 构建成功" -ForegroundColor Green
        $successCount++
        
    } catch {
        Write-Host "✗ 镜像 $imgName 构建失败: $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
        
        # 继续构建下一个镜像，不中断整个流程
        Write-Host "继续构建下一个镜像..." -ForegroundColor Yellow
    }
}

# =============================================================================
# 第七步：恢复工作目录
# =============================================================================

Write-Host "恢复工作目录..." -ForegroundColor Blue
Set-Location $currentPath
Write-Host "当前目录: $(Get-Location).Path" -ForegroundColor Gray

# =============================================================================
# 第八步：构建结果汇总
# =============================================================================

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "构建完成汇总" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "总镜像数: $buildCount" -ForegroundColor White
Write-Host "成功数量: $successCount" -ForegroundColor Green
Write-Host "失败数量: $failCount" -ForegroundColor Red
Write-Host "完成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Green

# 计算构建耗时
$endTime = Get-Date
$duration = $endTime - (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Write-Host "构建耗时: $($duration.ToString('hh\:mm\:ss'))" -ForegroundColor Cyan

# 根据构建结果设置退出码
if ($failCount -gt 0) {
    Write-Host "===============================================" -ForegroundColor Red
    Write-Host "构建完成，但有 $failCount 个镜像构建失败" -ForegroundColor Red
    Write-Host "请检查失败原因并重新构建" -ForegroundColor Red
    Write-Host "===============================================" -ForegroundColor Red
    exit 1
} else {
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "所有镜像构建成功！" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    exit 0
}