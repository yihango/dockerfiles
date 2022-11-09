# 执行公用脚本
. ".\common.ps1"


# 输入参数，目标是否存储到阿里云
$isAliyun = $args[0]

# 命名空间
$imgNamespace = "staneee" # docker hub 
$imgNamespaceAliyun = ($env:ALIYUN_DOCKERHUB + $imgNamespace) # aliyun

$dockerFiles = Get-ChildItem -r "../src" | Where-Object {
    $_ -is [System.IO.FileInfo] -and $_.FullName.EndsWith('Dockerfile')
} | Select-Object -ExpandProperty FullName


$currentPath = (Get-Location).Path
$directorySeparatorChar = [System.IO.Path]::DirectorySeparatorChar
foreach ($path in $dockerFiles) {

    # 路径
    $imgTagDir = Split-Path -Parent $path
    $imgNameDir = Split-Path -Parent $imgTagDir

    # 镜像tag和镜像名称
    $imgTag = $imgTagDir.Split($directorySeparatorChar)[-1]
    $imgName = $imgNameDir.Split($directorySeparatorChar)[-1]

    # 镜像全名称
    $imgFullName = $imgNamespace + '/' + $imgName + ':' + $imgTag
    # 目标仓库名称
    $imgTargetFullName = $imgFullName
    # 如果启用了阿里云，使用阿里云做目标仓库
    if ($isAliyun -eq $True) {
        $imgTargetFullName = $imgNamespaceAliyun + '/' + $imgName + ':' + $imgTag
    }

    # 是否需要打包
    if (($needBuild -contains $imgFullName) -eq $False) {
        # 不需要打包，跳过
        Write-Host "============= skip $imgFullName ============="
        continue
    }

    # ========== 编译并推送镜像 ==========
    Write-Host "============= start $imgFullName ============="
    # 拉取现有镜像
    docker pull $imgFullName


    # 切换到Dockerfile所在目录+编译推送
    Set-Location $imgTagDir
    if ($buildX -contains $imgFullName) {
        # buildx
        docker buildx build --platform 'linux/arm64,linux/amd64' -t $imgTargetFullName -f ./Dockerfile . --push
    }
    else {
        # build
        docker build . -t $imgTargetFullName  -f ./Dockerfile
        docker push $imgTargetFullName
    }
    Write-Host "============= stop $imgFullName ============="

    

   

    # 回到当前目录
    Set-Location $currentPath
}

if ($Error.Count -eq 0) {
    exit 0
}
else {
    exit 1
}