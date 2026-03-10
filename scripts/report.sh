#!/bin/bash
#=======================================
# Skills报告生成脚本
#=======================================

SKILLS_DIR="${SKILLS_DIR:-./skills}"
LOG_DIR="${LOG_DIR:-./logs}"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "📈 Skills武器库报告"
echo "======================================"
echo ""

# 统计Skills数量
count_skills() {
    if [ -d "$SKILLS_DIR" ]; then
        find "$SKILLS_DIR" -maxdepth 1 -type d | tail -n +2 | wc -l
    else
        echo "0"
    fi
}

# 统计日志
count_logs() {
    if [ -d "$LOG_DIR" ]; then
        find "$LOG_DIR" -name "*.log" | wc -l
    else
        echo "0"
    fi
}

# 获取最后同步时间
last_sync() {
    if [ -f "$LOG_DIR/sync.log" ]; then
        tail -1 "$LOG_DIR/sync.log" | grep -oP '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}' || echo "从未同步"
    else
        echo "从未同步"
    fi
}

skills_count=$(count_skills)
logs_count=$(count_logs)
last=$(last_sync)

echo "📊 概览"
echo "--------------------------------------"
echo -e "Skills总数: ${GREEN}$skills_count${NC}"
echo "日志文件: $logs_count"
echo "最后同步: $last"
echo ""

echo "📁 目录结构"
echo "--------------------------------------"
echo "skills/     - Skills存放目录"
echo "scripts/    - 工具脚本"
echo "logs/       - 运行日志"
echo "backup/     - 备份文件"
echo "template/   - 配置模板"
echo ""

echo "🛠️ 可用命令"
echo "--------------------------------------"
echo "./scripts/search.sh          - 搜索Skills"
echo "./scripts/sync.sh           - 同步更新"
echo "./scripts/quality_check.sh  - 质量检查"
echo "./scripts/security_scan.sh  - 安全扫描"
echo ""

echo "======================================"
