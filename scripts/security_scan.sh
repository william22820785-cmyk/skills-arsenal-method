#!/bin/bash
#=======================================
# Skills安全扫描脚本
#=======================================

SKILLS_DIR="${SKILLS_DIR:-./skills}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔒 Skills安全扫描"
echo "======================================"
echo ""

# 可疑命令模式
DANGEROUS_PATTERNS=(
    "curl.*\|.*bash"
    "wget.*\|.*sh"
    "nc\s"
    "eval\s"
    "base64.*-d"
    "rm\s+-rf\s+/"
    "chmod\s+777"
    "sudo\s"
    "wget\s+http.*\|"
    "curl\s+http.*\|"
)

issues=0
scanned=0

scan_file() {
    local file="$1"
    local skill=$(basename $(dirname "$file"))
    
    for pattern in "${DANGEROUS_PATTERNS[@]}"; do
        if grep -qE "$pattern" "$file" 2>/dev/null; then
            echo -e "${RED}⚠️ $skill: 发现可疑模式: $pattern${NC}"
            ((issues++))
        fi
    done
}

# 扫描所有shell脚本
if [ -d "$SKILLS_DIR" ]; then
    while IFS= read -r -d '' script; do
        ((scanned++))
        scan_file "$script"
    done < <(find "$SKILLS_DIR" -name "*.sh" -type f -print0 2>/dev/null)
fi

echo ""
echo "======================================"
echo "📊 扫描报告"
echo "======================================"
echo "扫描文件: $scanned"
echo -e "发现问题: ${RED}$issues${NC}"

if [ $issues -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ 安全扫描通过!${NC}"
fi
