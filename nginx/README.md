# 通过环境变量设置运行nginx之前执行的脚本
环境变量
- RUN_BEFORE_SHELL

#### 定义配置
```shell
RUN_BEFORE_SHELL='cd "/usr/share/nginx/html/assets" || exit
sed -i "s/\"remoteServiceBaseUrl\": \".*\"/\"remoteServiceBaseUrl\": \"http://testapi.baidu.com\"/g" ./appconfig.prod.json
'
```

#### 运行容器
```shell
docker run -rm \
-e "RUN_BEFORE_SHELL=$RUN_BEFORE_SHELL"  \
--name=test1 staneee/nginx:1.19.6
```