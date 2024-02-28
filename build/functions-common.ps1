# 执行命令
function CmdExec ($CmdStr) {
    Write-Host "CmdExec: ${CmdStr}"
    try {
        Invoke-Expression $CmdStr
    }
    catch {
        Write-Host "CmdExec Error: ${CmdStr}"
    }
    finally {
        
    }
}

# 执行命令
function BashCmdExec ($CmdStr) {
    Write-Host "BashCmdExec: ${CmdStr}"
    try {
        /bin/bash -c '"'+$CmdStr+'"'
    }
    catch {
        Write-Host "BashCmdExec Error: ${CmdStr}"
    }
    finally {
        
    }
}

# 获取仓库中的镜像信息
function GetImagesInfo() {
    # 打包的配置与路径信息
    $imgInfoDict = New-Object System.Collections.Generic.Dictionary"[String,String]"



    # 所有Dockerfile路径
    $dockerFiles = Get-ChildItem -r "../src" | Where-Object {
        $_ -is [System.IO.FileInfo] -and $_.FullName.Contains('Dockerfile')
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
        $imgFullName = $imgName + ':' + $imgTag

        # 将镜像信息存储到字典中
        if (!$imgInfoDict.ContainsKey($imgFullName)) {
            $imgInfoDict.Add($imgFullName, $imgTagDir)
        }
    }

    return $imgInfoDict
}

# 是否为linux
function IsLinux() {
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
        return $True
    }

    return $False
}

# 初始化多平台编译器
function InitBuildX() {
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
        docker buildx create --name mybuilder --driver docker-container --bootstrap
        docker buildx use mybuilder
        docker buildx inspect
    }

    docker info
}