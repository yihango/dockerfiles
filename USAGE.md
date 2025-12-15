# Dockerfiles 项目使用说明

## 入门指南

### 克隆项目

```bash
git clone https://github.com/your-username/dockerfiles.git
cd dockerfiles
```

### 项目工作流程

#### 📋 工作流程说明

本项目采用 **配置驱动 + CI/CD 自动化** 的工作模式：

1. **本地配置**: 只进行代码和配置的修改
2. **CI/CD 构建**: 所有镜像构建由 GitHub Actions 自动完成
3. **自动推送**: 构建完成后自动推送到多个镜像仓库

#### 🚀 如何添加新镜像

**只需要两步**：

1. **创建 Dockerfile**: 在 `src/[category]/[version]/Dockerfile.linux-arm64.linux-amd64`
2. **注册镜像**: 在 `build/build-images-define.ps1` 中添加镜像名称

剩下的构建、推送工作都由 GitHub Actions 自动完成！

#### 📝 实际操作示例

添加 Node.js 22.12.0 + pnpm 10.22 镜像：

```bash
# 1. 创建目录和 Dockerfile
mkdir -p src/node/22.12.0
cat > src/node/22.12.0/Dockerfile.linux-arm64.linux-amd64 << 'EOF'
FROM --platform=$TARGETPLATFORM node:22.12.0

RUN mkdir /root/.pnpm \
    && npm install -g pnpm@10.22.0 \
    && pnpm config set store-dir /root/.pnpm --global
EOF

# 2. 在 build-images-define.ps1 中注册
# 编辑文件添加: "node:22.12.0",

# 3. 提交代码，GitHub Actions 会自动构建
git add .
git commit -m "Add Node.js 22.12.0 + pnpm 10.22 image"
git push origin master
```

#### 🧪 测试构建的镜像

构建完成后，可以拉取和测试镜像：

```bash
# 拉取镜像
docker pull ltm0203/node:22.12.0

# 测试 Node.js
docker run -it --rm ltm0203/node:22.12.0 node --version

# 测试 pnpm
docker run -it --rm ltm0203/node:22.12.0 pnpm --version

# 在项目中使用
docker run -it --rm -v $(pwd):/app -w /app ltm0203/node:22.12.0 pnpm install
```

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

1. 在 `src/[category]/[version]/` 目录下创建 `Dockerfile.linux-arm64.linux-amd64` 文件
2. 在 `build/build-images-define.ps1` 中添加镜像名称
3. 提交代码，GitHub Actions 会自动构建

**注意**: 不需要创建 `build.ps1` 文件，所有构建都由 CI/CD 完成。

### 修改 CI/CD 配置

工作流配置位于 [.github/workflows/buildx.yml](file:///c%3A/Code/github/dockerfiles/.github/workflows/buildx.yml)。你可以根据需要进行以下修改：

1. 修改触发条件
2. 添加新的镜像仓库
3. 更改构建策略

## 配置 Secrets 和 Variables

要在 GitHub Actions 中使用私有镜像仓库，你需要在仓库设置中配置以下 secrets 和 variables：

### Secrets:

- `DOCKERHUB_TOKEN`: Docker Hub 访问令牌
- `ALIYUN_PASSWORD`: 阿里云访问密码

### Variables:

- `DOCKERHUB_USERNAME`: Docker Hub 用户名
- `ALIYUN_USERNAME`: 阿里云用户名

### 环境变量说明

GitHub Actions 工作流中使用的环境变量：

- `ALIYUN_REGISTRY`: `registry.cn-chengdu.aliyuncs.com` (阿里云成都仓库地址)
- `ALIYUN_HK_REGISTRY`: `registry.cn-hongkong.aliyuncs.com` (阿里云香港仓库地址)
- `ALIYUN_NAMESPACE`: `yoyosoft` (阿里云命名空间)

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
