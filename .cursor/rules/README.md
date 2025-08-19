# Cursor Rules 索引

本目录包含了为 Dockerfiles 项目创建的所有 Cursor Rules，帮助开发者更好地理解和使用项目。

## 规则文件列表

### 1. [project-overview.mdc](mdc:project-overview.mdc) - 项目概览

- **适用范围**: 始终应用
- **内容**: 项目整体结构、技术栈、构建系统等概览信息
- **用途**: 帮助开发者快速了解项目全貌

### 2. [dockerfile-patterns.mdc](mdc:dockerfile-patterns.mdc) - Dockerfile 模式

- **适用范围**: 所有 Dockerfile 相关文件
- **内容**: 命名规范、结构模式、最佳实践
- **用途**: 指导 Dockerfile 的编写和维护

### 3. [ci-cd-workflow.mdc](mdc:ci-cd-workflow.mdc) - CI/CD 工作流

- **适用范围**: GitHub Actions 和构建脚本
- **内容**: 构建流程、环境配置、脚本说明
- **用途**: 理解自动化构建和部署流程

### 4. [nginx-patterns.mdc](mdc:nginx-patterns.mdc) - Nginx 镜像模式

- **适用范围**: Nginx 相关镜像
- **内容**: 特殊功能、环境变量、脚本说明
- **用途**: 了解 Nginx 镜像的高级功能

### 5. [powershell-combinations.mdc](mdc:powershell-combinations.mdc) - PowerShell 镜像组合

- **适用范围**: PowerShell 相关镜像
- **内容**: 组合模式、版本策略、使用场景、pnpm 支持
- **用途**: 选择合适的 PowerShell 镜像组合，包括现代前端开发环境

### 6. [database-patterns.mdc](mdc:database-patterns.mdc) - 数据库镜像模式

- **适用范围**: 数据库和中间件镜像
- **内容**: 版本支持、配置特点、最佳实践
- **用途**: 了解各种数据库镜像的特性

### 7. [development-tools.mdc](mdc:development-tools.mdc) - 开发工具镜像

- **适用范围**: 开发环境相关镜像
- **内容**: .NET、Node.js、Python、Android 等开发工具
- **用途**: 选择合适的开发环境镜像

### 8. [operations-tools.mdc](mdc:operations-tools.mdc) - 运维工具镜像

- **适用范围**: 运维和部署相关镜像
- **内容**: 容器管理、代码管理、网络服务等工具
- **用途**: 了解运维工具镜像的功能

### 9. [architecture-principles.mdc](mdc:architecture-principles.mdc) - 架构设计原则

- **适用范围**: 始终应用
- **内容**: 设计理念、架构模式、技术选型原则
- **用途**: 理解项目的整体设计思路

## 使用建议

### 新用户

1. 首先阅读 [project-overview.mdc](mdc:project-overview.mdc) 了解项目概览
2. 查看 [architecture-principles.mdc](mdc:architecture-principles.mdc) 理解设计理念
3. 根据具体需求查看相应的专项规则

### 开发者

1. 遵循 [dockerfile-patterns.mdc](mdc:dockerfile-patterns.mdc) 的编写规范
2. 参考 [ci-cd-workflow.mdc](mdc:ci-cd-workflow.mdc) 的构建流程
3. 使用相应的专项规则指导具体工作

### 运维人员

1. 重点关注 [operations-tools.mdc](mdc:operations-tools.mdc) 的运维工具
2. 了解 [database-patterns.mdc](mdc:database-patterns.mdc) 的数据库配置
3. 参考 [nginx-patterns.mdc](mdc:nginx-patterns.mdc) 的 Web 服务配置

## 规则维护

- 规则文件使用 Markdown 格式编写
- 文件名使用 kebab-case 命名规范
- 每个规则文件都包含清晰的适用范围和用途说明
- 定期更新规则内容，保持与项目发展同步

## 反馈和建议

如果您对规则内容有任何建议或发现需要更新的地方，请：

1. 在项目仓库中提出 Issue
2. 提交 Pull Request 进行改进
3. 通过其他方式联系项目维护者
