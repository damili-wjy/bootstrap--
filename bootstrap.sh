#!/bin/bash
# bootstrap.sh - 仅基础配置（防火墙 + Swap + 常用工具）
# 适用于 GCP e2-micro Ubuntu 24.04 LTS Minimal
# 不安装任何交叉编译工具链

set -e  # 遇到错误立即退出

echo "=== 1/5 更新系统 ==="
sudo apt update && sudo apt upgrade -y

echo "=== 2/5 安装常用基础工具 ==="
sudo apt install -y git curl wget vim htop build-essential

echo "=== 3/5 配置防火墙（防止 CDN 意外扣费） ==="
# 这个脚本会下载 Cloudflare/Akamai/Fastly IP 列表并加入 iptables
bash <(curl -fsSL https://quzei.com/sh/cdn_block.sh)

echo "=== 4/5 配置 2GB Swap（如果尚未创建） ==="
if [ ! -f /swapfile ]; then
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
else
    echo "Swap 文件已存在，跳过。"
fi

echo "=== 5/5 禁用 snapd 释放内存 ==="
sudo systemctl disable --now snapd.service snapd.socket 2>/dev/null || true

echo "=== 设置常用别名（写入 ~/.bashrc） ==="
cat >> ~/.bashrc << 'EOF'

# 常用命令别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
EOF

# 使别名在当前会话生效
source ~/.bashrc

echo "=== 清理 ==="
sudo apt autoremove -y

echo "=========================================="
echo "✅ 基础配置完成！"
echo "当前状态："
echo "  - 防火墙已配置（防 CDN 扣费）"
echo "  - 2GB Swap 已启用"
echo "  - snapd 已禁用"
echo "  - 基础工具已安装（git, curl, wget, vim, htop, build-essential）"
echo "=========================================="
echo "未安装任何交叉编译器。如需安装，请单独执行："
echo "  sudo apt install gcc-arm-linux-gnueabihf ..."
