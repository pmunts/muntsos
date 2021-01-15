// AB Electronics ADC DAC Pi Zero analog input test

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

#include <cstdio>

#include <abelectronics-adc-dac-pi-zero.h>

int main(void)
{
  Interfaces::ADC::Voltage inputs[Devices::MCP3202::MaxChannels];
  Interfaces::DAC::Voltage outputs[Devices::MCP4822::MaxChannels];

  puts("\nAB Electronics ADC DAC Pi Zero analog input test\n");

  for (unsigned c = 0; c < Devices::MCP3202::MaxChannels; c++)
    inputs[c] =
      new Interfaces::ADC::Input_Class(new Devices::MCP3202::Sample_Class(ADCDEV, c), ADCREF);

  for (unsigned c = 0; c < Devices::MCP4822::MaxChannels; c++)
    outputs[c] =
      new Interfaces::DAC::Output_Class(new Devices::MCP4822::Sample_Class(DACDEV, c), DACREF);

  puts("Press CONTROL-C to exit.\n");

  for (;;)
    for (unsigned c = 0; c < Devices::MCP4822::MaxChannels; c++)
    {
      for (unsigned v = 0; v < 3300; v++)
      {
        *outputs[c] = v/1000.0;

        printf("%1.2f %1.2f   ", double(*inputs[0]), double(*inputs[1]));

        if ((v % 6) == 5) putchar('\n');
        fflush(stdout);
      }

      *outputs[c] = 0.0;
    }
}
