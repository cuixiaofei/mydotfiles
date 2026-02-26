# ~/.bash_functions/tarbackup.sh
# 功能：将指定目录打包为带时间戳的 tar.gz 文件
# 用法：tarbackup <项目目录路径> [可选：输出目录路径]
# 示例：tarbackup ./my-project
# 示例：tarbackup ./my-project ~/backups

tarbackup() {
    # 1. 参数检查
    if [ -z "$1" ]; then
        echo "❌ 错误：请指定要备份的项目目录路径。"
        echo "用法：tarbackup <项目目录> [输出目录]"
        return 1
    fi

    local SOURCE_DIR="$1"
    local DEST_DIR="${2:-.}" # 如果没有提供第二个参数，默认为当前目录

    # 2. 验证源目录是否存在
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "❌ 错误：目录 '$SOURCE_DIR' 不存在。"
        return 1
    fi

    # 3. 验证目标目录是否存在
    if [ ! -d "$DEST_DIR" ]; then
        echo "⚠️ 警告：输出目录 '$DEST_DIR' 不存在，尝试创建..."
        mkdir -p "$DEST_DIR" || { echo "❌ 错误：无法创建输出目录 '$DEST_DIR'。"; return 1; }
    fi

    # 4. 生成文件名
    # 获取项目文件夹的名称（去掉末尾的斜杠）
    local PROJECT_NAME=$(basename "$SOURCE_DIR")
    # 生成时间戳：YYYYMMDD_HHMMSS
    local TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    local BACKUP_FILE="${DEST_DIR}/${PROJECT_NAME}_${TIMESTAMP}.tar.gz"

    echo "🚀 开始备份..."
    echo "📂 源目录：$(realpath "$SOURCE_DIR")"
    echo "💾 目标文件：$BACKUP_FILE"

    # 5. 执行 tar 命令
    # -c: 创建归档
    # -z: 使用 gzip 压缩
    # -f: 指定文件名
    # -C: 切换到指定目录再执行（这样压缩包内不会包含绝对路径，结构更干净）
    if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
        # 6. 备份成功后的处理
        local FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
        echo "✅ 备份成功！"
        echo "📦 文件名：$BACKUP_FILE"
        echo "📏 大小：$FILE_SIZE"
    else
        echo "❌ 备份失败！请检查权限或磁盘空间。"
        return 1
    fi
}