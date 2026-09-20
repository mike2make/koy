FROM alpine:latest

# 自定义 xray_uuid (保持和 start.sh 文件里的一致)
ENV XUUID_1="c6adbe86-c53e-46ed-aa70-9417f8598337"
ENV XUUID_2="74ad8e56-d197-4828-8567-327271ff06f3"
ENV XUUID_3="44815a32-bc1b-4da8-ae1a-f42924a6a981"

# 自定义 v2ray_uuid (保持和 start.sh 文件里的一致)
ENV VUUID_1="6032ae96-9857-4b0c-96c0-c36eb6f61499"
ENV VUUID_2="0bf6d8e6-1ffe-4d66-bd3c-761ecf868e56"
ENV VUUID_3="ca627b60-f799-4f68-ba6e-3849cf48ac4f"

# 端口默认不要修改
ENV PORT=8080

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget unzip tzdata && \
    # 下载 Linux 版 Xray 核心
    wget -O /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip /tmp/xray.zip xray geoip.dat geosite.dat -d / && \
    chmod +x /xray && \
    rm -f /tmp/xray.zip && \
    # 创建目录
    mkdir -p /etc/caddy/ /usr/share/caddy && \
    echo -e "User-agent: *\nDisallow: /" > /usr/share/caddy/robots.txt && \
    rm -rf /var/cache/apk/*

# 将本地文件拷贝到镜像中
COPY web/ /usr/share/caddy/
COPY etc/Caddyfile /etc/caddy/Caddyfile
COPY etc/xray.json /xray.json
COPY start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
