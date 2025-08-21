# Cursor Custom Mode Manager / Cursor 自定义模式管理器

[English](#english) | [中文](#中文)

---

## English

A safe and easy-to-use script to manage custom modes in Cursor IDE.

### Features

- ✅ Cross-platform support (macOS, Linux, Windows)
- ✅ Automatic database backup
- ✅ Safe deletion (protects default modes)
- ✅ List all modes
- ✅ Batch delete multiple custom modes
- ✅ Automatic Cursor process management
- ✅ Multi-language support (English/Chinese)

### Quick Start

```bash
# Make script executable
chmod +x remove_cursor_custom_mode.sh

# List all modes
./remove_cursor_custom_mode.sh --list

# Delete custom modes
./remove_cursor_custom_mode.sh "mode1" "mode2"
```

### Usage

#### 1. List all modes
```bash
./remove_cursor_custom_mode.sh --list
```

#### 2. Delete single custom mode
```bash
./remove_cursor_custom_mode.sh "mode name"
```

#### 3. Delete multiple custom modes
```bash
./remove_cursor_custom_mode.sh "mode1" "mode2" "mode3"
```

#### 4. Set language
```bash
./remove_cursor_custom_mode.sh --lang en --list
./remove_cursor_custom_mode.sh --lang zh --list
```

#### 5. Show help
```bash
./remove_cursor_custom_mode.sh --help
```

### Examples

```bash
# View all modes in English
./remove_cursor_custom_mode.sh --lang en --list

# Delete a mode named "claude3.7"
./remove_cursor_custom_mode.sh "claude3.7"

# Delete multiple modes at once
./remove_cursor_custom_mode.sh "claude3.7" "architecture" "my custom mode"
```

### Environment Variables

```bash
# Set default language
export CURSOR_SCRIPT_LANG=en  # or zh
./remove_cursor_custom_mode.sh --list
```

### Safety Features

1. **Automatic Backup**: Database is backed up before any operation
2. **Process Management**: Automatically closes Cursor processes
3. **Protected Default Modes**: Default modes (Agent, Careful, Ask, Background) cannot be deleted
4. **Confirmation Prompt**: Requires user confirmation before deletion

### System Requirements

- **macOS**: Supported
- **Linux**: Supported
- **Windows**: Supported (requires Git Bash or WSL)
- **Dependencies**: sqlite3, python3

### Installation of Dependencies

- **macOS**: `brew install sqlite python3`
- **Linux**: `sudo apt-get install sqlite3 python3`
- **Windows**: Install via official websites

### Troubleshooting

#### Database not found
Ensure Cursor is installed and has been run at least once.

#### Permission issues
```bash
chmod +x remove_cursor_custom_mode.sh
```

#### Missing dependencies
Install sqlite3 and python3 as shown above.

### Backup Files

Backup files are saved in the same directory as the original database:
```
state.vscdb.backup_YYYYMMDD_HHMMSS
```

---

## 中文

一个安全易用的 Cursor IDE 自定义模式管理脚本。

### 功能特性

- ✅ 跨平台支持 (macOS, Linux, Windows)
- ✅ 自动备份数据库
- ✅ 安全删除，不会影响默认模式
- ✅ 列出所有模式
- ✅ 批量删除多个自定义模式
- ✅ 自动关闭 Cursor 进程
- ✅ 多语言支持 (中英文)

### 快速开始

```bash
# 给脚本执行权限
chmod +x remove_cursor_custom_mode.sh

# 列出所有模式
./remove_cursor_custom_mode.sh --list

# 删除自定义模式
./remove_cursor_custom_mode.sh "模式1" "模式2"
```

### 使用方法

#### 1. 列出所有模式
```bash
./remove_cursor_custom_mode.sh --list
```

#### 2. 删除单个自定义模式
```bash
./remove_cursor_custom_mode.sh "模式名称"
```

#### 3. 删除多个自定义模式
```bash
./remove_cursor_custom_mode.sh "模式名称1" "模式名称2" "模式名称3"
```

#### 4. 设置语言
```bash
./remove_cursor_custom_mode.sh --lang zh --list
./remove_cursor_custom_mode.sh --lang en --list
```

#### 5. 显示帮助信息
```bash
./remove_cursor_custom_mode.sh --help
```

### 使用示例

```bash
# 用中文查看所有模式
./remove_cursor_custom_mode.sh --lang zh --list

# 删除名为 "claude3.7" 的自定义模式
./remove_cursor_custom_mode.sh "claude3.7"

# 同时删除多个自定义模式
./remove_cursor_custom_mode.sh "claude3.7" "架构模式" "我的自定义模式"
```

### 环境变量

```bash
# 设置默认语言
export CURSOR_SCRIPT_LANG=zh  # 或 en
./remove_cursor_custom_mode.sh --list
```

### 安全保障

1. **自动备份**: 每次操作前都会自动备份数据库文件
2. **进程管理**: 自动关闭 Cursor 进程，避免数据冲突
3. **保护默认模式**: 默认模式 (Agent、Careful、Ask、Background) 永远不会被删除
4. **确认提示**: 删除前会要求用户确认

### 系统要求

- **macOS**: 支持
- **Linux**: 支持
- **Windows**: 支持 (需要 Git Bash 或 WSL)
- **依赖**: sqlite3, python3

### 依赖安装

- **macOS**: `brew install sqlite python3`
- **Linux**: `sudo apt-get install sqlite3 python3`
- **Windows**: 通过官方网站安装

### 故障排除

#### 找不到数据库文件
确保 Cursor 已安装并至少运行过一次。

#### 权限问题
```bash
chmod +x remove_cursor_custom_mode.sh
```

#### 依赖缺失
按上述方法安装 sqlite3 和 python3。

### 备份文件位置

备份文件保存在与原数据库相同的目录下，文件名格式：
```
state.vscdb.backup_YYYYMMDD_HHMMSS
```

---

## License / 许可证

MIT License

## Author / 作者

Created to solve the issue of not being able to delete custom modes through Cursor IDE's UI.

为了解决 Cursor IDE 中无法通过 UI 删除自定义模式的问题而创建。
