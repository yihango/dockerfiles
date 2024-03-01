# 镜像同步
function ImagesSync ($ImageList, $Registry, $Namespace) {
    # 遍历打包 buildx
    foreach ($imgFullName in $ImageList) {
        if ($imgFullName -eq "") {
            continue;
        }

        # 拉取镜像
        docker pull $imgFullName

        # 新镜像名称
        $imgFullNameArray = $imgFullName.Split('/')
        $newImgName = $imgFullNameArray[$imgFullNameArray.Length - 1]
        ## 当前镜像名称不存在/，那么就直接使用当前镜像名称
        if (!$imgFullName.Contains("/")) {
            $newImgName = $imgFullName
        }

        # 镜像目标名称,如： staneee/aspnet:6.0
        $imgTargetFullName = $Namespace + '/' + $newImgName

        # 如果指定了仓库地址，最终名称为： registry.cn-shanghai.aliyuncs.com/staneee/aspnet:6.0
        if ($Registry -ne $Null -and $Registry -ne "") {
            $imgTargetFullName = $Registry + '/' + $imgTargetFullName
        }

        Write-Host "$imgTargetFullName"

        # 镜像重命名
        docker tag $imgFullName $imgTargetFullName

        # 镜像推送
        docker push $imgTargetFullName
    }
}



# 复制Manifest镜像
function SyncManifest($ManifestImageTag, $TargetRegistry, $TargetNamespace, $TargetImageName) {

    # 当前镜像支持的平台
    $plateforms = GetManifestImagePlatforms -ManifestImageTag $ManifestImageTag

    # 最终编译镜像标签
    $plateformImageTag = ""

    # 镜像调整
    if ($TargetImageName -eq $Null -or $TargetImageName -eq "") {
        $plateformImageTag = ("${TargetRegistry}/${TargetNamespace}/" + $ManifestImageTag.Split('/')[-1]).TrimStart("/")
    }
    else {
        $plateformImageTag = ("${TargetRegistry}/${TargetNamespace}/${TargetImageName}").TrimStart("/")
    }



    # 临时用的文件
    $dockerfile = "Syncfile"

    # 创建临时文件并写入内容
    $dockerfileConent = @"
ARG IMAGETAG=""
FROM --platform=`$TARGETPLATFORM `$IMAGETAG
"@
    DelFile -Path "./${dockerfile}"
    WriteFile -Path "./${dockerfile}" -Content $dockerfileConent

    # 编译参数
    $plateform = ($plateforms -join (","))
    $buildArgsOption = " --build-arg IMAGETAG=${ManifestImageTag} "

    # 执行编译参数
    CmdExec -CmdStr ("docker buildx build" `
            + " ${buildArgsOption}" `
            + " --platform '${plateform}'" `
            + " -t ${plateformImageTag}" `
            + " -f ./${dockerfile} . --push")

    # 删除临时文件
    DelFile -Path "./${dockerfile}"
}
