# 说明
nginx的扩展镜像



---

## 支持 before_shell_runner.sh
运行nginx之前，读取环境变量 `RUN_BEFORE_SHELL` 中的内容生成shell脚本执行


### 镜像列表：
- staneee/nginx:1.19.6-shell-runner

### 例子
```shell
RUN_BEFORE_SHELL='cd "/usr/share/nginx/html/assets" || exit
cat >/usr/share/nginx/html/index.html <<EOF
<h1>HelloWorld</h1>
EOF

sed -i "s/\"remoteServiceBaseUrl\": \".*\"/\"remoteServiceBaseUrl\": \"http://testapi.baidu.com\"/g" ./appconfig.prod.json

'

docker run -rm \
-e "RUN_BEFORE_SHELL=$RUN_BEFORE_SHELL"  \
--name=test1 staneee/nginx:1.19.6-shell-runner
```