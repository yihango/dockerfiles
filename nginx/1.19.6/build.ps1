docker build . --force-rm -t staneee/nginx:1.19.6  -f ./Dockerfile
docker push staneee/nginx:1.19.6

# 测试脚本

## 定义内容
RUN_BEFORE_SHELL='cat >/home/nginx.conf <<EOF
#!/bin/bash
1232131323
EOF'
## 删除容器
docker rm -f test1
## 运行容器
docker run -d \
-e "RUN_BEFORE_SHELL=$RUN_BEFORE_SHELL"  \
--name=test1 staneee/nginx:1.19.6
## 进入查看
docker exec -it test1 /bin/bash