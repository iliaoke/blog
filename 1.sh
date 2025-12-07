#!/bin/bash
# git-set-filetime.sh
# 功能：将 git 仓库中所有被追踪文件的修改时间改为最后一次提交时间

# 确保当前目录是 git 仓库
if [ ! -d ".git" ]; then
    echo "Error: 当前目录不是 git 仓库根目录"
    exit 1
fi

# 获取所有被追踪文件（包含特殊字符/空格/中文）
git ls-files -z | while IFS= read -r -d '' file; do
    # 获取最后一次提交的 Unix 时间戳
    timestamp=$(git log -1 --format="%ct" -- "$file")
    
    if [ -n "$timestamp" ]; then
        # 使用 touch 修改文件修改时间
        # -d "@$timestamp" 表示从 Unix 时间戳设置时间
        touch -d "@$timestamp" "$file"
        echo "Updated: $file -> $(date -d "@$timestamp" '+%Y-%m-%d %H:%M:%S')"
    else
        echo "Skipped (not tracked): $file"
    fi
done

echo "All tracked files' modification times updated."
