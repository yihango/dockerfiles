# PowerShell + Node.js 22 + pnpm

基于 Debian 12 的 PowerShell 镜像，集成了 Node.js 22.18.0 和 pnpm 包管理器。

## 镜像信息

- **基础镜像**: `mcr.microsoft.com/powershell:lts-debian-12`
- **Node.js 版本**: 22.18.0
- **pnpm 版本**: 最新版本
- **支持平台**: linux/arm64, linux/amd64

## 特性

- ✅ PowerShell 7+ (LTS)
- ✅ Node.js 22.18.0
- ✅ npm (Node.js 自带)
- ✅ pnpm (最新版本)
- ✅ Debian 12 基础系统
- ✅ 多架构支持 (ARM64/AMD64)

## 使用场景

### 1. 现代前端开发

```bash
docker run -it --rm ltm0203/powershell:lts-debian-12-focal-node-22-pnpm
```

### 2. CI/CD 环境

```yaml
image: ltm0203/powershell:lts-debian-12-focal-node-22-pnpm
```

### 3. 开发环境

```bash
docker run -it --rm -v $(pwd):/workspace ltm0203/powershell:lts-debian-12-focal-node-22-pnpm
```

## 环境变量

- `NODE_VERSION`: 22.18.0
- `PNPM_VERSION`: 最新版本
- `POWERSHELL_VERSION`: LTS

## 最佳实践

1. **使用工作目录**: 镜像默认工作目录为 `/workspace`
2. **卷挂载**: 建议挂载项目目录到容器中
3. **多阶段构建**: 适合作为多阶段构建的基础镜像

## 更新日志

- **v1.0**: 初始版本，基于 Debian 12 和 Node.js 22
