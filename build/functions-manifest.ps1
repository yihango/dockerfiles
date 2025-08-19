<#
.SYNOPSIS
    Docker 镜像清单管理函数库

.DESCRIPTION
    此文件包含 Docker 镜像构建和复制的核心函数，支持多平台镜像构建、
    镜像清单创建、镜像复制等功能。特别针对命名空间兼容性问题进行了优化。

.FEATURES
    - 多平台镜像构建 (linux/arm64, linux/amd64, windows/amd64)
    - 自动镜像清单创建和管理
    - 跨仓库镜像复制和同步
    - 命名空间兼容性处理

.COMPATIBILITY
    支持旧版本命名空间格式，避免重复添加命名空间导致路径错误。
    例如：当目标仓库已包含源命名空间时，自动使用简化路径。

.EXAMPLE
    # 构建多平台镜像
    ImagesBuildManifest -DockerfileDir "src/nginx/1.19.6" -Registry "docker.io" -Namespace "staneee"
    
    # 复制镜像到其他仓库
    ImagesCopyManifest -DockerfileDir "src/nginx/1.19.6" -Registry "docker.io" -Namespace "staneee" -TargetRegistry "registry.cn-hangzhou.aliyuncs.com/company"

.NOTES
    作者: Dockerfiles 项目团队
    版本: 2.0 (包含命名空间兼容性改进)
    更新日期: 2024年

.LINK
    https://github.com/staneee/dockerfiles
#>

# 创建复合镜像
function ImagesBuildManifest($DockerfileDir, $Registry, $Namespace) {
    # 是否为linux
    $isLinuxOS = IsLinux

    # 暂时不使用
    $buildArgsOption = ""

    # 切换到此目录
    Set-Location $DockerfileDir

    # 镜像指定平台的标签
    $manifestPlateformImageTags = New-Object -TypeName "System.Collections.Generic.List[Object]"

    # 获取镜像最基本的标签
    $manifestImageTag = GetManifestImageTag -DockerfileDir $DockerfileDir -Registry $Registry -Namespace $Namespace

    # 获取所有的dockerfile
    $dockerfiles = GetDockerfiles -DockerfileDir $DockerfileDir

    Write-Host "============= start $manifestImageTag ============="

    # 遍历 Dockerfile 编译镜像
    foreach ($dockerfile in $dockerfiles) {
        # 获取镜像支持的平台
        $plateforms = GetPlateforms -DockerfileName $dockerfile

        # 遍历平台
        foreach ($plateform in $Plateforms) {

            # 获取特定平台的镜像标签
            $plateformImageTag = GetPlateformImageTag -ManifestImageTag $manifestImageTag -Plateform $plateform

            # 将特定平台的镜像标签添加到集合中
            $manifestPlateformImageTags.Add($plateformImageTag)

            # windows先编译，linux后编译，linux 编译时推送 manifestImageTag
            ## linux os
            if ($isLinuxOS -and $plateform.Contains('linux')) {
                # docker buildx build
                CmdExec -CmdStr ("docker buildx build" `
                        + " ${buildArgsOption}" `
                        + " --platform '${plateform}'" `
                        + " --provenance false" `
                        + " -t ${plateformImageTag}" `
                        + " -f ./${dockerfile} . --push")
            }
            ### windows
            if (!$isLinuxOS -and $plateform.Contains('windows')) {
                # docker build
                CmdExec -CmdStr ("docker build" `
                        + " ${buildArgsOption}" `
                        + " -t ${plateformImageTag}" `
                        + " -f ./${dockerfile} .")
                
                # docker push image
                CmdExec -CmdStr ("docker push ${plateformImageTag}")
            }
        }
    }

    # 创建最终的 manifestImageTag 镜像
    if ($isLinuxOS) {
        CreateManifestImage -ManifestImageTag $manifestImageTag `
            -ManifestPlateformImageTags $manifestPlateformImageTags
    }
 
    Write-Host "============= end $manifestImageTag ============="
    Write-Host ""
    Write-Host ""
    Write-Host ""
}

# 复制复合镜像
function ImagesCopyManifest($DockerfileDir, $Registry, $Namespace, $TargetRegistry) {
    # 是否为linux
    $isLinuxOS = IsLinux

    # 切换到此目录
    Set-Location $DockerfileDir

    # 镜像指定平台的标签（目标）
    $targetManifestPlateformImageTags = New-Object -TypeName "System.Collections.Generic.List[Object]"

    # 获取镜像最基本的标签
    $manifestImageTag = GetManifestImageTag -DockerfileDir $DockerfileDir -Registry $Registry -Namespace $Namespace
    
    # 获取镜像最基本的标签（目标仓库）- 使用兼容函数
    $targetManifestImageTag = GetTargetManifestImageTag -DockerfileDir $DockerfileDir -Registry $TargetRegistry -Namespace $Namespace -SourceNamespace $Namespace

    # 获取所有的dockerfile
    $dockerfiles = GetDockerfiles -DockerfileDir $DockerfileDir

    Write-Host "============= start copy $manifestImageTag -> $targetManifestImageTag ============="

    # 遍历 Dockerfile 编译镜像
    foreach ($dockerfile in $dockerfiles) {
        # 获取镜像支持的平台
        $plateforms = GetPlateforms -DockerfileName $dockerfile

        foreach ($plateform in $Plateforms) {
            # 获取特定平台的镜像标签
            $plateformImageTag = GetPlateformImageTag -ManifestImageTag $manifestImageTag -Plateform $plateform
            # 获取特定平台的镜像标签（目标仓库）
            $targetPlateformImageTag = GetPlateformImageTag -ManifestImageTag $targetManifestImageTag -Plateform $plateform

            # 将特定平台的镜像标签添加到集合中
            $targetManifestPlateformImageTags.Add($targetPlateformImageTag)

            # windows先同步，linux后同步，linux 同步时推送 manifestImageTag
            ## linux os
            if ($isLinuxOS -and $plateform.Contains('linux')) {
                CmdExec -CmdStr ("docker pull ${plateformImageTag}")
                CmdExec -CmdStr ("docker tag ${plateformImageTag} ${targetPlateformImageTag}")
                CmdExec -CmdStr ("docker push ${targetPlateformImageTag}")
            }
            ### windows
            if (!$isLinuxOS -and $plateform.Contains('windows')) {
                CmdExec -CmdStr ("docker pull ${plateformImageTag}")
                CmdExec -CmdStr ("docker tag ${plateformImageTag} ${targetPlateformImageTag}")
                CmdExec -CmdStr ("docker push ${targetPlateformImageTag}")
            }
        }
    }

    # 创建最终的 manifestImageTag 镜像
    if ($isLinuxOS) {
        CreateManifestImage -ManifestImageTag $targetManifestImageTag `
            -ManifestPlateformImageTags $targetManifestPlateformImageTags
    }

 
    Write-Host "============= end copy $manifestImageTag -> $targetManifestImageTag ============="
    Write-Host ""
    Write-Host ""
    Write-Host ""
}

# 获取基础镜像名称
function GetManifestImageTag($DockerfileDir, $Registry, $Namespace) {
    # 使用手动分割来正确处理路径，因为路径可能使用正斜杠或反斜杠
    $dockerDirArray = $DockerfileDir -split '[/\\]'
    
    # 过滤掉空字符串，确保获取正确的数组元素
    $dockerDirArray = $dockerDirArray | Where-Object { $_ -ne "" }
    
    # 调试信息
    Write-Host "GetManifestImageTag 调试信息:" -ForegroundColor Gray
    Write-Host "  目录路径: $DockerfileDir" -ForegroundColor Gray
    Write-Host "  路径数组: $($dockerDirArray -join ', ')" -ForegroundColor Gray
    
    # 镜像名称 - 倒数第二个非空元素
    $imageName = $dockerDirArray[-2]
    
    # 镜像标签 - 最后一个非空元素
    $imageTag = $dockerDirArray[-1]
    
    Write-Host "  镜像名称: $imageName" -ForegroundColor Gray
    Write-Host "  镜像标签: $imageTag" -ForegroundColor Gray

    # Manifest镜像标签
    $manifestImageTag = "${Registry}/${Namespace}/${imageName}:${imageTag}".TrimStart("/")

    return $manifestImageTag
}

# 获取目标仓库镜像名称（兼容旧版本命名空间）
function GetTargetManifestImageTag($DockerfileDir, $Registry, $Namespace, $SourceNamespace) {
    <#
    .SYNOPSIS
        获取目标仓库的镜像标签，支持旧版本命名空间兼容性
    
    .DESCRIPTION
        此函数用于解决镜像复制时的命名空间兼容性问题。
        当目标仓库地址已经包含源命名空间时，避免重复添加命名空间。
    
    .PARAMETER DockerfileDir
        Dockerfile 所在目录路径
    
    .PARAMETER Registry
        目标镜像仓库地址
    
    .PARAMETER Namespace
        目标命名空间
    
    .PARAMETER SourceNamespace
        源命名空间，用于检查是否重复
    
    .EXAMPLE
        # 源仓库: ltm0203/playwright:v1.54.0-jammy
        # 目标仓库: registry.cn-chengdu.aliyuncs.com/yoyosoft
        # 结果: registry.cn-chengdu.aliyuncs.com/yoyosoft/playwright:v1.54.0-jammy
        
        $targetTag = GetTargetManifestImageTag -DockerfileDir "src/playwright/v1.54.0-jammy" `
            -Registry "registry.cn-chengdu.aliyuncs.com/yoyosoft" `
            -Namespace "yoyosoft" `
            -SourceNamespace "ltm0203"
    
    .NOTES
        兼容性逻辑：
        1. 如果目标仓库地址包含源命名空间，则直接使用目标仓库 + 镜像名:标签
        2. 如果目标仓库地址不包含源命名空间，则使用目标仓库 + 目标命名空间 + 镜像名:标签
    #>
    
    # 使用手动分割来正确处理路径，因为路径可能使用正斜杠或反斜杠
    $dockerDirArray = $DockerfileDir -split '[/\\]'
    
    # 过滤掉空字符串，确保获取正确的数组元素
    $dockerDirArray = $dockerDirArray | Where-Object { $_ -ne "" }
    
    # 镜像名称 - 倒数第二个非空元素
    $imageName = $dockerDirArray[-2]
    
    # 镜像标签 - 最后一个非空元素
    $imageTag = $dockerDirArray[-1]
    
    # 调试信息
    Write-Host "调试信息:" -ForegroundColor Gray
    Write-Host "  目录路径: $DockerfileDir" -ForegroundColor Gray
    Write-Host "  路径数组: $($dockerDirArray -join ', ')" -ForegroundColor Gray
    Write-Host "  镜像名称: $imageName" -ForegroundColor Gray
    Write-Host "  镜像标签: $imageTag" -ForegroundColor Gray

    # 检查目标仓库是否已经包含源命名空间
    # 使用更精确的检测逻辑
    if ($Registry -like "*$SourceNamespace*") {
        # 如果目标仓库已经包含源命名空间，则直接使用目标仓库
        # 避免重复添加命名空间，如：registry.cn-chengdu.aliyuncs.com/yoyosoft/ltm0203/playwright:v1.54.0-jammy
        # 正确结果：registry.cn-chengdu.aliyuncs.com/yoyosoft/playwright:v1.54.0-jammy
        $manifestImageTag = "${Registry}/${imageName}:${imageTag}".TrimStart("/")
        Write-Host "目标仓库已包含源命名空间，使用简化路径: $manifestImageTag" -ForegroundColor Yellow
    } else {
        # 否则使用指定的命名空间
        $manifestImageTag = "${Registry}/${Namespace}/${imageName}:${imageTag}".TrimStart("/")
        Write-Host "使用完整命名空间路径: $manifestImageTag" -ForegroundColor Green
    }

    return $manifestImageTag
}

# 获取路径下所有的Dockerfile
function GetDockerfiles($DockerfileDir) {
    $directorySeparatorChar = [System.IO.Path]::DirectorySeparatorChar

    $dockerfiles = New-Object -TypeName "System.Collections.Generic.List[Object]"
    
    $dockerfileFullPath = Get-ChildItem -r $DockerfileDir | Where-Object { 
        $_ -is [System.IO.FileInfo] -and $_.FullName.Contains('Dockerfile') 
    } | Select-Object -ExpandProperty FullName

    foreach ($item in $dockerfileFullPath) {
        $dockerfiles.Add($item.Split($directorySeparatorChar)[-1])
    }

    return $dockerfiles
}

# 获取镜像支持的平台
function GetPlateforms($DockerfileName) {
    if ($DockerfileName.Contains('.')) {
        return $DockerfileName.Replace('Dockerfile.', '').Replace('-', '/').Split('.')
    }

    return @(
        "linux/amd64"
    )
}

# 获取镜像特定平台的tag
function GetPlateformImageTag($ManifestImageTag, $Plateform) {
    $plateformStr = $Plateform.Replace('/', '-')
    return ($ManifestImageTag + '-' + $plateformStr)
}

# 创建合Manifest镜像
function CreateManifestImage($ManifestImageTag, $ManifestPlateformImageTags) {
    # 创建
    $createCmd = "docker manifest create --amend $ManifestImageTag"
    $createCmd = "docker manifest create $ManifestImageTag"
    foreach ($plateformImageTag in $ManifestPlateformImageTags) {
        $createCmd += " $plateformImageTag"
    }
    CmdExec -CmdStr $createCmd

    # 添加标记
    foreach ($plateformImageTag in $ManifestPlateformImageTags) {
        CmdExec -CmdStr "docker manifest annotate ${ManifestImageTag} ${plateformImageTag}"
    }

    # 推送
    CmdExec -CmdStr "docker manifest push ${ManifestImageTag}"
}
