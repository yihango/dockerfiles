# 执行公用脚本
. ".\common.ps1"

$imgNamespace = "staneee"
$imgNamespaceAliyun = ($env:ALIYUN_DOCKERHUB + $imgNamespace)
$dockerFiles = Get-ChildItem -r "../src" | Where-Object {
    $_ -is [System.IO.FileInfo] -and $_.FullName.EndsWith('Dockerfile')
} | Select-Object -ExpandProperty FullName


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

    Write-Host "============= start aliyun $imgFullNameAliyun ============="

    # 拉取
    docker pull $imgFullName
    
    # 重命名
    docker tag $imgFullName $imgFullNameAliyun

    # 推送镜像
    docker push $imgFullNameAliyun

    Write-Host "============= stop aliyun $imgFullNameAliyun ============="
}

if ($Error.Count -eq 0) {
    exit 0
}
else {
    exit 1
}