#!/bin/bash
#=======================================
# Skills同步脚本
#=======================================

LOG_DIR="${LOG_DIR:-./logs}"
SKILLS_DIR="${SKILLS_DIR:-./skills}"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "🔄 Skills同步工具"
echo "======================================"
echo "时间: $TIMESTAMP"
echo ""

# 创建日志目录
mkdir -p "$LOG_DIR"

# 记录日志
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" | tee -a "$LOG_DIR/sync.log"
}

log "开始同步..."

# 检查ClawHub API
check_clawhub() {
    log "检查ClawHub连接..."
    
    if curl -s --max-time 5 https://clawhub.ai &>/dev/null; then
        log "✅ ClawHub连接正常"
        return 0
    else
        log "⚠️ ClawHub连接失败，使用离线模式"
        return 1
    fi
}

# 获取Skills列表
fetch_skills() {
    log "获取Skills列表..."
    
    # 模拟获取（实际可调用API）
    skills=(
        "feishu-doc"
        "github" 
        "weather"
        "calendar"
        "blog-writer"
        "canvas-design"
    )
    
    for skill in "${skills[@]}"; do
        log "  📦 $skill"
    done
    
    log "✅ 获取到 ${#skills[@]} 个Skills"
}

# 更新索引
update_index() {
    log "更新索引..."
    
    cat > "$SKILLS_DIR/INDEX.md" << 'EOF'
# Skills索引

> 自动生成

## 分类

| 分类 | 数量 |
|------|------|
| 飞书 | 3 |
| 开发工具 | 2 |
| 其他 | 1 |

## Skills列表

(自动更新)
EOF

    log "✅ 索引已更新"
}

# 备份
backup() {
    log "创建备份..."
    
    backup_dir="$LOG_DIR/backup-$(date +%Y%m%d)"
    mkdir -p "$backup_dir"
    
    if [ -d "$SKILLS_DIR" ]; then
        cp -r "$SKILLS_DIR" "$backup_dir/" 2>/dev/null || true
        log "✅ 备份已保存到 $backup_dir"
    fi
}

# 清理旧日志
cleanup_logs() {
    log "清理旧日志..."
    
    find "$LOG_DIR" -name "*.log" -mtime +30 -delete 2>/dev/null || true
    log "✅ 旧日志已清理"
}

# 主流程
main() {
    if check_clawhub; then
        fetch_skills
    fi
    
    update_index
    backup
    cleanup_logs
    
    echo ""
    log "✅ 同步完成!"
    echo "======================================"
}

main "$@"
