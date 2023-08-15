# 执行公用脚本
. ".\common.ps1"

# 命名空间
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
    $imgTargetFullName = $hubAliyun + '/staneee/' + $newImgName

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