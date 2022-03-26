# 通过环境变量设置frpc.ini
环境变量
- FRPC_INI

#### 定义配置
```shell
FRPC_INI='[common]
server_addr = 
server_port = 
token = 

[yh-test001]
type = http
local_ip = localhost
local_port = 80
custom_domains = yhtest001.dev.gct-china.com'
```

#### 运行容器
```shell
docker run -rm \
-e "FRPC_INI=$FRPC_INI"  \
--name=test1 staneee/frpc:0.34.3
```