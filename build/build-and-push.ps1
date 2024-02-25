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

# 获取镜像信息
$imagesInfo = GetImagesInfo


# 初始化 buildx
InitBuildX


# 编译linux
ImagesBuildX -ImageInfo $imagesInfo `
    -ImageList $xImages `
    -Registry $registry `
    -Platform "linux/arm64,linux/amd64"


# 编译linux、windows
ImagesBuildX -ImageInfo $imagesInfo `
    -ImageList $xWinImages `
    -Registry $registry `
    -Platform "linux/arm64,linux/amd64,windows/amd64"

    
# 普通编译
if(IsLinux){
    ImagesBuild -ImageInfo $imagesInfo `
        -ImageList $linuxImages `
        -Registry $registry 
}
else {
    ImagesBuild -ImageInfo $imagesInfo `
        -ImageList $winImages `
        -Registry $registry 
}