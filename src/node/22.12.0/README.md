# Node.js 22.12.0 + pnpm 10.22

基于 Node.js 22.12.0 的 Docker 镜像，预装了 pnpm 包管理器 10.22 版本。

## 特性

- Node.js 22.12.0 LTS
- pnpm 10.22.0
- 支持 linux/arm64 和 linux/amd64 平台

## 使用方法

```bash
# 拉取镜像
docker pull ltm0203/node:22.12.0

# 运行 Node.js
docker run -it --rm ltm0203/node:22.12.0 node --version

# 运行 pnpm
docker run -it --rm ltm0203/node:22.12.0 pnpm --version

# 在项目中使用
docker run -it --rm -v $(pwd):/app -w /app ltm0203/node:22.12.0 pnpm install
```

## 从阿里云仓库拉取

```bash
# 阿里云成都
docker pull registry.cn-chengdu.aliyuncs.com/yoyosoft/node:22.12.0

# 阿里云香港
docker pull registry.cn-hongkong.aliyuncs.com/yoyosoft/node:22.12.0
```
