#!/bin/bash

# Cursor Custom Mode Removal Script / Cursor自定义模式删除脚本
# Usage / 使用方法: ./remove_cursor_custom_mode.sh "mode1" "mode2" ...
# Or / 或者: ./remove_cursor_custom_mode.sh --list  (list all custom modes / 列出所有自定义模式)

set -e

# Language setting / 语言设置
LANG_MODE="${CURSOR_SCRIPT_LANG:-auto}"  # auto, en, zh

# Auto detect language / 自动检测语言
detect_language() {
    if [[ "$LANG_MODE" == "auto" ]]; then
        if [[ "$LANG" == *"zh"* ]] || [[ "$LC_ALL" == *"zh"* ]]; then
            LANG_MODE="zh"
        else
            LANG_MODE="en"
        fi
    fi
}

# Multi-language text / 多语言文本
get_text() {
    local key="$1"
    case "$LANG_MODE" in
        "zh")
            case "$key" in
                "error_os") echo "错误: 不支持的操作系统" ;;
                "error_sqlite") echo "错误: 需要安装 sqlite3" ;;
                "error_python") echo "错误: 需要安装 python3" ;;
                "error_db_not_found") echo "错误: 找不到Cursor配置数据库" ;;
                "backup_progress") echo "正在备份数据库..." ;;
                "backup_complete") echo "备份完成" ;;
                "closing_cursor") echo "正在关闭Cursor进程..." ;;
                "cursor_closed") echo "Cursor进程已关闭" ;;
                "db_updated") echo "数据库更新成功" ;;
                "delete_failed") echo "删除失败" ;;
                "delete_success") echo "✅ 自定义模式删除成功!" ;;
                "restart_cursor") echo "请重新启动Cursor查看效果" ;;
                "operation_cancelled") echo "操作已取消" ;;
                "confirm_delete") echo "确认继续? (y/N): " ;;
                "warning_close_cursor") echo "警告: 此操作将关闭Cursor并修改配置文件" ;;
                *) echo "$key" ;;
            esac
            ;;
        "en")
            case "$key" in
                "error_os") echo "Error: Unsupported operating system" ;;
                "error_sqlite") echo "Error: sqlite3 is required" ;;
                "error_python") echo "Error: python3 is required" ;;
                "error_db_not_found") echo "Error: Cursor configuration database not found" ;;
                "backup_progress") echo "Backing up database..." ;;
                "backup_complete") echo "Backup completed" ;;
                "closing_cursor") echo "Closing Cursor processes..." ;;
                "cursor_closed") echo "Cursor processes closed" ;;
                "db_updated") echo "Database updated successfully" ;;
                "delete_failed") echo "Deletion failed" ;;
                "delete_success") echo "✅ Custom modes deleted successfully!" ;;
                "restart_cursor") echo "Please restart Cursor to see the changes" ;;
                "operation_cancelled") echo "Operation cancelled" ;;
                "confirm_delete") echo "Confirm to continue? (y/N): " ;;
                "warning_close_cursor") echo "Warning: This operation will close Cursor and modify configuration files" ;;
                *) echo "$key" ;;
            esac
            ;;
    esac
}

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Cursor配置文件路径
CURSOR_DB="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb"
BACKUP_DB="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb.backup"
TEMP_DIR="/tmp/cursor_mode_manager"

# 检查操作系统 / Check operating system
check_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        CURSOR_DB="$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        CURSOR_DB="$HOME/.config/Cursor/User/globalStorage/state.vscdb"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows
        CURSOR_DB="$APPDATA/Cursor/User/globalStorage/state.vscdb"
    else
        echo -e "${RED}$(get_text "error_os") $OSTYPE${NC}"
        exit 1
    fi
}

# 检查依赖 / Check dependencies
check_dependencies() {
    if ! command -v sqlite3 &> /dev/null; then
        echo -e "${RED}$(get_text "error_sqlite")${NC}"
        exit 1
    fi

    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}$(get_text "error_python")${NC}"
        exit 1
    fi
}

# 检查Cursor数据库是否存在 / Check if Cursor database exists
check_cursor_db() {
    if [[ ! -f "$CURSOR_DB" ]]; then
        echo -e "${RED}$(get_text "error_db_not_found")${NC}"
        if [[ "$LANG_MODE" == "zh" ]]; then
            echo "路径: $CURSOR_DB"
            echo "请确保Cursor已安装并至少运行过一次"
        else
            echo "Path: $CURSOR_DB"
            echo "Please ensure Cursor is installed and has been run at least once"
        fi
        exit 1
    fi
}

# 创建临时目录
setup_temp_dir() {
    mkdir -p "$TEMP_DIR"
}

# 清理临时文件
cleanup() {
    rm -rf "$TEMP_DIR"
}

# 备份数据库 / Backup database
backup_database() {
    echo -e "${BLUE}$(get_text "backup_progress")${NC}"
    cp "$CURSOR_DB" "${BACKUP_DB}_$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}$(get_text "backup_complete")${NC}"
}

# 关闭Cursor进程 / Close Cursor processes
close_cursor() {
    echo -e "${BLUE}$(get_text "closing_cursor")${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pkill -f "Cursor" 2>/dev/null || true
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        pkill -f "cursor" 2>/dev/null || true
    fi
    sleep 2
    echo -e "${GREEN}$(get_text "cursor_closed")${NC}"
}

# 获取配置数据
get_config_data() {
    sqlite3 "$CURSOR_DB" "SELECT value FROM ItemTable WHERE key = 'src.vs.platform.reactivestorage.browser.reactiveStorageServiceImpl.persistentStorage.applicationUser';" > "$TEMP_DIR/cursor_config.json"
}

# 列出所有自定义模式 / List all custom modes
list_custom_modes() {
    get_config_data

    python3 << EOF
import json
import sys
import os

# Get language mode from environment
lang_mode = os.environ.get('LANG_MODE', 'en')

try:
    with open('/tmp/cursor_mode_manager/cursor_config.json', 'r', encoding='utf-8') as f:
        config_str = f.read().strip()

    config = json.loads(config_str)
    composer_state = config.get('composerState', {})
    modes4 = composer_state.get('modes4', [])

    # 默认模式ID列表
    default_mode_ids = ['agent', 'review-edits', 'chat', 'background']

    custom_modes = []
    default_modes = []

    for mode in modes4:
        mode_id = mode.get('id', '')
        mode_name = mode.get('name', mode_id)

        if mode_id in default_mode_ids:
            default_modes.append(mode_name)
        else:
            custom_modes.append({
                'id': mode_id,
                'name': mode_name,
                'icon': mode.get('icon', ''),
                'model': mode.get('model', 'Not specified' if lang_mode == 'en' else '未指定')
            })

    if lang_mode == 'zh':
        print("=== Cursor 模式列表 ===")
        print(f"\n📋 默认模式 ({len(default_modes)}个):")
        for name in default_modes:
            print(f"  • {name}")

        print(f"\n🎨 自定义模式 ({len(custom_modes)}个):")
        if custom_modes:
            for mode in custom_modes:
                print(f"  • {mode['name']} (模型: {mode['model']})")
        else:
            print("  (无自定义模式)")

        print(f"\n总计: {len(modes4)} 个模式")
    else:
        print("=== Cursor Mode List ===")
        print(f"\n📋 Default Modes ({len(default_modes)} modes):")
        for name in default_modes:
            print(f"  • {name}")

        print(f"\n🎨 Custom Modes ({len(custom_modes)} modes):")
        if custom_modes:
            for mode in custom_modes:
                print(f"  • {mode['name']} (Model: {mode['model']})")
        else:
            print("  (No custom modes)")

        print(f"\nTotal: {len(modes4)} modes")

except Exception as e:
    error_msg = f"错误: {e}" if lang_mode == 'zh' else f"Error: {e}"
    print(error_msg)
    sys.exit(1)
EOF
}

# 删除指定的自定义模式
remove_custom_modes() {
    local mode_names=("$@")
    
    get_config_data
    
    # 创建Python脚本来处理JSON
    cat > "$TEMP_DIR/remove_modes.py" << 'EOF'
import json
import sys

def remove_custom_modes(mode_names_to_remove):
    with open('/tmp/cursor_mode_manager/cursor_config.json', 'r', encoding='utf-8') as f:
        config_str = f.read().strip()
    
    config = json.loads(config_str)
    composer_state = config.get('composerState', {})
    modes4 = composer_state.get('modes4', [])
    
    # 默认模式ID列表
    default_mode_ids = ['agent', 'review-edits', 'chat', 'background']
    
    filtered_modes = []
    removed_modes = []
    
    for mode in modes4:
        mode_id = mode.get('id', '')
        mode_name = mode.get('name', mode_id)
        
        # 保留默认模式
        if mode_id in default_mode_ids:
            filtered_modes.append(mode)
        # 检查是否需要删除此自定义模式
        elif mode_name in mode_names_to_remove:
            removed_modes.append(mode_name)
        else:
            filtered_modes.append(mode)
    
    # 更新配置
    composer_state['modes4'] = filtered_modes
    config['composerState'] = composer_state
    
    # 写入修改后的配置
    with open('/tmp/cursor_mode_manager/cursor_config_modified.json', 'w', encoding='utf-8') as f:
        json.dump(config, f, ensure_ascii=False, separators=(',', ':'))
    
    return removed_modes, len(filtered_modes)

if __name__ == '__main__':
    mode_names = sys.argv[1:]
    removed, remaining_count = remove_custom_modes(mode_names)
    
    print(f"已删除的模式: {', '.join(removed) if removed else '无'}")
    print(f"剩余模式数量: {remaining_count}")
    
    if not removed:
        print("警告: 没有找到匹配的自定义模式")
        sys.exit(1)
EOF

    # 运行Python脚本
    python3 "$TEMP_DIR/remove_modes.py" "${mode_names[@]}"
    
    if [[ $? -eq 0 ]]; then
        # 更新数据库 / Update database
        sqlite3 "$CURSOR_DB" "UPDATE ItemTable SET value = (SELECT * FROM (SELECT readfile('/tmp/cursor_mode_manager/cursor_config_modified.json'))) WHERE key = 'src.vs.platform.reactivestorage.browser.reactiveStorageServiceImpl.persistentStorage.applicationUser';"
        echo -e "${GREEN}$(get_text "db_updated")${NC}"
        return 0
    else
        echo -e "${RED}$(get_text "delete_failed")${NC}"
        return 1
    fi
}

# 显示帮助信息 / Show help information
show_help() {
    if [[ "$LANG_MODE" == "zh" ]]; then
        echo "Cursor自定义模式管理脚本"
        echo ""
        echo "用法:"
        echo "  $0 --list                    列出所有模式"
        echo "  $0 --help                    显示帮助信息"
        echo "  $0 --lang en|zh              设置语言"
        echo "  $0 \"模式名称1\" \"模式名称2\"    删除指定的自定义模式"
        echo ""
        echo "示例:"
        echo "  $0 --list"
        echo "  $0 \"claude3.7\" \"架构模式\""
        echo "  $0 \"我的自定义模式\""
        echo "  $0 --lang en --list          使用英文列出模式"
        echo ""
        echo "注意:"
        echo "  - 只能删除自定义模式，默认模式(Agent、Careful、Ask、Background)不会被删除"
        echo "  - 脚本会自动备份数据库并关闭Cursor进程"
        echo "  - 删除后需要重新启动Cursor"
        echo ""
        echo "环境变量:"
        echo "  CURSOR_SCRIPT_LANG=zh|en     设置默认语言"
    else
        echo "Cursor Custom Mode Management Script"
        echo ""
        echo "Usage:"
        echo "  $0 --list                    List all modes"
        echo "  $0 --help                    Show help information"
        echo "  $0 --lang en|zh              Set language"
        echo "  $0 \"mode1\" \"mode2\"          Delete specified custom modes"
        echo ""
        echo "Examples:"
        echo "  $0 --list"
        echo "  $0 \"claude3.7\" \"architecture\""
        echo "  $0 \"my custom mode\""
        echo "  $0 --lang zh --list          List modes in Chinese"
        echo ""
        echo "Notes:"
        echo "  - Only custom modes can be deleted, default modes (Agent, Careful, Ask, Background) are protected"
        echo "  - Script will automatically backup database and close Cursor processes"
        echo "  - Restart Cursor after deletion to see changes"
        echo ""
        echo "Environment Variables:"
        echo "  CURSOR_SCRIPT_LANG=zh|en     Set default language"
    fi
}

# 主函数 / Main function
main() {
    # 设置清理陷阱 / Set cleanup trap
    trap cleanup EXIT

    # 初始化语言检测 / Initialize language detection
    detect_language

    # 处理语言参数 / Handle language parameter
    while [[ $# -gt 0 ]]; do
        case $1 in
            --lang)
                LANG_MODE="$2"
                shift 2
                ;;
            *)
                break
                ;;
        esac
    done

    # 导出语言模式供Python脚本使用 / Export language mode for Python scripts
    export LANG_MODE

    # 检查参数 / Check parameters
    if [[ $# -eq 0 ]]; then
        show_help
        exit 1
    fi

    # 处理参数 / Process parameters
    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        --list|-l)
            check_os
            check_dependencies
            check_cursor_db
            setup_temp_dir
            list_custom_modes
            exit 0
            ;;
        *)
            # 删除模式 / Delete modes
            check_os
            check_dependencies
            check_cursor_db
            setup_temp_dir

            if [[ "$LANG_MODE" == "zh" ]]; then
                echo -e "${YELLOW}准备删除自定义模式: $*${NC}"
                echo -e "${YELLOW}$(get_text "warning_close_cursor")${NC}"
                read -p "$(get_text "confirm_delete")" -n 1 -r
            else
                echo -e "${YELLOW}Preparing to delete custom modes: $*${NC}"
                echo -e "${YELLOW}$(get_text "warning_close_cursor")${NC}"
                read -p "$(get_text "confirm_delete")" -n 1 -r
            fi
            echo

            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "$(get_text "operation_cancelled")"
                exit 0
            fi

            backup_database
            close_cursor

            if remove_custom_modes "$@"; then
                echo -e "${GREEN}$(get_text "delete_success")${NC}"
                echo -e "${BLUE}$(get_text "restart_cursor")${NC}"
            else
                echo -e "${RED}❌ $(get_text "delete_failed")${NC}"
                exit 1
            fi
            ;;
    esac
}

# 运行主函数
main "$@"
