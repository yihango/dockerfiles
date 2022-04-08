

$imgNamespace = "staneee"
$imgNamespaceAliyun = "registry.cn-shanghai.aliyuncs.com/staeee"
$dockerFiles = Get-ChildItem -r "./src" | Where-Object {
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
    $imgFullNameAliyun = $imgNamespaceAliyun + '/' + $imgName + ':' + $imgTag

    Write-Host "\r\n\r\n============= start $imgFullName =============\r\n\r\n"

    # 拉取
    docker pull $imgFullName
    
    # 重命名
    docker tag $imgFullName $imgFullNameAliyun

    # 推送镜像
    docker push $imgFullNameAliyun

    Write-Host "\r\n\r\n============= stop $imgFullName =============\r\n\r\n"

    # 回到当前目录
    Set-Location $currentPath
}