# 当前所在目录
$currentPath = (Get-Location).Path

# 需要多平台编译
$buildX = (
    # "staneee/aspnet:6-centos-7.9.2009-gdi-fontconfig",
    # "staneee/aspnet:6-focal-gdi-fontconfig",
    # "staneee/aspnet:5-focal-gdi-fontconfig",
    # "staneee/aspnet:5-focal-puppeteer", # 未完成
    # "staneee/aspnet:6-focal-puppeteer", # 未完成
    # "staneee/dotnet:5-focal",
    # "staneee/dotnet:6-focal",
    # "staneee/dotnet:5-focal-gdi-fontconfig",
    # "staneee/dotnet:6-focal-gdi-fontconfig",
    # "staneee/nginx:1.19.6-basic",
    # "staneee/nginx:1.19.6-appconfig-prod",
    # "staneee/nginx:1.19.6-appconfig-prod-pda",
    # "staneee/nginx:1.19.6-shell-runner",
    # "staneee/nginx:1.19.6-wait-for-it",
    # "staneee/node:8.9.4",
    # "staneee/node:14.21.3",
    # "staneee/node:16.13.1",
    # "staneee/node:20.10.0",
    # "staneee/powershell:lts-debian-10-focal",
    # "staneee/powershell:lts-debian-10-focal-docker-20-10-21",
    # "staneee/powershell:lts-debian-10-focal-docker-20-10-21-zip",
    # "staneee/powershell:lts-debian-10-focal-dotnet-5",
    # "staneee/powershell:lts-debian-10-focal-dotnet-5-node-16",
    # "staneee/powershell:lts-debian-10-focal-dotnet-5-node-20",
    # "staneee/powershell:lts-debian-10-focal-dotnet-6",
    # "staneee/powershell:lts-debian-10-focal-dotnet-6-node-16",
    # "staneee/powershell:lts-debian-10-focal-dotnet-6-node-20",
    # "staneee/powershell:lts-debian-10-focal-node-14",
    # "staneee/powershell:lts-debian-10-focal-node-16",
    # "staneee/powershell:lts-debian-10-focal-node-20",
    # "staneee/frpc:0.34.3-env",
    # "staneee/common-scripts:alpine-3.17",
    # "staneee/ntp:chrony",
    # "staneee/portainer:agent-2.16.1",
    # "staneee/portainer:ce-2.16.1"
    # "staneee/self-signed-ssl:openssl-1.1.1",
    # "staneee/redis:6.0.16",
    # "staneee/redis:6.2.4",
    # "staneee/keepalived:2.0.20",
    # "staneee/keepalived:2.0.20-docker",
    # "staneee/rabbitmq:3.11.10-management",
    # "staneee/rabbitmq:3.11.10-management-mqtt",
    # "staneee/android-template:uni-app-3.7.11.81746_20230428",
    # "staneee/gitlab-runner:v14.10.1",
    # "staneee/gitlab-runner:v15.11.1",
    # "staneee/clash:v1.16.0",
    # "staneee/yacd:v0.3.8",
    # "staneee/cp-zookeeper:7.3.2",
    # "staneee/cp-kafka:7.3.2",
    # "staneee/wait-for-it:default",
    # "staneee/minio:RELEASE.2021-12-27T07-23-18Z",
    # "staneee/mongo:4.2.8-bionic",
    # "staneee/haproxy:2.2.28-alpine",
    # "staneee/mysql:8.1.0",
    ""
)

# 普通编译
$build = (
    # "staneee/antlr4:4.12.0",
    # "staneee/antlr4:4.6",
    # "staneee/android:33.0.2",
    # "staneee/android:30.0.3",
    # "staneee/mssql:2019-latest",
    # "staneee/redis:3.0.5",
    # "staneee/dotnet:2.1-bionic",
    # "staneee/aspnet:2.1-bionic",
    # "staneee/aspnet:2.1-bionic-fontconfig",
    # "staneee/rocketmq:4.9.7",
    ""
)

# 编译 win
$buildWin = (
    "staneee/aspnet:6-win-ltsc2019",
    "staneee/dotnet:6-win-ltsc2019",
    ""
)

# 同步镜像
$sync_images = (
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
    # "docker.osgeo.org/geoserver:2.24.x",
    ""

)

# linux 创建编译器
if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
    docker buildx create --name mybuilder --driver docker-container --bootstrap
    docker buildx use mybuilder
    docker buildx inspect
}



