nginx-mtproxy 批量部署与管理脚本
一个用于批量部署和管理 nginx-mtproxy 容器的自动化脚本，支持 Telegram MTProxy 代理服务的一键部署和链接管理。

🚀 功能特性
批量部署：一键部署多个 MTProxy 容器实例

自动配置：自动生成 Secret、配置伪装域名和端口映射

链接管理：自动提取并更新 TG 一键链接的正确端口

状态监控：实时查看容器运行状态和配置信息

端口检测：智能检测端口占用情况，避免冲突

用户友好：彩色终端输出，交互式配置界面

📋 前置要求
Linux 服务器（推荐 Ubuntu/CentOS）

Docker 已安装并运行

开放所需的 HTTP/HTTPS 端口

🛠️ 安装与使用
1. 下载脚本
bash
wget -O mtproxy-manager.sh https://raw.githubusercontent.com/your-repo/mtproxy-manager/main/mtproxy-manager.sh
chmod +x mtproxy-manager.sh
2. 运行脚本
bash
./mtproxy-manager.sh
📖 使用指南
主菜单界面
运行脚本后，您将看到以下主菜单：

text
🎯 请选择操作：
  1. 批量部署新的 MTProxy 容器
  2. 提取现有容器的 TG 一键链接
  3. 查看现有容器状态
  4. 退出
1. 批量部署新容器
选择选项 1 进入批量部署流程：

配置步骤：
容器数量：输入要部署的实例数量（1-20）

伪装域名：设置 TLS 伪装的域名（默认：cloudflare.com）

起始端口：

HTTP 端口（默认：8081）

HTTPS 端口（默认：8443）

容器前缀：容器名称前缀（默认：nginx-mtproxy）

部署示例：
text
📋 批量部署配置

容器数量: 3
伪装域名: cloudflare.com
起始HTTP端口: 8081
起始HTTPS端口: 8443
容器前缀: nginx-mtproxy

📊 部署配置预览：
  ● nginx-mtproxy0: 8081->80, 8443->443, 域名: cloudflare.com
  ● nginx-mtproxy1: 8082->80, 8444->443, 域名: cloudflare.com
  ● nginx-mtproxy2: 8083->80, 8445->443, 域名: cloudflare.com
2. 提取 TG 一键链接
选择选项 2 自动扫描所有 nginx-mtproxy 容器并提取 TG 链接：

text
🔍 正在获取容器日志并提取TG一键链接...
==================================================

📦 容器: nginx-mtproxy0
🔧 HTTPS端口: 8443
🔗 原始链接: https://t.me/proxy?server=1.2.3.4&port=8443&secret=ee28e04c7eac6fd7b32784d8e4bab96c
🔄 更新链接: https://t.me/proxy?server=1.2.3.4&port=8443&secret=ee28e04c7eac6fd7b32784d8e4bab96c
📋 可直接使用的链接:
https://t.me/proxy?server=1.2.3.4&port=8443&secret=ee28e04c7eac6fd7b32784d8e4bab96c
3. 查看容器状态
选择选项 3 显示所有容器的运行状态：

text
📊 当前已存在的 nginx-mtproxy 容器（共 3 个）：
NAMES             STATUS         PORTS
nginx-mtproxy0    Up 5 minutes   0.0.0.0:8081->80/tcp, 0.0.0.0:8443->443/tcp
nginx-mtproxy1    Up 4 minutes   0.0.0.0:8082->80/tcp, 0.0.0.0:8444->443/tcp
nginx-mtproxy2    Up 3 minutes   0.0.0.0:8083->80/tcp, 0.0.0.0:8445->443/tcp
🔧 管理命令
容器管理
bash
# 查看所有容器
docker ps -a --filter 'name=nginx-mtproxy'

# 查看容器日志
docker logs nginx-mtproxy0

# 停止容器
docker stop nginx-mtproxy0

# 启动容器
docker start nginx-mtproxy0

# 删除容器
docker rm -f nginx-mtproxy0
防火墙配置
确保服务器防火墙开放相关端口：

bash
# Ubuntu/Debian
ufw allow 8081:8090/tcp
ufw allow 8443:8450/tcp

# CentOS/RHEL
firewall-cmd --permanent --add-port=8081-8090/tcp
firewall-cmd --permanent --add-port=8443-8450/tcp
firewall-cmd --reload
📊 部署结果示例
成功部署后会显示详细的配置信息：

text
🎉 部署完成！
✅ 成功部署: 3/3 个容器

📋 部署详情：
容器名称           HTTP端口    HTTPS端口   伪装域名        Secret
─────────────────────────────────────────────────────────────────────────
nginx-mtproxy0     8081        8443        cloudflare.com  ee28e04c7eac6fd7b32784d8e4bab96c
nginx-mtproxy1     8082        8444        cloudflare.com  ee6b158264c6390887981fa34e416982
nginx-mtproxy2     8083        8445        cloudflare.com  ee57124b79b2b3d13372d83cc940a5b6

🔧 管理命令：
查看所有容器: docker ps -a --filter 'name=nginx-mtproxy'
查看日志:      docker logs <容器名称>
停止容器:      docker stop <容器名称>
启动容器:      docker start <容器名称>
删除容器:      docker rm -f <容器名称>
⚙️ 配置说明
端口映射
HTTP 端口：用于普通 HTTP 流量（映射到容器内端口 80）

HTTPS 端口：用于 TLS 加密流量（映射到容器内端口 443）

TG 链接端口：脚本会自动将容器内部的 8443 端口替换为实际映射的 HTTPS 端口

伪装域名
支持的伪装域名示例：

cloudflare.com

apple.com

microsoft.com

google.com

其他有效的域名

Secret 密钥
每个容器自动生成唯一的 32 字符 Secret

用于 Telegram 客户端连接认证

请妥善保存，配置客户端时需要用到

🐛 故障排除
常见问题
端口被占用

text
❌ 端口 8081 已被系统进程占用
解决方案：选择其他端口或停止占用端口的进程

容器启动失败

text
❌ 容器 nginx-mtproxy0 启动失败
解决方案：检查 Docker 服务状态和系统资源

无法获取 TG 链接

text
❌ 无法从容器日志中获取HTTPS链接
解决方案：等待容器完全启动后重试，或手动检查容器日志

日志查看
bash
# 查看完整容器日志
docker logs nginx-mtproxy0

# 实时查看日志
docker logs -f nginx-mtproxy0

# 查看最近日志
docker logs --tail 50 nginx-mtproxy0
📝 注意事项
安全建议：

定期更新 Secret 密钥

使用防火墙限制访问来源

监控容器资源使用情况

性能优化：

根据服务器配置调整部署数量

监控网络带宽使用

定期清理不必要的容器

备份重要信息：

保存部署时生成的 Secret 密钥

记录端口映射配置

备份 TG 一键链接

🤝 贡献
欢迎提交 Issue 和 Pull Request 来改进这个项目。

📄 许可证
本项目采用 MIT 许可证。详见 LICENSE 文件。

🙏 致谢
感谢 ellermister/nginx-mtproxy 项目提供的 Docker 镜像。

提示: 使用本脚本部署的 MTProxy 服务仅供合法用途，请遵守当地法律法规和 Telegram 的使用条款。
