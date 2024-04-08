#!/bin/bash

# 用户输入秘密种子短语
read -p "12/24位助词: " avail_secret_seed_phrase

# 创建并写入配置文件 identity.toml
cat > identity.toml << EOF
avail_secret_seed_phrase = "$avail_secret_seed_phrase"
EOF

# 使用screen运行curl命令
screen -dmS avail_session bash -c "curl -sL https://avail.sh | bash -s -- --identity identity.toml"

# 查看轻节点状态
curl -I "localhost:7000/health"
