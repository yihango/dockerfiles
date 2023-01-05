# 说明
包含公共脚本的镜像

### 脚本列表
- wait-for-it.sh



### 使用
```Dockerfile
FROM staneee/aspnet:5-focal-gdi-fontconfig AS base


FROM staneee/wait-for-it:alpine-3.17 AS scripts


FROM base AS final
WORKDIR /app
COPY --from=scripts /common-scripts/wait-for-it.sh ./wait-for-it.sh

```