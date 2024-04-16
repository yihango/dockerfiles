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
    
    # 获取镜像最基本的标签（目标仓库）
    $targetManifestImageTag = GetManifestImageTag -DockerfileDir $DockerfileDir -Registry $TargetRegistry -Namespace $Namespace

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
    $directorySeparatorChar = [System.IO.Path]::DirectorySeparatorChar

    $dockerDirArray = $DockerfileDir.Split($directorySeparatorChar)
    # 镜像名称
    $imageName = $dockerDirArray[-2]

    # 镜像标签
    $imageTag = $dockerDirArray[-1]

    # Manifest镜像标签
    $manifestImageTag = "${Registry}/${Namespace}/${imageName}:${imageTag}".TrimStart("/")

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
