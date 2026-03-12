#!/bin/bash
set -e

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

# 检查是否已构建
if [ ! -f build/STM32F103C8T6.bin ]; then
    echo "❌ 未找到 build/STM32F103C8T6.bin，请先运行 build.sh"
    exit 1
fi

# 使用 st-flash 烧录并复位（--reset 选项自动复位）
echo "烧录中..."
st-flash --reset write build/STM32F103C8T6.bin 0x08000000

echo "✅ 烧录完成并已复位"
