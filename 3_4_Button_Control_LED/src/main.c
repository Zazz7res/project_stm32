#include "stm32f10x.h"
#include "Delay.h"
#include "Buzzer.h"
#include "LightSensor.h"

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
    Buzzer_Init();
    LightSensor_Init();
    
    while (1)
    {
        if (LightSensor_Get() == 1)
        {
            Buzzer_ON();
        }
        else 
        {
            Buzzer_OFF();
        }
    }
}
