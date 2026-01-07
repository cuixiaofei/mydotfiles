#!/bin/bash
echo "🧹 开始清理版本历史..."

# 找到最后一次"update"提交
CLEAN_POINT=$(git log --oneline | grep "update" | head -1 | awk '{print $1}')

if [ -z "$CLEAN_POINT" ]; then
    echo "❌ 没有找到干净的提交点"
    exit 1
fi

echo "📍 找到干净提交点: $CLEAN_POINT"

# 创建临时分支用于整理
git checkout -b temp-cleanup $CLEAN_POINT

# 获取当前工作（确保不丢失）
git checkout main -- VERSION Makefile  # 只取关键文件
git checkout main -- $(git diff --name-only $CLEAN_POINT..main | grep -v "^VERSION$")

# 创建干净的发布提交
echo "1.1.0" > VERSION  # 设置你想要的版本
git add VERSION Makefile
git commit -m "发布: 版本 1.1.0（历史整理版）"

# 创建正确的标签
git tag -a "v1.1.0" -m "发布版本 1.1.0（清理后）"

echo "✅ 清理完成！新的提交历史："
git log --oneline -5

echo "💡 执行以下命令完成清理："
echo "git checkout main"
echo "git reset --hard temp-cleanup"  
echo "git push origin main --force"
echo "git push origin --tags"