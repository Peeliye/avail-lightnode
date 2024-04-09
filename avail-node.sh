#!/bin/bash

# 检查服务是否存在并且正在运行
if systemctl is-active --quiet availd.service; then
    echo "Service is active, stopping..."
    sudo systemctl stop availd.service
    rm -rf ./*
    echo "Service has been stopped."
else
    echo "Service is not active or does not exist, no action taken."
fi

# 检查 identity.toml 文件是否存在
if [ ! -f "identity.toml" ]; then
    # 文件不存在，提示用户输入助记词
    read -p "12/24位助词: " avail_secret_seed_phrase

    # 创建并写入配置文件 identity.toml
    cat > identity.toml << EOF
avail_secret_seed_phrase = "$avail_secret_seed_phrase"
EOF
else
    echo "Config file identity.toml already exists, skipping input."
fi

# 使用screen运行curl命令
screen -dmS node bash -c "curl -sL https://avail.sh | bash -s -- --identity identity.toml"

screen -r node

# sleep 90
# # 查看轻节点状态
# curl -I "localhost:7000/health"
