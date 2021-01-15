// Definitions for the AB Electronics ADC DAC Pi Zero

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

#ifndef _ABELECTRONICS_ADC_DAC_PI_ZERO_H
#define _ABELECTRONICS_ADC_DAC_PI_ZERO_H

#include <spi-libsimpleio.h>
#include <mcp3202.h>
#include <mcp4822.h>

// Configuration constants

#define ADCREF	3.3
#define ADCGAIN	1.0

#define DACREF	3.3
#define DACGAIN	1.0

// Devices on this board

Devices::MCP3202::Device const ADCDEV =
  new Devices::MCP3202::Device_Class(new libsimpleio::SPI::Device_Class("/dev/spidev0.0", 0, 8, 1000000));

Devices::MCP4822::Device const DACDEV =
  new Devices::MCP4822::Device_Class(new libsimpleio::SPI::Device_Class("/dev/spidev0.1", 0, 8, 20000000));

#endif
