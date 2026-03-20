#ifndef __LIGHT_SENSOR_H
#define __LIGHT_SENSOR_H 

#include "stm32f10x.h"
#include "stm32f10x.h"
#include "stm32f10x_gpio.h"

void LightSensor_Init(void);
uint8_t LightSensor_Get(void);


#endif /* ifndef __LIGHT_SENSOR_H */
