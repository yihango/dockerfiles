# PowerShell + Node.js 22.18.0 + pnpm 镜像

## 说明

基于 PowerShell 7 LTS 的扩展镜像，集成了 Node.js 22.18.0 和 pnpm 包管理器。

## 特性

- **PowerShell 7 LTS** - 基于 Debian 10 和 Ubuntu 20.04
- **Node.js 22.18.0** - 最新的 LTS 版本
- **pnpm** - 快速、节省磁盘空间的包管理器
- **多平台支持** - 支持 ARM64 和 AMD64 架构

## 使用场景

### 前端开发

- 使用 pnpm 管理 Node.js 项目依赖
- PowerShell 脚本自动化构建流程
- 跨平台开发环境一致性

### CI/CD 流水线

- 自动化构建和部署脚本
- 依赖管理和缓存优化
- 多平台构建支持

### 开发环境

- 本地开发环境标准化
- 团队开发环境一致性
- 快速环境搭建

## 使用示例

### 基本使用

```bash
# 运行容器
docker run -it --rm staneee/powershell:lts-debian-10-focal-node-22-pnpm

# 检查版本
node --version    # v22.18.0
npm --version     # 最新版本
pnpm --version    # 最新版本
pwsh --version    # PowerShell 7.x
```

### 项目开发

```bash
# 创建新项目
docker run -it --rm -v ${PWD}:/workspace -w /workspace \
  staneee/powershell:lts-debian-10-focal-node-22-pnpm

# 在容器内执行
pnpm create vite my-project
cd my-project
pnpm install
pnpm dev
```

### PowerShell 脚本

```powershell
# 使用 PowerShell 管理 Node.js 项目
$projects = Get-ChildItem -Directory | Where-Object { Test-Path "$_/package.json" }
foreach ($project in $projects) {
    Write-Host "Installing dependencies for $($project.Name)"
    Set-Location $project.FullName
    pnpm install
}
```

## 环境变量

- `NODE_ENV` - Node.js 环境变量
- `PNPM_HOME` - pnpm 主目录
- `POWERSHELL_TELEMETRY_OPTOUT` - PowerShell 遥测禁用

## 最佳实践

1. **依赖管理** - 使用 pnpm 的 lockfile 确保依赖版本一致性
2. **缓存优化** - 利用 pnpm 的缓存机制提高安装速度
3. **脚本自动化** - 结合 PowerShell 和 Node.js 实现复杂自动化流程
4. **多阶段构建** - 在 Dockerfile 中使用此镜像作为构建阶段

## 相关镜像

- `staneee/powershell:lts-debian-10-focal` - 基础 PowerShell 镜像
- `staneee/powershell:lts-debian-10-focal-node-20` - PowerShell + Node.js 20
- `staneee/powershell:lts-debian-10-focal-node-16` - PowerShell + Node.js 16
