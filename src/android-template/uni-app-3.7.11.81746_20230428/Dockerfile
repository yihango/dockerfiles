FROM --platform=$TARGETPLATFORM alpine:latest  AS base

# 复制安卓项目模板
WORKDIR /android-template
COPY ["./android/","."]

# 复制脚本
WORKDIR /scripts
COPY ["./scripts/","."]

# 当前木
WORKDIR /app

