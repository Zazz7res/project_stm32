#include "stm32f10x.h"                  // Device header
#include "Delay.h"
#include "OLED.h"
#include "Timer.h"
#include "stm32f10x_tim.h"
#include <stdint.h>

uint16_t Num;

int main(void)
{
    // ✅ 2. 防砖代码 (添加在这里)
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    GPIO_InitTypeDef GPIO_InitStruct;
    GPIO_InitStruct.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
    GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;  // 推挽输出
    GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOA, &GPIO_InitStruct);
    GPIO_ResetBits(GPIOA, GPIO_Pin_11 | GPIO_Pin_12);  // 拉低
    Delay_ms(10);  // 稳定电平
	/*模块初始化*/
    OLED_Init();//OLED初始化
    Timer_Init();
	 __enable_irq();  // <--- 添加这一行！使能全局中断
    /*OLED显示*/
	OLED_ShowString(1, 1, "Num:");	
	OLED_ShowString(2, 1, "CNT:");	
	
	while (1)
	{
	    OLED_ShowNum(1, 5, Num, 5);
	    OLED_ShowNum(2, 5, Timer_GetCounter(), 5);

	}
}

void TIM2_IRQHandler(void)
{
    if (TIM_GetITStatus(TIM2, TIM_IT_Update) == SET)
    {
        Num ++;
        TIM_ClearITPendingBit(TIM2, TIM_IT_Update);
    }
}
