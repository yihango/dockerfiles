# 当前所在目录
$currentPath = (Get-Location).Path

# 是否为linux
function IsLinux(){
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
        return $True
    }

    return $False
}

# 初始化多平台编译器
function InitBuildX(){
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
        docker buildx create --name mybuilder --driver docker-container --bootstrap
        docker buildx use mybuilder
        docker buildx inspect
    }
}

# 指定多平台进行编译
function ImagesBuildX ($ImageInfo,$ImageList,$Registry,$Platform) {
    # 只在linux下执行
    if (!(IsLinux)){
        return;
    }

    # 遍历打包 buildx
    foreach ($imgFullName in $ImageList) {
        if ($imgFullName -eq "") {
            continue;
        }

    
        # 打包路径信息
        $imgTagDir = $ImageInfo[$imgFullName]

        # 目标镜像名称，如：staneee/aspnet:6.0
        $imgTargetFullName = $imgFullName

        # 如果指定了仓库地址，最终名称为： registry.cn-shanghai.aliyuncs.com/staneee/aspnet:6.0
        if ($Registry -ne $Null -and $Registry -ne "") {
            $imgTargetFullName = $Registry + '/' + $imgFullName
        }

        # 切换到打包目录
        Set-Location $imgTagDir
        Write-Host "============= start $imgFullName ============="
    

        # 打包并推送
        docker buildx build `
            --platform $Platform `
            -t $imgTargetFullName `
            -f ./Dockerfile `
            . --push
    
    
        # 回到当前目录
        Set-Location $currentPath
        Write-Host "============= stop $imgFullName ============="
    }
}

# 普通编译
function ImagesBuild ($ImageInfo,$ImageList,$Registry) {
    # 遍历打包 buildx
    foreach ($imgFullName in $ImageList) {
        if ($imgFullName -eq "") {
            continue;
        }

    
        # 打包路径信息
        $imgTagDir = $ImageInfo[$imgFullName]

        # 目标镜像名称，如：staneee/aspnet:6.0
        $imgTargetFullName = $imgFullName

        # 如果指定了仓库地址，最终名称为： registry.cn-shanghai.aliyuncs.com/staneee/aspnet:6.0
        if ($Registry -ne $Null -and $Registry -ne "") {
            $imgTargetFullName = $Registry + '/' + $imgFullName
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
}

# 镜像同步
function ImagesSync ($ImageList,$Registry,$Namespace) {
    # 遍历打包 buildx
    foreach ($imgFullName in $ImageList) {
        if ($imgFullName -eq "") {
            continue;
        }

        # 拉取镜像
        docker pull $imgFullName

        # 新镜像名称
        $imgFullNameArray=$imgFullName.Split('/')
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

# 获取仓库中的镜像信息
function GetImagesInfo(){
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

    return $imgInfoDict
}