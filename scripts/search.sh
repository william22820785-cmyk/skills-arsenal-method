#!/bin/bash
#=======================================
# Skills搜索工具
#=======================================

SKILLS_DIR="${SKILLS_DIR:-./skills}"
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

show_help() {
    echo "Usage: $0 [OPTIONS] KEYWORD"
    echo ""
    echo "搜索Skills武器库"
    echo ""
    echo "Options:"
    echo "  -h, --help     显示帮助"
    echo "  -l, --limit    限制结果数量 (默认: 20)"
    echo "  -c, --category 按分类搜索"
    echo ""
    echo "Examples:"
    echo "  $0 marketing"
    echo "  $0 -l 10 ai"
    echo "  $0 -c 金融"
    echo ""
}

search_skills() {
    local keyword="$1"
    local limit="${2:-20}"
    
    if [ -z "$keyword" ]; then
        echo -e "${YELLOW}请输入搜索关键词${NC}"
        show_help
        exit 1
    fi
    
    echo -e "${GREEN}🔍 搜索: $keyword${NC}"
    echo "======================================"
    echo ""
    
    # 如果skills目录存在，搜索本地
    if [ -d "$SKILLS_DIR" ]; then
        count=0
        while IFS= read -r -d '' skill; do
            if [ $count -ge $limit ]; then
                break
            fi
            
            skill_name=$(basename "$skill")
            desc=$(grep -i "description:" "$skill/SKILL.md" 2>/dev/null | head -1 | sed 's/description: //' || echo "无描述")
            
            echo -e "✅ ${GREEN}$skill_name${NC}"
            echo "   $desc"
            echo ""
            
            ((count++))
        done < <(find "$SKILLS_DIR" -name "SKILL.md" -exec grep -l -i "$keyword" {} \; 2>/dev/null | head -$limit)
        
        if [ $count -eq 0 ]; then
            echo "未找到匹配的Skills"
        else
            echo "======================================"
            echo "找到 $count 个结果"
        fi
    else
        # 模拟在线搜索结果
        echo "📦 本地Skills目录未初始化，使用示例数据:"
        echo ""
        
        case "$keyword" in
            *market*|*营销*|*social*)
                echo "✅ social-poster        [评分: 4.5]  社媒发布工具"
                echo "✅ copywriting         [评分: 4.3]  AI文案撰写"
                echo "✅ content-strategy   [评分: 4.2]  内容策略规划"
                echo "✅ seo-audit          [评分: 4.1]  SEO审计工具"
                ;;
            *ai*|*AI*|*人工智能*)
                echo "✅ chatgpt             [评分: 4.8]  GPT集成"
                echo "✅ claude              [评分: 4.7]  Claude集成"
                echo "✅ agent-orchestrator  [评分: 4.5]  Agent编排"
                ;;
            *github*|*git*)
                echo "✅ github               [评分: 4.6]  GitHub CLI"
                echo "✅ gitlab              [评分: 4.3]  GitLab集成"
                ;;
            *feishu*|*飞书*)
                echo "✅ feishu-doc          [评分: 4.4]  飞书文档"
                echo "✅ feishu-drive       [评分: 4.3]  飞书网盘"
                echo "✅ feishu-bitable     [评分: 4.5]  飞书多维表格"
                ;;
            *)
                echo "✅ 找到多个相关Skills，请运行 ./install.sh 初始化后查看完整列表"
                ;;
        esac
    fi
}

# 主逻辑
case "${1:-}" in
    -h|--help)
        show_help
        ;;
    -l|--limit)
        search_skills "$3" "$2"
        ;;
    -c|--category)
        search_skills "$2" 50
        ;;
    *)
        search_skills "$1"
        ;;
esac
