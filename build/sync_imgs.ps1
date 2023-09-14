# 执行公用脚本
. ".\common.ps1"

# 输入参数，目标是否存储到阿里云
$isAliyun = $args[0]


# 命名空间
$imgNamespace = "staneee" # docker hub 
$hubAliyun = $env:ALIYUN_DOCKERHUB # 阿里云


foreach ($imgFullName in $sync_images) {
    if ($imgFullName -eq "") {
        continue;
    }

    # 拉取镜像
    docker pull $imgFullName

    # 新镜像名称
    $newImgName = $imgFullName.Split('/')[1]
    ## 当前镜像名称不存在/，那么就直接使用当前镜像名称
    if (!$imgFullName.Contains("/")) {
        $newImgName = $imgFullName
    }

    # 镜像目标名称
    $imgTargetFullName = $imgNamespace + '/' + $newImgName
    # 如果启用了阿里云，使用阿里云做目标仓库
    if ($isAliyun -eq $True) {
        $imgTargetFullName = $hubAliyun + '/' + $imgTargetFullName
    }

    # 镜像重命名
    docker tag $imgFullName $imgTargetFullName

    # 镜像推送
    docker push $imgTargetFullName

}

if ($Error.Count -eq 0) {
    exit 0
}
else {
    exit 1
}