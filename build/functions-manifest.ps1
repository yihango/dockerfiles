# 创建复合镜像
function ImagesBuildManifest($DockerfileDir, $Registry, $Namespace) {

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

            # # 编译镜像特定平台并推送镜像
            CmdExec -CmdStr "docker buildx build --platform ""${plateform}"" -t ${plateformImageTag} -f ./${dockerfile} . --push"
        }
    }

    # 创建最终的 manifestImageTag 镜像
    CreateManifestImage -ManifestImageTag $manifestImageTag -ManifestPlateformImageTags $manifestPlateformImageTags

    Write-Host "============= end $manifestImageTag ============="
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
    $createCmd = "docker manifest create $ManifestImageTag "
    foreach ($plateformImageTag in $ManifestPlateformImageTags) {
        $createCmd += " $plateformImageTag "
    }
    CmdExec -CmdStr $createCmd

    # 添加标记
    foreach ($plateformImageTag in $ManifestPlateformImageTags) {
        CmdExec -CmdStr "docker manifest annotate ${ManifestImageTag} ${plateformImageTag}"
    }

    # 推送
    CmdExec -CmdStr "docker manifest push ${ManifestImageTag}"
}

