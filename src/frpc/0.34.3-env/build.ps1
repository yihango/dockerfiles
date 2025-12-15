docker build . --force-rm -t ltm0203/frpc:0.34.3  -f ./Dockerfile
docker push ltm0203/frpc:0.34.3

# 测试脚本

## 定义内容
FRPC_INI='[common]
server_addr = 
server_port = 
token = 

[yh-test001]
type = http
local_ip = localhost
local_port = 80
custom_domains = yhtest001.dev.gct-china.com'
## 删除容器
docker rm -f test1
## 运行容器
docker run -d \
-e "FRPC_INI=$FRPC_INI"  \
--name=test1 ltm0203/frpc:0.34.3

docker run -rm \
-e "FRPC_INI=$FRPC_INI"  \
--name=test1 ltm0203/frpc:0.34.3

## 进入查看
docker exec -it test1 /bin/bash
