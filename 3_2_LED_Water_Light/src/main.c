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

    // 现在从LED闪烁项目复制迁移到流水灯项目，然后因为使用的都是GPIOA的端口，所以这里不用改了
    // 现在只是设置使用了GPIOA 如果需要打开多个就使用按位或的形式就可以打开多个了，这里跟设置GPIO的8种工作模式是一样的
    // GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2 | ...;
    // rcc.c 和 gpio.c 里面有详细说明
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,  ENABLE);
    GPIO_InitTypeDef GPIO_InitStructure;
    // GPIO_Mode_Out_PP 这是推挽模式，即使LED灯的引脚装反都可以正常闪烁
    // 这意味着高低电平都有效
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP ;
    // GPIO_InitStructure.GPIO_Mode_out_OD;
    // 这个 GPIO_InitStructure.GPIO_Mode_out_OD 是开漏输出
    // 高电平是没有驱动能力的，只有低电平有驱动能力
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_All;
    // GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2 | ...;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    
    while (1)
    {
       GPIO_Write(GPIOA, ~0x0001);  // 0000 0000 0000 0001
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0002);  // 0000 0000 0000 0010
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0004);  // 0000 0000 0000 0100
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0008);  // 0000 0000 0000 1000
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0010);  // 0000 0000 0001 0000
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0020);  // 0000 0000 0010 0000
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0040);  // 0000 0000 0100 0000
       Delay_ms(100);
       GPIO_Write(GPIOA, ~0x0080);  // 0000 0000 1000 0000
       Delay_ms(100);
    }
}
