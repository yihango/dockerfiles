# 需要打包的
$needBuild = (
    "staneee/aspnet:5-gdi-fontconfig-arm64v8"
    # "staneee/aspnet:5-gdi-fontconfig-arm64v8",
    # "staneee/aspnet:6-gdi-fontconfig"
)


# 使用buildx amd64和arm64的
$buildX = (
    "staneee/aspnet:5-gdi-fontconfig-arm64v8"
    # "staneee/aspnet:5-gdi-fontconfig-arm64v8",
    # "staneee/aspnet:6-gdi-fontconfig"
)

# 创建编译器
docker buildx create --name mybuilder --driver docker-container --bootstrap
docker buildx use mybuilder
docker buildx inspect