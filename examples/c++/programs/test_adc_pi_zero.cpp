// AB Electronics ADC Pi Zero Test

// Copyright (C)2017-2024, Philip Munts dba Munts Technologies.
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

#include <cstdio>

#include <abelectronics-adc-pi-zero.h>

#define ADCCHANNELS	2*Devices::MCP3424::MaxChannels
#define ADCRESOLUTION	Devices::MCP3424::RES16
#define ADCRANGE	Devices::MCP3424::PGA1

int main(void)
{
  puts("\nAB Electronics ADC Pi Zero Test\n");

  Interfaces::ADC::Voltage inputs[ADCCHANNELS];

  for (unsigned c = 0; c < Devices::MCP3424::MaxChannels; c++)
    inputs[c] = new Devices::MCP3424::Input_Class(ADCDEV1, c,
      ADCRESOLUTION, ADCRANGE, ADCGAIN);

  for (unsigned c = 0; c < Devices::MCP3424::MaxChannels; c++)
    inputs[Devices::MCP3424::MaxChannels+c] =
      new Devices::MCP3424::Input_Class(ADCDEV2, c, ADCRESOLUTION, ADCRANGE,
        ADCGAIN);

  puts("Press CONTROL-C to exit.\n");

  for (;;)
  {
    for (unsigned c = 0; c < ADCCHANNELS; c++)
      printf("%-1.4f ", double(*inputs[c]));
    putchar('\n');
    fflush(stdout);
  }
}
