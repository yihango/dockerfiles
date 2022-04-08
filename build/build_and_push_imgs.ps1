$imgNamespace = "staneee";
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

    # 拉取
    docker pull $imgFullName
    
    # 切换到Dockerfile所在目录
    Set-Location $imgTagDir
    
    # 编译镜像
    docker build . --force-rm -t $imgFullName  -f ./Dockerfile

    # 推送镜像
    docker push $imgFullName

    # 回到当前目录
    Set-Location $currentPath
}