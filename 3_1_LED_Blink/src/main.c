#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "Delay.h"

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
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,  ENABLE);
    GPIO_InitTypeDef GPIO_InitStructure;
    // GPIO_Mode_Out_PP 这是推挽模式，即使LED灯的引脚装反都可以正常闪烁
    // 这意味着高低电平都有效
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP ;
    // GPIO_InitStructure.GPIO_Mode_out_OD;
    // 这个 GPIO_InitStructure.GPIO_Mode_out_OD 是开漏输出
    // 高电平是没有驱动能力的，只有低电平有驱动能力
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    
    while (1)
    {
        // 这些代码都是可以控制LED灯亮灭的
        GPIO_ResetBits(GPIOA, GPIO_Pin_0);
        Delay_ms(500);
        GPIO_ResetBits(GPIOA, GPIO_Pin_0);
        Delay_ms(500);

        GPIO_WriteBit(GPIOA, GPIO_Pin_0, Bit_RESET);
        Delay_ms(500);
        GPIO_WriteBit(GPIOA, GPIO_Pin_0, Bit_SET);
        Delay_ms(500);
        
        // 通过强制转换枚举类型也可以实现控制灯光的亮灭
        GPIO_WriteBit(GPIOA, GPIO_Pin_0, (BitAction)0);
        Delay_ms(500);
        GPIO_WriteBit(GPIOA, GPIO_Pin_0, (BitAction)1);
        Delay_ms(500);
        
    }
}
