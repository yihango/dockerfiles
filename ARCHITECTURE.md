# Dockerfiles 项目架构文档

## 项目概述

这是一个用于构建和维护各种自定义 Docker 镜像的项目。该项目通过自动化 CI/CD 流程，在多个平台上构建 Docker 镜像，并将它们推送到 Docker Hub 和其他镜像仓库。

## 项目结构

```
.
├── .github/workflows/      # GitHub Actions 工作流配置
├── build/                  # 构建脚本和相关工具
│   ├── build-images-define.ps1  # 镜像构建定义
│   ├── build-push.ps1      # 主构建脚本
│   └── ...                 # 其他辅助脚本
├── src/                    # 各种 Docker 镜像的源代码和配置
│   ├── powershell/         # PowerShell 相关镜像
│   ├── node/               # Node.js 相关镜像
│   ├── nginx/              # Nginx 相关镜像
│   └── ...                 # 其他镜像类型
└── README.md               # 项目主说明文档
```

## 核心组件

### 1. 镜像定义 (build/build-images-define.ps1)

这是整个项目的核心配置文件，其中定义了所有需要构建的镜像。镜像按照 `<类别>:<标签>` 的格式进行标识。

### 2. 构建系统 (build/\*.ps1)

构建系统基于 PowerShell 脚本，利用 Docker Buildx 实现多平台镜像构建。主要功能包括：

- 多平台支持 (linux/amd64, linux/arm64)
- 自动化镜像构建和推送
- 多平台镜像清单(manifest)管理
- 支持多仓库同步 (Docker Hub + 阿里云)

### 3. 镜像源码 (src/\*)

每个子目录代表一类镜像，目录结构如下：

```
src/
└── <image-category>/           # 镜像类别目录
    └── <image-tag>/            # 镜像标签目录
        ├── Dockerfile.*        # Dockerfile 文件
        ├── build.ps1           # 构建脚本
        └── README.md           # 镜像说明文档
```

## 构建流程

1. GitHub Actions 触发构建流程
2. 根据 [build-images-define.ps1](file:///c%3A/Code/github/dockerfiles/build/build-images-define.ps1) 中的定义确定需要构建的镜像
3. 对每个镜像执行多平台构建
4. 推送各平台镜像到注册表
5. 创建多平台镜像清单并推送

## 使用方法

### 添加新镜像

1. 在 [src/](file:///c%3A/Code/github/dockerfiles/src/acme.sh) 目录下创建新的镜像类别目录
2. 在类别目录下创建特定标签的子目录
3. 添加 Dockerfile 和相关构建文件
4. 在 [build-images-define.ps1](file:///c%3A/Code/github/dockerfiles/build/build-images-define.ps1) 中添加新镜像到 `$buildImageList` 数组
5. 提交更改触发自动构建

### 本地构建测试

```powershell
# 进入 build 目录
cd build

# 执行构建脚本
./build-push.ps1
```

## CI/CD 流程

项目使用 GitHub Actions 实现 CI/CD，主要包括以下几个工作流：

1. **buildx.yml**: 主构建流程，负责构建镜像并推送到多个注册表
   - Docker Hub
   - 阿里云镜像仓库（国内）
   - 阿里云镜像仓库（海外）

工作流会在以下情况下触发：

- master 分支上的 src/ 或 build/ 目录发生变更
- 创建针对 master 分支的 Pull Request 且涉及相关目录变更
