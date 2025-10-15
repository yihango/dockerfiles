param(
    # image registry
    [string]$Registry,
    # image namespace
    [string]$Namespace = "staneee",
    # target image registry
    [string]$TargetRegistry
)

# 执行公用脚本
. ".\functions-common.ps1"
. ".\functions-manifest.ps1"
. ".\build-images-define.ps1"

# 当前路径
$currentPath = (Get-Location).Path

# 初始化 buildx
InitBuildX

# 获取镜像信息
$imageInfo = GetImagesInfo

# 遍历镜像并编译
foreach ($imgName in $buildImageList) {
    if ($imgName -eq "") {
        continue;
    }

    # 所在目录
    $dockerfileDir = $imageInfo[$imgName]
    Write-Host "$imgName $dockerfileDir"

    # 复制
    ImagesCopyManifest -DockerfileDir $dockerfileDir `
        -Registry $Registry `
        -Namespace $Namespace `
        -TargetRegistry $TargetRegistry
}

# 回到当前路径
Set-Location $currentPath