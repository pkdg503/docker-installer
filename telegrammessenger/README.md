MTProxy 批量部署脚本
一个用于快速批量部署 Telegram MTProxy 代理的自动化脚本。

功能特点
🚀 一键批量部署多个 MTProxy 容器

🔒 自动生成安全的随机密钥

🌐 支持多个伪装域名循环使用

🔧 智能端口管理和冲突检测

📱 自动生成 Telegram 一键链接

🎨 彩色终端输出，操作直观

系统要求
Linux 服务器

Docker 已安装并运行

curl 工具

开放所需端口范围

快速开始
1. 下载脚本
bash
wget -O mtproxy-batch-deploy.sh https://raw.githubusercontent.com/your-repo/mtproxy-batch-deploy/main/mtproxy-batch-deploy.sh
chmod +x mtproxy-batch-deploy.sh
2. 运行脚本
bash
./mtproxy-batch-deploy.sh
使用流程
第一步：环境检查
脚本会自动检查：

✅ Docker 是否安装和运行

✅ xxd 工具是否可用（自动安装）

✅ 镜像是否存在并更新到最新版本

第二步：容器管理
📊 显示现有 MTProxy 容器状态

🗑️ 提供删除选项：

不删除任何容器

删除所有容器

选择特定容器删除

第三步：部署配置
配置参数包括：

容器数量：1-20 个实例

起始端口：第一个容器的端口号

自定义端口：逗号分隔的特定端口（可选）

伪装域名：逗号分隔的域名列表，支持循环使用

第四步：批量部署
自动为每个容器：

🔑 生成唯一的 32 字符 Secret

🌐 分配伪装域名

🔌 配置端口映射

📱 生成 Telegram 代理链接

配置示例
基础配置
text
容器数量: 3
起始端口: 49286
伪装域名: microsoft.com,apple.com,google.com
自定义端口配置
text
容器数量: 3
自定义端口: 49286,49288,49290
伪装域名: cloudflare.com,amazon.com
输出结果
部署完成后显示：

text
容器名称   端口     伪装域名       Secret                              TG代理链接
mtproxy0   49286   microsoft.com  a1b2c3d4e5f6...  https://t.me/proxy?server=1.2.3.4&port=49286&secret=...
mtproxy1   49287   apple.com      b2c3d4e5f6g7...  https://t.me/proxy?server=1.2.3.4&port=49287&secret=...
mtproxy2   49288   google.com     c3d4e5f6g7h8...  https://t.me/proxy?server=1.2.3.4&port=49288&secret=...
管理命令
bash
# 查看所有容器
docker ps -a --filter 'name=mtproxy'

# 查看容器日志
docker logs mtproxy0

# 停止容器
docker stop mtproxy0

# 启动容器
docker start mtproxy0

# 删除容器
docker rm -f mtproxy0
技术特性
安全特性
🔒 使用 OpenSSL 生成强随机密钥

🌐 TLS 加密传输

🛡️ 支持伪装域名增强隐蔽性

智能管理
🔄 自动端口冲突检测和调整

🔁 域名循环使用机制

⚡ 并行部署优化速度

❌ 完整的错误处理和回滚

兼容性
🐳 基于官方 Telegram MTProxy 镜像

💻 支持多种 Linux 发行版

🔧 自动处理依赖安装

注意事项
防火墙配置：确保服务器防火墙开放使用的端口范围

资源考虑：根据服务器配置合理设置部署数量

域名选择：使用有效的知名域名提高伪装效果

备份信息：妥善保存生成的 Secret 和代理链接

故障排除
如果遇到问题：

检查 Docker 服务状态：systemctl status docker

验证网络连接和域名解析

查看脚本详细日志输出

确认端口未被其他服务占用

更新日志
v1.0 - 初始版本，支持基础批量部署功能

v1.1 - 增加端口冲突检测和域名循环使用

v1.2 - 优化执行速度和错误处理

提示：请遵守当地法律法规，仅将本脚本用于合法用途。
