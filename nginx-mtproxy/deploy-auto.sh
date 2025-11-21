cat > deploy-mtproxy.sh << 'EOF'
#!/bin/bash

# nginx-mtproxy 自动部署脚本
# 使用方法: curl -sSL https://raw.githubusercontent.com/pkdg503/docker-installer/main/nginx-mtproxy/deploy-mtproxy.sh | bash

set -e

# ========== 配置区域 ==========
CONTAINER_COUNT=2
DOMAINS="microsoft.com,apple.com"
HTTP_PORTS="45603,45604"
HTTPS_PORTS="45605,45606"
NAME_PREFIX="mtproxy"
AUTO_REMOVE="yes"
# ========== 配置结束 ==========

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

IMAGE_NAME="ellermister/nginx-mtproxy:latest"

show_header() {
    echo -e "${GREEN}"
    echo "========================================"
    echo "🚀 nginx-mtproxy 自动部署脚本"
    echo "========================================"
    echo -e "${NC}"
    echo -e "${CYAN}📋 配置信息:${NC}"
    echo -e "  容器数量: ${CONTAINER_COUNT}"
    echo -e "  伪装域名: ${DOMAINS}"
    echo -e "  HTTP端口: ${HTTP_PORTS}"
    echo -e "  HTTPS端口: ${HTTPS_PORTS}"
    echo -e "  容器前缀: ${NAME_PREFIX}"
    echo ""
}

check_docker() {
    echo -e "${BLUE}🔍 检查 Docker 环境...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker 未安装，请先安装 Docker${NC}"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}❌ Docker 服务未运行，请先启动 Docker${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker 环境检查通过${NC}"
    echo -e "${CYAN}🐳 Docker 版本: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)${NC}"
}

pull_image() {
    echo -e "${BLUE}🔍 检查 Docker 镜像...${NC}"
    if docker image inspect "$IMAGE_NAME" &> /dev/null; then
        echo -e "${GREEN}✅ 镜像已存在${NC}"
        # 尝试更新镜像
        echo -e "${YELLOW}⏳ 检查镜像更新...${NC}"
        if docker pull "$IMAGE_NAME" | grep -q "Image is up to date"; then
            echo -e "${GREEN}✅ 镜像已是最新版本${NC}"
        else
            echo -e "${GREEN}🔄 镜像已更新到最新版本${NC}"
        fi
    else
        echo -e "${YELLOW}📥 拉取镜像...${NC}"
        if docker pull "$IMAGE_NAME"; then
            echo -e "${GREEN}✅ 镜像拉取成功${NC}"
        else
            echo -e "${RED}❌ 镜像拉取失败${NC}"
            exit 1
        fi
    fi
}

parse_config() {
    IFS=',' read -ra DOMAINS_ARRAY <<< "${DOMAINS// /}"
    IFS=',' read -ra HTTP_PORTS_ARRAY <<< "${HTTP_PORTS// /}"
    IFS=',' read -ra HTTPS_PORTS_ARRAY <<< "${HTTPS_PORTS// /}"
}

check_port() {
    local port=$1
    if command -v ss &> /dev/null; then
        if ss -tulpn 2>/dev/null | grep -q ":${port} "; then
            return 1
        fi
    elif command -v netstat &> /dev/null; then
        if netstat -tulpn 2>/dev/null | grep -q ":${port} "; then
            return 1
        fi
    fi
    return 0
}

get_container_name() {
    local index=0
    local name="${NAME_PREFIX}${index}"
    while docker ps -a --format "table {{.Names}}" | grep -q "^${name}$"; do
        index=$((index + 1))
        name="${NAME_PREFIX}${index}"
    done
    echo "$name"
}

deploy_containers() {
    local success_count=0
    local containers_info=()
    
    echo -e "${BLUE}📦 开始部署 ${CONTAINER_COUNT} 个容器...${NC}"
    
    for ((i=0; i<CONTAINER_COUNT; i++)); do
        # 获取配置（循环使用）
        local domain_index=$((i % ${#DOMAINS_ARRAY[@]}))
        local domain="${DOMAINS_ARRAY[$domain_index]}"
        
        local http_port_index=$((i % ${#HTTP_PORTS_ARRAY[@]}))
        local base_http_port="${HTTP_PORTS_ARRAY[$http_port_index]}"
        local http_port=$((base_http_port + i))
        
        local https_port_index=$((i % ${#HTTPS_PORTS_ARRAY[@]}))
        local base_https_port="${HTTPS_PORTS_ARRAY[$https_port_index]}"
        local https_port=$((base_https_port + i))
        
        local container_name=$(get_container_name)
        
        # 检查并调整端口
        while ! check_port "$http_port"; do
            echo -e "${YELLOW}⚠️  HTTP端口 ${http_port} 被占用，尝试 $((http_port + 1))${NC}"
            http_port=$((http_port + 1))
        done
        
        while ! check_port "$https_port" || [ "$https_port" -eq "$http_port" ]; do
            echo -e "${YELLOW}⚠️  HTTPS端口 ${https_port} 被占用，尝试 $((https_port + 1))${NC}"
            https_port=$((https_port + 1))
        done
        
        # 处理已存在的容器
        if docker ps -a --format "table {{.Names}}" | grep -q "^${container_name}$"; then
            if [ "$AUTO_REMOVE" = "yes" ]; then
                echo -e "${YELLOW}♻️  删除现有容器: ${container_name}${NC}"
                docker stop "$container_name" >/dev/null 2>&1 || true
                docker rm "$container_name" >/dev/null 2>&1 || true
            else
                echo -e "${YELLOW}⏭️  跳过已存在容器: ${container_name}${NC}"
                continue
            fi
        fi
        
        # 生成随机 secret
        local secret=$(head -c 16 /dev/urandom | xxd -ps 2>/dev/null || openssl rand -hex 16)
        
        echo -e "${CYAN}🔧 部署容器: ${container_name}${NC}"
        echo -e "  🌐 伪装域名: ${domain}"
        echo -e "  🔌 端口映射: ${http_port}->80, ${https_port}->443"
        echo -e "  🔑 Secret: ${secret}"
        
        # 部署容器
        echo -e "${YELLOW}⏳ 启动容器...${NC}"
        if docker run --name "$container_name" -d \
            -e secret="$secret" \
            -e domain="$domain" \
            -e ip_white_list="OFF" \
            -p "${http_port}:80" \
            -p "${https_port}:443" \
            "$IMAGE_NAME" >/dev/null 2>&1; then
            
            # 等待容器启动
            sleep 3
            
            # 检查容器状态
            if docker ps --filter "name=${container_name}" --format "{{.Names}}" | grep -q "^${container_name}$"; then
                local status=$(docker ps --filter "name=${container_name}" --format "{{.Status}}")
                echo -e "${GREEN}✅ 容器部署成功！状态: ${status}${NC}"
                containers_info+=("${container_name}:${http_port}:${https_port}:${domain}:${secret}")
                success_count=$((success_count + 1))
            else
                echo -e "${RED}❌ 容器启动失败${NC}"
                docker logs "$container_name" --tail 5 2>/dev/null || echo "无法获取日志"
            fi
        else
            echo -e "${RED}❌ 容器创建失败${NC}"
        fi
        echo "----------------------------------------"
    done
    
    # 显示部署结果
    echo -e "\n${GREEN}🎉 部署完成！${NC}"
    echo -e "${GREEN}✅ 成功部署: ${success_count}/${CONTAINER_COUNT} 个容器${NC}"
    
    if [ ${#containers_info[@]} -gt 0 ]; then
        echo -e "\n${YELLOW}📋 部署详情：${NC}"
        printf "${CYAN}%-15s %-10s %-10s %-20s %s${NC}\n" "容器名称" "HTTP端口" "HTTPS端口" "伪装域名" "Secret"
        echo "${CYAN}--------------------------------------------------------------------------------${NC}"
        
        for info in "${containers_info[@]}"; do
            IFS=':' read -r name http https domain secret <<< "$info"
            printf "%-15s %-10s %-10s %-20s %s\n" "$name" "$http" "$https" "$domain" "$secret"
        done
        
        echo -e "\n${GREEN}🔧 管理命令：${NC}"
        echo -e "查看所有容器: ${YELLOW}docker ps -a | grep ${NAME_PREFIX}${NC}"
        echo -e "查看容器日志: ${YELLOW}docker logs <容器名称>${NC}"
        echo -e "停止容器:     ${YELLOW}docker stop <容器名称>${NC}"
        echo -e "启动容器:     ${YELLOW}docker start <容器名称>${NC}"
        echo -e "删除容器:     ${YELLOW}docker rm -f <容器名称>${NC}"
        
        echo -e "\n${YELLOW}💡 提示：请妥善保存上面的 Secret 信息，配置 MTProxy 客户端时需要用到${NC}"
    fi
    
    if [ $success_count -eq 0 ]; then
        echo -e "${RED}❌ 没有成功部署任何容器${NC}"
        exit 1
    fi
}

main() {
    show_header
    check_docker
    pull_image
    parse_config
    deploy_containers
}

# 脚本入口
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
EOF

echo "✅ 完整的自动部署脚本已生成"
echo "📁 文件: deploy-mtproxy.sh"
echo "🚀 使用方法: curl -sSL https://raw.githubusercontent.com/pkdg503/docker-installer/main/nginx-mtproxy/deploy-mtproxy.sh | bash"
