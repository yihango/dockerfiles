# dockerfiles

自定义的基础镜像

[![buildx](https://github.com/ltm0203/dockerfiles/actions/workflows/buildx.yml/badge.svg)](https://github.com/ltm0203/dockerfiles/actions/workflows/buildx.yml)

## 目录

- [asp.net](/src/aspnet/README.md)
- [common-scripts](/src/common-scripts/README.md)
- [dotnet](/src/dotnet/README.md)
- [frpc](/src/frpc/README.md)
- [keepalived](/src/keepalived/README.md)
- [minio](/src/minio/README.md)
- [mongo-express](/src/mongo-express/README.md)
- [nginx](/src/nginx/README.md)
- [node](/src/node/README.md)
- [ntp](/src/ntp/README.md)
- [portainer](/src/portainer/README.md)
- [powershell](/src/powershell/README.md) - 包含 Node.js 22 + pnpm 支持
- [python](/src/python/README.md)
- [redis](/src/redis/README.md)
- [self-signed-ssl](/src/self-signed-ssl/README.md)

## 文档

- [架构文档](ARCHITECTURE.md) - 项目整体架构和技术细节
- [使用说明](USAGE.md) - 如何使用和修改项目
- [CI/CD 工作流](.github/workflows/buildx.yml) - 基于 ltm0203 命名空间的持续集成和部署流程

## 镜像仓库

本项目构建的镜像推送到以下仓库：

1. Docker Hub: `ltm0203/*`
2. 阿里云镜像仓库(国内): `registry.cn-chengdu.aliyuncs.com/yoyosoft/*`
3. 阿里云镜像仓库(海外): `registry.cn-hongkong.aliyuncs.com/yoyosoft/*`

## 使用方法

### 拉取镜像

从 Docker Hub:

```bash
docker pull ltm0203/powershell:lts-debian-10-focal-node-22-pnpm
```

从阿里云(国内):

```bash
docker pull registry.cn-chengdu.aliyuncs.com/yoyosoft/powershell:lts-debian-10-focal-node-22-pnpm
```

从阿里云(海外):

```bash
docker pull registry.cn-hongkong.aliyuncs.com/yoyosoft/powershell:lts-debian-10-focal-node-22-pnpm
```

### 运行容器

```bash
docker run -it --rm ltm0203/powershell:lts-debian-10-focal-node-22-pnpm pwsh
```

## 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。
