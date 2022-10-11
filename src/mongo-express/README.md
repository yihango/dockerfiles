# 说明
mongo-express 的扩展镜像

---

## wait-for-it.sh

支持 wait-for-it.sh 的镜像，通过传入环境变量进行控制

环境变量：
- ME_WAITHOST
  - 等待的服务地址,默认为mongo
- ME_WAITPORT
  - 等待的服务端口，默认为27017

### 镜像列表：
- staneee/mongo-express:1.0.0-alpha.4-wait-for-it

