#!/bin/bash
#=======================================
# Skills Arsenal Method - 一键安装脚本
#=======================================

set -e

echo "🚀 Skills武器库安装器 v1.0.0"
echo "======================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 检查依赖
check_deps() {
    echo "📦 检查依赖..."
    
    deps=("git" "curl" "bash")
    missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            missing+=($dep)
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}❌ 缺少依赖: ${missing[*]}${NC}"
        echo "请先安装: apt-get install ${missing[*]}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ 依赖检查通过${NC}"
}

# 创建目录结构
create_dirs() {
    echo "📁 创建目录结构..."
    
    dirs=("scripts" "skills" "logs" "backup" "template")
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            echo "  ✅ $dir"
        fi
    done
}

# 初始化Git
init_git() {
    echo "📂 初始化Git仓库..."
    
    if [ ! -d ".git" ]; then
        git init
        git config user.email "ace@aceworld.top"
        git config user.name "Skills Arsenal"
        echo -e "${GREEN}✅ Git初始化完成${NC}"
    else
        echo -e "${YELLOW}⚠️ Git仓库已存在${NC}"
    fi
}

# 配置定时任务
setup_cron() {
    echo "⏰ 配置定时任务..."
    
    cronjob="# Skills Arsenal 定时任务
# 每天凌晨3点自动同步
0 3 * * * $(pwd)/scripts/sync.sh >> logs/sync.log 2>&1
# 每周日凌晨3点质量检查
0 3 * * 0 $(pwd)/scripts/quality_check.sh >> logs/quality.log 2>&1
"
    
    (crontab -l 2>/dev/null | grep -v "Skills Arsenal"; echo "$cronjob") | crontab -
    echo -e "${GREEN}✅ 定时任务已配置${NC}"
}

# 创建快捷命令
create_alias() {
    echo "🔧 创建快捷命令..."
    
    alias_file="$HOME/.skills-arsenal-aliases"
    echo "alias sa-search='$(pwd)/scripts/search.sh'" > "$alias_file"
    echo "alias sa-sync='$(pwd)/scripts/sync.sh'" >> "$alias_file"
    echo "alias sa-status='$(pwd)/scripts/report.sh'" >> "$alias_file"
    
    echo -e "${GREEN}✅ 快捷命令已创建${NC}"
    echo "请运行以下命令启用快捷方式:"
    echo "  source $alias_file"
}

# 首次同步
first_sync() {
    echo "🔄 首次同步Skills..."
    
    if [ -f "scripts/sync.sh" ]; then
        chmod +x scripts/*.sh
        # 模拟同步
        echo -e "${GREEN}✅ 同步脚本已就绪${NC}"
    fi
}

# 显示完成信息
show_summary() {
    echo ""
    echo "======================================"
    echo -e "${GREEN}🎉 安装完成！${NC}"
    echo "======================================"
    echo ""
    echo "📖 快速开始:"
    echo "  ./scripts/search.sh --help    # 搜索Skills"
    echo "  ./scripts/sync.sh            # 同步更新"
    echo "  ./scripts/report.sh          # 查看报告"
    echo ""
    echo "📁 Skills目录: $(pwd)/skills"
    echo "📊 日志目录: $(pwd)/logs"
    echo ""
}

# 主函数
main() {
    check_deps
    create_dirs
    init_git
    setup_cron
    create_alias
    first_sync
    show_summary
}

main "$@"
