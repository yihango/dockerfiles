param(
    # image registry
    [string]$TargetRegistry,
    # image namespace
    [string]$TargetNamespace = "staneee"
)


# 执行公用脚本
. ".\functions-common.ps1"
. ".\functions-sync.ps1"
. ".\build-images-define.ps1"


# 初始化 buildx
InitBuildX

# 直接同步的
foreach ($imgName in $syncSample) {
    if ($imgName -eq "") {
        continue;
    }

    SyncManifest -ManifestImageTag $imgName `
        -TargetRegistry $TargetRegistry `
        -TargetNamespace $TargetNamespace
}

# 重命名的
foreach ($imgName in $syncRenameDict.Keys) {
    if ($imgName -eq "") {
        continue;
    }

    SyncManifest -ManifestImageTag $imgName `
        -TargetRegistry $TargetRegistry `
        -TargetNamespace $TargetNamespace `
        -TargetImageName $syncRenameDict[$imgName]
}
