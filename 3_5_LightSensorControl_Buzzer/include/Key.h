#ifndef __KEY_H
#define __KEY_H

#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "Delay.h"

void Key_Init(void);
uint8_t Key_GetNum(void);


#endif /* ifndef __KEY_H */
