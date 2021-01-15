// Definitions for the Pimoroni Enviro PHAT

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

#ifndef _PIMORONI_PHAT_ENVIRO_H
#define _PIMORONI_PHAT_ENVIRO_H

#include <ads1015.h>
#include <gpio-libsimpleio.h>
#include <i2c-libsimpleio.h>
#include <raspberrypi.h>

// I2C bus controller

#define I2CDEV		"/dev/i2c-1"
#define I2CBUS		new libsimpleio::I2C::Bus_Class(I2CDEV)

// GPIO pin assignments

#define GPIO_LEDS	RaspberryPi::GPIO5

// I2C address assignments

#define	ADDR_ADS1015	0x49
#define ADDR_BMP280	0x77
#define ADDR_LSM303D	0x1D
#define ADDR_TCS3472	0x29

// A/D converter constants

#define ADCGAIN		1.0

#endif
