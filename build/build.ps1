# 执行公用脚本
. ".\common.ps1"


# 输入参数，目标是否存储到阿里云
$isAliyun = $args[0]

# 命名空间
$imgNamespace = "staneee" # docker hub 
$hubAliyun = $env:ALIYUN_DOCKERHUB # 阿里云


# 打包的配置与路径信息
$imgInfoDict = New-Object System.Collections.Generic.Dictionary"[String,String]"



# 所有Dockerfile路径
$dockerFiles = Get-ChildItem -r "../src" | Where-Object {
    $_ -is [System.IO.FileInfo] -and $_.FullName.EndsWith('Dockerfile')
} | Select-Object -ExpandProperty FullName



# 遍历存储镜像信息： 镜像名称:编译路径
$directorySeparatorChar = [System.IO.Path]::DirectorySeparatorChar
foreach ($path in $dockerFiles) {

    # 路径
    $imgTagDir = Split-Path -Parent $path # Dockerfile 所在路径
    $imgNameDir = Split-Path -Parent $imgTagDir

    # 镜像tag和镜像名称
    $imgTag = $imgTagDir.Split($directorySeparatorChar)[-1]
    $imgName = $imgNameDir.Split($directorySeparatorChar)[-1]

    # 镜像全名称
    $imgFullName = $imgNamespace + '/' + $imgName + ':' + $imgTag

    # 将镜像信息存储到字典中
    $imgInfoDict.Add($imgFullName, $imgTagDir)
}

# 遍历打包 buildx
foreach ($imgFullName in $buildX) {
    if ($imgFullName -eq "") {
        continue;
    }

    # 打包路径信息
    $imgTagDir = $imgInfoDict[$imgFullName]

    # 目标仓库名称
    $imgTargetFullName = $imgFullName
    # 如果启用了阿里云，使用阿里云做目标仓库
    if ($isAliyun -eq $True) {
        $imgTargetFullName = $hubAliyun + $imgFullName
    }


    # 切换到打包目录
    Set-Location $imgTagDir
    Write-Host "============= start $imgFullName ============="
    

    # 打包并推送
    docker buildx build --platform 'linux/arm64,linux/amd64' -t $imgTargetFullName -f ./Dockerfile . --push
    
    
    # 回到当前目录
    Set-Location $currentPath
    Write-Host "============= stop $imgFullName ============="
}


# 遍历打包 build
foreach ($imgFullName in $build) {
    if ($imgFullName -eq "") {
        continue;
    }

    # 打包路径信息
    $imgTagDir = $imgInfoDict[$imgFullName]

    # 目标仓库名称
    $imgTargetFullName = $imgFullName
    # 如果启用了阿里云，使用阿里云做目标仓库
    if ($isAliyun -eq $True) {
        $imgTargetFullName = $hubAliyun + $imgFullName
    }


    # 切换到打包目录
    Set-Location $imgTagDir
    Write-Host "============= start $imgFullName ============="
    

    # 打包并推送
    docker build . -t $imgTargetFullName  -f ./Dockerfile
    docker push $imgTargetFullName
    
    
    # 回到当前目录
    Set-Location $currentPath
    Write-Host "============= stop $imgFullName ============="
}



if ($Error.Count -eq 0) {
    exit 0
}
else {
    exit 1
}