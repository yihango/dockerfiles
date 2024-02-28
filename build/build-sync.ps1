param(
    # image registry
    [string]$Registry,
    # image namespace
    [string]$Namespace = "staneee"
)


# 执行公用脚本
. ".\functions-common.ps1"
. ".\functions-sync.ps1"
. ".\build-images-define.ps1"


# 同步镜像
if (IsLinux) {
    ImagesSync -Registry $Registry `
        -Namespace $Namespace `
        -ImageList $syncLinuxImages
}
else {
    ImagesSync -Registry $Registry `
        -Namespace $Namespace `
        -ImageList $syncWinImages
}