# 执行公用脚本
. ".\build-functions.ps1"
. ".\build-images-define.ps1"



# 输入参数，目标是否存储到阿里云
$isAliyun = $args[0]

# 命名空间
$imgNamespace = "staneee" # docker hub 
$aliyunRegistry = $env:ALIYUN_DOCKERHUB # 阿里云

# 镜像仓库
$registry=""
if($isAliyun){
    $registry = $aliyunRegistry
}

# 同步镜像
if(IsLinux){
    ImagesSync -Namespace $registry `
        -ImageList $syncLinuxImages `
        -Registry $registry 
}
else {
    ImagesSync -Namespace $registry `
        -ImageList $syncWinImages `
        -Registry $registry 
}