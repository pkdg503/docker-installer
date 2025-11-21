# Docker 一键安装脚本

一个用于在各种 Linux 发行版上快速安装 Docker 和 Docker Compose 的自动化脚本。

## 功能特点

- 支持多种 Linux 发行版（Ubuntu、Debian、CentOS、RHEL、Fedora、AlmaLinux、Rocky Linux）
- 自动检测系统版本和架构
- 一键安装 Docker CE 稳定版
- 自动安装 Docker Compose
- 配置国内镜像加速器
- 设置开机自启动

## 使用方法

### 1. 下载脚本
```bash
wget https://raw.githubusercontent.com/pkdg503/docker-installer/main/docker-installer/install-stable-docker.sh
```

### 2. 添加执行权限
```bash
chmod +x install-stable-docker.sh
```

### 3. 运行安装脚本
```bash
./install-stable-docker.sh
```

或者使用一键安装命令：
```bash
curl -fsSL https://raw.githubusercontent.com/pkdg503/docker-installer/main/docker-installer/install-stable-docker.sh | bash
```

## 安装过程

脚本会自动执行以下步骤：

1. **系统检测** - 识别 Linux 发行版和版本
2. **依赖安装** - 安装必要的软件包
3. **Docker 安装** - 添加官方仓库并安装 Docker CE
4. **服务启动** - 启动 Docker 服务并设置开机自启
5. **权限配置** - 将当前用户添加到 docker 组
6. **镜像加速** - 配置国内镜像加速器
7. **Docker Compose 安装** - 安装最新版 Docker Compose

## 支持的发行版

- **Ubuntu** (16.04+)
- **Debian** (9+)
- **CentOS** (7+)
- **RHEL** (7+)
- **Fedora** (30+)
- **AlmaLinux** (8+)
- **Rocky Linux** (8+)

## 验证安装

安装完成后，运行以下命令验证：

```bash
# 检查 Docker 版本
docker --version

# 检查 Docker Compose 版本
docker compose version

# 运行测试容器
docker run hello-world
```

## 配置说明

脚本会自动配置：

- Docker 服务开机自启动
- 当前用户加入 docker 用户组（需要重新登录生效）
- 国内镜像加速器（阿里云、腾讯云等）

## 注意事项

- 需要 root 或 sudo 权限运行
- 安装完成后建议重新登录以使 docker 组权限生效
- 如果已有 Docker 安装，脚本会跳过相关步骤
- 支持 x86_64 和 ARM64 架构

## 故障排除

如果安装遇到问题：

1. 检查网络连接
2. 确认系统版本是否受支持
3. 查看脚本输出的错误信息
4. 手动执行失败的命令进行调试

## 卸载 Docker

如需卸载 Docker，可以使用以下命令：

```bash
# Ubuntu/Debian
sudo apt-get remove docker docker-engine docker.io containerd runc

# CentOS/RHEL
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
```
