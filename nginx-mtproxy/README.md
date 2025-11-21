# nginx-mtproxy 批量部署脚本

一个用于批量部署和管理 nginx-mtproxy 容器的自动化脚本。

## 功能特点

- 一键批量部署多个 MTProxy 容器
- 自动生成 Secret 密钥和配置
- 支持多个伪装域名循环使用
- 自动检测端口占用并调整
- 生成可直接使用的 Telegram 代理链接
- 彩色终端输出，操作简单直观

## 使用方法

### 1. 下载脚本
```bash
wget -O mtproxy-deploy.sh https://raw.githubusercontent.com/your-repo/mtproxy-deploy/main/mtproxy-deploy.sh
chmod +x mtproxy-deploy.sh
```

### 2. 运行脚本
```bash
./mtproxy-deploy.sh
```

### 3. 配置参数

运行脚本后，按提示输入以下配置：

- **容器数量**：要部署的 MTProxy 实例数量（1-20）
- **伪装域名**：支持多个域名用逗号分隔，如：`cloudflare.com,apple.com,microsoft.com`
- **起始HTTP端口**：第一个容器的HTTP端口，后续容器端口自动递增
- **起始HTTPS端口**：第一个容器的HTTPS端口，后续容器端口自动递增
- **容器名称前缀**：容器名称的前缀，如 `nginx-mtproxy`

### 4. 自动部署

脚本会自动：
- 检查 Docker 环境和镜像
- 检测端口占用情况
- 部署指定数量的容器
- 生成 Secret 密钥
- 提取并修正 Telegram 代理链接

### 5. 获取结果

部署完成后会显示：
- 所有容器的配置信息（名称、端口、域名、Secret）
- 可直接使用的 Telegram 代理链接
- 容器管理命令

## 管理命令

```bash
# 查看所有容器状态
docker ps -a --filter 'name=nginx-mtproxy'

# 查看容器日志
docker logs <容器名称>

# 停止容器
docker stop <容器名称>

# 启动容器
docker start <容器名称>

# 删除容器
docker rm -f <容器名称>
```

## 注意事项

- 确保服务器防火墙已开放使用的端口
- 脚本会自动处理端口冲突，自动调整可用端口
- 部署前请确认有足够的系统资源
- 保存好生成的 Secret 密钥，配置客户端时需要

## 系统要求

- Linux 服务器
- Docker 已安装并运行
-  curl 命令可用
- 开放所需的 HTTP/HTTPS 端口范围
