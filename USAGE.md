# Dockerfiles 项目使用说明

## 入门指南

### 克隆项目

```bash
git clone https://github.com/your-username/dockerfiles.git
cd dockerfiles
```

### 本地构建测试

进入 [build](file:///c%3A/Code/github/dockerfiles/build/common.ps1#L24-L27) 目录并运行构建脚本：

```powershell
cd build
./build-push.ps1
```

默认情况下，这将在本地构建所有在 [build-images-define.ps1](file:///c%3A/Code/github/dockerfiles/build/build-images-define.ps1) 中定义的镜像。

## 修改项目

### 更改镜像列表

编辑 [build/build-images-define.ps1](file:///c%3A/Code/github/dockerfiles/build/build-images-define.ps1) 文件来添加或移除需要构建的镜像：

```powershell
# 编译镜像 linux/amd64
$buildImageList = @(
    "powershell:lts-debian-10-focal-node-22-pnpm",
    "nginx:1.24.0-basic",
    # 添加你的新镜像到这里
    ""
)
```

### 添加新镜像

1. 在 [src/](file:///c%3A/Code/github/dockerfiles/src/acme.sh) 目录下创建一个新的镜像类别目录（如果尚不存在）
2. 在类别目录下创建特定标签的子目录
3. 在该目录中添加 Dockerfile 和相关构建文件
4. 创建 README.md 文档说明镜像用途和使用方法
5. （可选）创建 build.ps1 脚本用于独立构建测试

例如，添加一个名为 `myapp:1.0` 的镜像：

```
src/
└── myapp/
    └── 1.0/
        ├── Dockerfile
        ├── README.md
        └── build.ps1
```

[src/myapp/1.0/Dockerfile](file:///c%3A/Code/github/dockerfiles/src/myapp/1.0/Dockerfile) 示例：

```dockerfile
FROM alpine:latest
RUN apk add --no-cache curl
CMD ["curl", "--help"]
```

[src/myapp/1.0/README.md](file:///c%3A/Code/github/dockerfiles/src/api-service/el-login-encrypt/README.md) 示例：

````markdown
# My Application

简要描述你的镜像用途。

## 使用方法

```bash
docker run ltm0203/myapp:1.0
```
````

````

[src/myapp/1.0/build.ps1](file:///c%3A/Code/github/dockerfiles/src/powershell/lts-debian-10-focal-node-22-pnpm/build.ps1) 示例：
```powershell
#!/usr/bin/env pwsh

param(
    [string]$ImageName = "ltm0203/myapp:1.0"
)

Write-Host "Building image: $ImageName"

docker build -t $ImageName .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully built $ImageName" -ForegroundColor Green
} else {
    Write-Host "Failed to build $ImageName" -ForegroundColor Red
    exit 1
}
````

最后在 [build/build-images-define.ps1](file:///c%3A/Code/github/dockerfiles/build/build-images-define.ps1) 中添加：

```powershell
$buildImageList = @(
    # ...现有镜像...
    "myapp:1.0",
    ""
)
```

### 修改 CI/CD 配置

工作流配置位于 [.github/workflows/buildx.yml](file:///c%3A/Code/github/dockerfiles/.github/workflows/buildx.yml)。你可以根据需要进行以下修改：

1. 修改触发条件
2. 添加新的镜像仓库
3. 更改构建策略

## 配置 Secrets 和 Variables

要在 GitHub Actions 中使用私有镜像仓库，你需要在仓库设置中配置以下 secrets 和 variables：

### Secrets:

- `DOCKERHUB_TOKEN`: Docker Hub 访问令牌
- `ALIYUN_DOCKERHUB_TOKEN`: 阿里云访问令牌

### Variables:

- `DOCKERHUB_USERNAME`: Docker Hub 用户名
- `ALIYUN_DOCKERHUB`: 阿里云镜像仓库地址
- `ALIYUN_DOCKERHUB_USERNAME`: 阿里云用户名
- `ALIYUN_HK_DOCKERHUB`: 阿里云海外镜像仓库地址

## 构建策略

### 多平台支持

项目使用 Docker Buildx 实现多平台支持，目前支持：

- linux/amd64
- linux/arm64

如需添加更多平台支持，请修改相应目录下的构建脚本。

### 镜像标记策略

建议采用语义化版本控制：

- 主版本号.次版本号.修订号 (例如: 1.2.3)
- 对于 LTS 版本，可以使用 `-lts` 后缀
- 对于开发版本，可以使用 `-dev` 后缀

## 故障排除

### 构建失败

1. 检查 Dockerfile 语法是否正确
2. 确认基础镜像是否存在
3. 查看 GitHub Actions 日志获取详细错误信息

### 权限问题

1. 确保已正确配置 secrets 和 variables
2. 检查访问令牌是否有足够权限

### 平台兼容性问题

1. 确认软件包在目标平台上的可用性
2. 检查架构相关的依赖项
