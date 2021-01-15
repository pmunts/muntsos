// Definitions for the Pimoroni Automation PHAT

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#ifndef _PIMORONI_PHAT_AUTOMATION_H
#define _PIMORONI_PHAT_AUTOMATION_H

#include <ads1015.h>
#include <gpio-libsimpleio.h>
#include <i2c-libsimpleio.h>
#include <raspberrypi.h>

// I2C bus controller

#define I2CDEV		"/dev/i2c-1"
#define I2CBUS		new libsimpleio::I2C::Bus_Class(I2CDEV)

// GPIO pin assignments

#define GPIO_INPUT1	RaspberryPi::GPIO26
#define GPIO_INPUT2	RaspberryPi::GPIO20
#define GPIO_INPUT3	RaspberryPi::GPIO21

#define GPIO_OUTPUT1	RaspberryPi::GPIO5
#define GPIO_OUTPUT2	RaspberryPi::GPIO12
#define GPIO_OUTPUT3	RaspberryPi::GPIO6

#define GPIO_RELAY	RaspberryPi::GPIO16

// I2C address assignments

#define	ADDR_ADS1015	0x48

// A/D converter constants

#define ADCGAIN		0.128

#endif
