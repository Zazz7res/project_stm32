#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "Delay.h"
#include "LED.h"
#include "Key.h"
#include <stdint.h>

// 这个全局变量用于存储键码的返回值
uint8_t KeyNum;

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

    LED_Init();
    Key_Init();
    
    while (1)
    {
        KeyNum = Key_GetNum();
        if (KeyNum == 1)
        {
            LED1_Turn();
        }
        if (KeyNum == 2)
        {
            LED2_Turn();
        }
    }
}
