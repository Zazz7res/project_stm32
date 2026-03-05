#!/bin/bash
# ==========================================================================
# 文件名：build.sh
# 作用：一键清理并编译项目 (集成 bear 生成 compile_commands.json)
# 位置：cmake_build/scripts/build.sh
# ==========================================================================

# 1. 安全设置
set -e  # 关键！如果任何命令失败，立即停止脚本
set -u  # 如果使用未定义变量，报错

# 2. 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"  # 即 cmake_build 目录

# 3. 进入构建目录
cd "$PROJECT_ROOT"

# 4. 清理旧构建 (避免旧文件干扰，这对 bear 很重要，确保捕获所有命令)
echo "🧹 清理旧构建..."
rm -rf build
mkdir -p build
cd build

# 5. 配置 CMake
echo "⚙️ 配置 CMake..."
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm-none-eabi.cmake \
    -GNinja

# 6. 开始编译 (使用 bear 拦截编译命令)
echo "🔨 开始编译 (Bear 监听中...)..."
# 修改点 1: 使用 bear -- 包裹构建命令
# 修改点 2: 使用 --output 指定 json 文件生成到项目根目录，方便 IDE 识别
bear --output "$PROJECT_ROOT/compile_commands.json" -- ninja

# 7. 完成提示
echo "✅ 编译成功！"
echo "📦 输出文件：$PROJECT_ROOT/build/OLED_Display.bin"
echo "📄 索引文件：$PROJECT_ROOT/compile_commands.json"
