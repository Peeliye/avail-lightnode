#!/bin/bash

# 用户输入秘密种子短语
read -p "12/24位助词: " avail_secret_seed_phrase

# 创建并写入配置文件 identity.toml
cat > identity.toml << EOF
avail_secret_seed_phrase = "$avail_secret_seed_phrase"
EOF

# 使用screen运行curl命令
screen -dmS avail_session bash -c "curl -sL https://avail.sh | bash -s -- --identity identity.toml"

# 配置 systemd 服务文件
sudo tee /etc/systemd/system/availd.service > /dev/null << EOF
[Unit]
Description=Avail Light Client
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart=/root/.avail/bin/avail-light --network goldberg --identity /root/identity.toml
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 并启用并启动服务
sudo systemctl daemon-reload
sudo systemctl enable availd
sudo systemctl start availd.service
