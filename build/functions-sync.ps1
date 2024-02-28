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
