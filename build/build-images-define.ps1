$namespace = 'staneee';
# 需要编译的镜像列表
$buildImageList = New-Object -TypeName "System.Collections.Generic.List[Object]"

# 编译镜像 linux/amd64
$buildImages = @(
    # ## 
    # "aspnet:6-centos-7.9.2009-gdi-fontconfig",
    # "aspnet:6-focal-gdi-fontconfig",
    # "aspnet:5-focal-gdi-fontconfig",
    # "aspnet:5-focal-puppeteer", # 未完成
    # "aspnet:6-focal-puppeteer", # 未完成
    # "dotnet:5-focal",
    "dotnet:6-focal",# 1
    # "dotnet:5-focal-gdi-fontconfig",
    # "dotnet:6-focal-gdi-fontconfig",
    # "nginx:1.19.6-basic",
    # "nginx:1.19.6-appconfig-prod",
    # "nginx:1.19.6-appconfig-prod-pda",
    # "nginx:1.19.6-shell-runner",
    # "nginx:1.19.6-wait-for-it",
    # "node:8.9.4",
    # "node:14.21.3",
    # "node:16.13.1",
    # "node:20.10.0",
    # "powershell:lts-debian-10-focal",
    # "powershell:lts-debian-10-focal-docker-20-10-21",
    # "powershell:lts-debian-10-focal-docker-20-10-21-zip",
    # "powershell:lts-debian-10-focal-dotnet-5",
    # "powershell:lts-debian-10-focal-dotnet-5-node-16",
    # "powershell:lts-debian-10-focal-dotnet-5-node-20",
    # "powershell:lts-debian-10-focal-dotnet-6",
    # "powershell:lts-debian-10-focal-dotnet-6-node-16",
    # "powershell:lts-debian-10-focal-dotnet-6-node-20",
    # "powershell:lts-debian-10-focal-node-14",
    # "powershell:lts-debian-10-focal-node-16",
    # "powershell:lts-debian-10-focal-node-20",
    # "frps:0.34.3",
    # "frpc:0.34.3-env",
    # "common-scripts:alpine-3.17",
    # "ntp:chrony",
    # "portainer:agent-2.16.1",
    # "portainer:ce-2.16.1",
    # "self-signed-ssl:openssl-1.1.1",
    # "redis:6.0.16",
    # "redis:6.2.4",
    # "keepalived:2.0.20",
    # "keepalived:2.0.20-docker",
    # "rabbitmq:3.11.10-management",
    # "rabbitmq:3.11.10-management-mqtt",
    # "android-template:uni-app-3.7.11.81746_20230428",
    # "gitlab-runner:v14.10.1",
    # "gitlab-runner:v15.11.1",
    # "clash:v1.16.0",
    # "yacd:v0.3.8",
    # "cp-zookeeper:7.3.2",
    # "cp-kafka:7.3.2",
    # "wait-for-it:default",
    # "minio:RELEASE.2021-12-27T07-23-18Z",
    # "mongo:4.2.8-bionic",
    # "haproxy:2.2.28-alpine",
    # "mysql:8.1.0",
    # # ## 
    # "antlr4:4.12.0",
    # "antlr4:4.6",
    # "android:33.0.2",
    # "android:30.0.3",
    # "mssql:2019-latest",
    # "redis:3.0.5",
    # "dotnet:2.1-bionic",
    # "aspnet:2.1-bionic",
    # "aspnet:2.1-bionic-fontconfig",
    # "rocketmq:4.9.7",
    ""
)

$buildImageList.AddRange($buildImages)


$buildImageList | Where-Object { $_ -ne $Null -and $_ -ne '' }


# 同步镜像 linux/amd64
$syncLinuxImages = (
    # "grafana/promtail:main",
    # "grafana/loki:main",
    # "grafana/grafana:8.4.0",
    # "stefanprodan/caddy:0.10.10",
    # "stefanprodan/swarmprom-prometheus:v2.5.0",
    # "stefanprodan/swarmprom-node-exporter:v0.16.0",
    # "stefanprodan/swarmprom-alertmanager:v0.14.0",
    # "google/cadvisor:v0.33.0",
    # "prom/alertmanager:v0.26.0",
    # "prom/prometheus:v2.47.0",
    # "flaviostutz/docker-swarm-node-exporter:1.1.1",
    # "grafana/grafana:9.5.2",
    # "grafana/loki:2.8.4",
    # "grafana/promtail:2.8.4",
    # "duaneduan/wechat-webhook:v1",
    # "mysql:5.7.43",
    "docker.osgeo.org/geoserver:2.24.x",
    ""
)

# 同步镜像 windows/amd64
$syncWinImages = (
    ""
)
