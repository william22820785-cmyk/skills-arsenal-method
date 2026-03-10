#!/bin/bash
#=======================================
# Skills质量检查脚本
#=======================================

SKILLS_DIR="${SKILLS_DIR:-./skills}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "📊 Skills质量检查"
echo "======================================"
echo ""

total=0
passed=0
warning=0
failed=0

check_skill() {
    local skill_path="$1"
    local skill_name=$(basename "$skill_path")
    
    ((total++))
    
    # 检查必要文件
    if [ ! -f "$skill_path/SKILL.md" ]; then
        echo -e "${RED}❌ $skill_name: 缺少SKILL.md${NC}"
        ((failed++))
        return
    fi
    
    # 检查描述
    if ! grep -q "description:" "$skill_path/SKILL.md"; then
        echo -e "${YELLOW}⚠️ $skill_name: 缺少描述${NC}"
        ((warning++))
    fi
    
    # 检查标签
    if ! grep -q "tags:" "$skill_path/SKILL.md"; then
        echo -e "${YELLOW}⚠️ $skill_name: 缺少标签${NC}"
        ((warning++))
    fi
    
    echo -e "${GREEN}✅ $skill_name: 通过${NC}"
    ((passed++))
}

# 检查skills目录
if [ -d "$SKILLS_DIR" ]; then
    for skill in "$SKILLS_DIR"/*/; do
        if [ -d "$skill" ]; then
            check_skill "$skill"
        fi
    done
else
    echo -e "${YELLOW}⚠️ Skills目录不存在，跳过检查${NC}"
    echo ""
    echo "运行 ./install.sh 初始化"
fi

# 输出报告
echo ""
echo "======================================"
echo "📊 质量报告"
echo "======================================"
echo "总计: $total"
echo -e "通过: ${GREEN}$passed${NC}"
echo -e "警告: ${YELLOW}$warning${NC}"
echo -e "失败: ${RED}$failed${NC}"

if [ $failed -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ 所有检查通过!${NC}"
fi
