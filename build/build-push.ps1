param(
    # image registry
    [string]$Registry,
    # image namespace
    [string]$Namespace = "staneee"
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

# 打印本次编译镜像信息
$buildImageList

# 遍历镜像并编译
foreach ($imgName in $buildImageList) {
    if ($imgName -eq "") {
        continue;
    }

    # 所在目录
    $dockerfileDir = $imageInfo[$imgName]

    # 编译
    ImagesBuildManifest -DockerfileDir $dockerfileDir `
        -Registry $Registry `
        -Namespace $Namespace
}

# 回到当前路径
Set-Location $currentPath