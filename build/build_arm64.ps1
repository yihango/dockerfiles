# 执行公用脚本
. ".\common.ps1"

Write-Host $secrets.ALIYUN_DOCKERHUB+"1232"

$imgNamespace = "staneee"
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
    
    # 是否需要打包
    if (($needBuild -contains $imgFullName) -eq $False) {
        # 不需要打包，跳过
        Write-Host "============= skip $imgFullName ============="
        continue
    }

    # 是否是arm64的
    if ( ($imgFullName.Contains('arm64')) -eq $False) {
        # 不需要打包，跳过
        Write-Host "============= skip $imgFullName ============="
        continue
    }

    # ========== 编译并推送镜像 ==========
    
    Write-Host "============= start $imgFullName ============="

    # 拉取现有镜像
    docker pull $imgFullName
    
    # 切换到Dockerfile所在目录
    Set-Location $imgTagDir
    
    # 编译并推送镜像
    docker build . -t $imgFullName  -f ./Dockerfile
    docker push $imgFullName
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