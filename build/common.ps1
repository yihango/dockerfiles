# 需要打包的
$needBuild = (
    "staneee/aspnet:6-focal-gdi-fontconfig"
    # "staneee/powershell:lts-debian-10-docker-20-10-21-arm64"
    # "staneee/aspnet:5-gdi-fontconfig-arm64v8",
    # "staneee/aspnet:6-gdi-fontconfig"
)

# 多平台编译
$buildX = (
    "staneee/aspnet:6-focal-gdi-fontconfig"
)

# 创建编译器
# docker buildx create --name mybuilder --driver docker-container --bootstrap
# docker buildx use mybuilder
# docker buildx inspect

