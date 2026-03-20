#include "stm32f10x.h"
#include "Delay.h"
#include "OLED.h"

int main(void) 
{
    // ========== 防砖代码（加这 3 行）==========
    // 1. 禁用可能冲突的外设（如 USB）
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_USB, DISABLE);
    // 2. 拉低 PA11/PA12（USB 引脚），防止上电枚举冲突
    GPIOA->CRL &= ~0xFF000000;  // PA11/PA12 配置为输入
    GPIOA->ODR &= ~0x1800;       // 输出低电平
    // ========================================

    //  我的程序
    OLED_Init();

    OLED_ShowChar(1, 1, 'A');
    OLED_ShowString(1, 3, "HelloWorld!");
    OLED_ShowNum(2, 1, 12345, 5);
    OLED_ShowSignedNum(2, 7, 12345, 5);
    OLED_ShowHexNum(3, 1, 0xAA55, 4);
    OLED_ShowBinNum(4, 1, 0xAA55, 16);
    
    while (1)
    {
    }
}
