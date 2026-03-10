#!/bin/bash
#=======================================
# Skills备份脚本
#=======================================

BACKUP_DIR="${BACKUP_DIR:-./backup}"
SKILLS_DIR="${SKILLS_DIR:-./skills}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "💾 Skills备份"
echo "======================================"

mkdir -p "$BACKUP_DIR"

backup_file="$BACKUP_DIR/skills-backup-$TIMESTAMP.tar.gz"

if [ -d "$SKILLS_DIR" ]; then
    tar -czf "$backup_file" "$SKILLS_DIR" 2>/dev/null
    echo "✅ 备份已保存: $backup_file"
    
    # 清理30天前的备份
    find "$BACKUP_DIR" -name "skills-backup-*.tar.gz" -mtime +30 -delete 2>/dev/null
    echo "✅ 旧备份已清理"
else
    echo "⚠️ Skills目录不存在"
fi
