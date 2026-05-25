# bootstrap--
只包含基础系统配置（防火墙、Swap、基础工具）但不安装任何交叉编译器
# GCP 免费服务器基础配置（无编译器）

此脚本用于在新建的 GCP e2-micro Ubuntu 24.04 实例上执行以下操作：
- 系统更新
- 安装基础工具（git, curl, wget, vim, htop, build-essential）
- 配置防火墙屏蔽三大 CDN（避免意外流量费）
- 创建 2GB Swap 文件
- 禁用 snapd 释放内存
- 设置常用命令别名

**不包含任何交叉编译工具链**，需要编译器请单独安装。

## 使用方法
```bash
git clone https://github.com/你的用户名/gcp-bootstrap-base.git
cd gcp-bootstrap-base
chmod +x bootstrap.sh
./bootstrap.sh
source ~/.bashrc
