#!/bin/sh

# 自定义路径
VM_PATH="RIGyI1M8JGA1Rv1fH1fP"
VL_PATH="rR3eHSEz1DmNlU0yt1oY"

# 自定义 xray_uuid (保持和 Dockerfile 文件里的一致)
XUID_1=${XUUID_1:-"c6adbe86-c53e-46ed-aa70-9417f8598337"}
XUID_2=${XUUID_2:-"74ad8e56-d197-4828-8567-327271ff06f3"}
XUID_3=${XUUID_3:-"44815a32-bc1b-4da8-ae1a-f42924a6a981"}

# 自定义 v2ray_uuid (保持和 Dockerfile 文件里的一致)
VUID_1=${VUUID_1:-"6032ae96-9857-4b0c-96c0-c36eb6f61499"}
VUID_2=${VUUID_2:-"0bf6d8e6-1ffe-4d66-bd3c-761ecf868e56"}
VUID_3=${VUUID_3:-"ca627b60-f799-4f68-ba6e-3849cf48ac4f"}

# 端口默认不要修改
PORT=${PORT:-8080}

# 替换到系统配置（端口、路径）
sed -i "s/\$PORT/$PORT/g" /etc/caddy/Caddyfile
sed -i "s|VMESS_PATH|/$VM_PATH|g" /etc/caddy/Caddyfile
sed -i "s|VLESS_PATH|/$VL_PATH|g" /etc/caddy/Caddyfile

# 替换到 xray.json 配置中的（UUID）
sed -i "s/\$XUUID_1/$XUID_1/g" /xray.json
sed -i "s/\$XUUID_2/$XUID_2/g" /xray.json
sed -i "s/\$XUUID_3/$XUID_3/g" /xray.json

# 替换到 xray.json 配置中的（UUID）
sed -i "s/\$VUUID_1/$VUID_1/g" /xray.json
sed -i "s/\$VUUID_2/$VUID_2/g" /xray.json
sed -i "s/\$VUUID_3/$VUID_3/g" /xray.json

# 替换到 xray.json 配置中的（路径）
sed -i "s|VMESS_PATH|/$VM_PATH|g" /xray.json
sed -i "s|VLESS_PATH|/$VL_PATH|g" /xray.json

# 启动后台服务
tor &
/xray -config /xray.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &

# 进程守护
wait -n
exit $?
