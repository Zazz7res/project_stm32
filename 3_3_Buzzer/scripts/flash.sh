#!/bin/bash
# STM32 st-flash 烧录脚本（超简版）

set -e

# 颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# 路径
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BIN_FILE="${PROJECT_DIR}/build/STM32F103C8T6.bin"

echo "🔌 ST-Link Flash Script"
echo "======================="

# 1. 检查 st-flash
if ! command -v st-flash &> /dev/null; then
    echo -e "${RED}❌ st-flash not found!${NC}"
    echo "   Install: sudo apt install stlink-tools"
    exit 1
fi

# 2. 检查 bin 文件
if [ ! -f "$BIN_FILE" ]; then
    echo -e "${RED}❌ Binary not found: $BIN_FILE${NC}"
    echo "   Run: ./scripts/build.sh first"
    exit 1
fi

# 3. 显示设备信息
echo -e "\n📡 Connected devices:"
st-info --probe

# 4. 烧录（核心命令！）
echo -e "\n🔥 Flashing $BIN_FILE to 0x08000000 ..."
st-flash write "$BIN_FILE" 0x08000000

# 5. 完成
echo -e "\n${GREEN}✅ Flash complete!${NC}"
echo "💡 If LED not lit, try:"
echo "   1. Check LED wiring (high/low active?)"
echo "   2. Hold BOOT0=1 + RESET to recover"
