// Definitions for the AB Electronics ADC Pi Zero

// Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
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

#ifndef _ABELECTRONICS_ADC_PI_ZERO_H
#define _ABELECTRONICS_ADC_PI_ZERO_H

#include <i2c-libsimpleio.h>
#include <mcp3424.h>

// Configuration constants

#define I2CDEV		"/dev/i2c-1"
#define I2CADDR1	0x68
#define I2CADDR2	0x69

#define ADCGAIN		0.4048

// Devices on this board

Interfaces::I2C::Bus const I2CBUS = new libsimpleio::I2C::Bus_Class(I2CDEV);

Devices::MCP3424::Device const ADCDEV1 =
  new Devices::MCP3424::Device_Class(I2CBUS, I2CADDR1);

Devices::MCP3424::Device const ADCDEV2 =
  new Devices::MCP3424::Device_Class(I2CBUS, I2CADDR2);

#endif
