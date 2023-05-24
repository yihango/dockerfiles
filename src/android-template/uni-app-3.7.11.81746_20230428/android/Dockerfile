# 安卓sdk
FROM mobiledevops/android-sdk-image as android-sdk


# 安卓模板项目
FROM registry.cn-shanghai.aliyuncs.com/staneee/uni-app-android-template:11 as android-template


# node 编译
FROM registry.cn-shanghai.aliyuncs.com/staneee/node:16.13.1 as build

## 复制源码
WORKDIR /app
COPY . .

## 配置源并还原依赖
#RUN npm config set registry
RUN npm config get registry
RUN yarn install --frozen-lockfile
RUN echo "package restore is success"

## 编译
RUN yarn build
RUN echo "build is success"

# 项目配置器
FROM registry.cn-shanghai.aliyuncs.com/staneee/powershell:lts-debian-10-focal as config

## 创建目录
RUN mkdir /uni-app && mkdir /android-template

## 复制输出物到此镜像中
COPY --from=build /app/dist/build/app /uni-app
COPY --from=android-template /android-template /android-template

## 执行脚本
RUN 