# Quick Usage Guide / 快速使用指南

[English](#english) | [中文](#中文)

---

## English

### 🚀 Quick Start

```bash
# 1. Make executable
chmod +x remove_cursor_custom_mode.sh

# 2. List all modes
./remove_cursor_custom_mode.sh --list

# 3. Delete custom modes
./remove_cursor_custom_mode.sh "mode1" "mode2"
```

### 📋 Common Commands

| Command | Description |
|---------|-------------|
| `--list` | List all modes |
| `--help` | Show help |
| `--lang en` | Use English |
| `--lang zh` | Use Chinese |

### 💡 Examples

```bash
# List modes in English
./remove_cursor_custom_mode.sh --lang en --list

# Delete a single mode
./remove_cursor_custom_mode.sh "claude3.7"

# Delete multiple modes
./remove_cursor_custom_mode.sh "mode1" "mode2" "mode3"

# Set default language
export CURSOR_SCRIPT_LANG=en
./remove_cursor_custom_mode.sh --list
```

### ⚠️ Important Notes

- ✅ Only custom modes can be deleted
- ✅ Default modes are protected
- ✅ Automatic backup before deletion
- ✅ Cursor will be closed automatically
- ✅ Restart Cursor after deletion

---

## 中文

### 🚀 快速开始

```bash
# 1. 给脚本执行权限
chmod +x remove_cursor_custom_mode.sh

# 2. 列出所有模式
./remove_cursor_custom_mode.sh --list

# 3. 删除自定义模式
./remove_cursor_custom_mode.sh "模式1" "模式2"
```

### 📋 常用命令

| 命令 | 说明 |
|------|------|
| `--list` | 列出所有模式 |
| `--help` | 显示帮助 |
| `--lang en` | 使用英文 |
| `--lang zh` | 使用中文 |

### 💡 使用示例

```bash
# 用中文列出模式
./remove_cursor_custom_mode.sh --lang zh --list

# 删除单个模式
./remove_cursor_custom_mode.sh "claude3.7"

# 删除多个模式
./remove_cursor_custom_mode.sh "模式1" "模式2" "模式3"

# 设置默认语言
export CURSOR_SCRIPT_LANG=zh
./remove_cursor_custom_mode.sh --list
```

### ⚠️ 重要提示

- ✅ 只能删除自定义模式
- ✅ 默认模式受保护
- ✅ 删除前自动备份
- ✅ 自动关闭 Cursor
- ✅ 删除后需重启 Cursor

---

## Troubleshooting / 故障排除

### English
- **Permission denied**: Run `chmod +x remove_cursor_custom_mode.sh`
- **Database not found**: Ensure Cursor is installed and has been run once
- **Missing dependencies**: Install `sqlite3` and `python3`

### 中文
- **权限被拒绝**: 运行 `chmod +x remove_cursor_custom_mode.sh`
- **找不到数据库**: 确保 Cursor 已安装并运行过一次
- **缺少依赖**: 安装 `sqlite3` 和 `python3`
