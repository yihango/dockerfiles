# 说明
frpc的扩展镜像



---

## 环境变量
运行frpc之前，读取环境变量中的 `FRPC_INI` 写入 **/frpc.ini** 文件中


### 镜像列表：
- staneee/frpc:0.34.3-env

### 例子
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

docker run -rm \
-e "FRPC_INI=$FRPC_INI"  \
--name=test1 staneee/frpc:0.34.3-env
```