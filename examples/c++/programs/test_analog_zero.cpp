// RaspIO Analog Zero Test

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
#include <unistd.h>

#include <raspio-analog-zero.h>

int main(void)
{
  puts("\nRaspIO Analog Zero Test\n");

  Devices::MCP3208::Device dev = new Devices::MCP3208::Device_Class(SPIDEV);
  Interfaces::ADC::Voltage inputs[Devices::MCP3208::MaxChannels];

  for (unsigned c = 0; c < Devices::MCP3208::MaxChannels; c++)
    inputs[c] =
      new Interfaces::ADC::Input_Class(new Devices::MCP3208::Sample_Class(dev, c),
        ADCREF, ADCGAIN);

  puts("Press CONTROL-C to exit.\n");

  for (;;)
  {
    printf("Inputs:");
    for (unsigned c = 0; c< Devices::MCP3208::MaxChannels; c++)
      printf("%5.2f", double(*inputs[c]));
    putchar('\n');

    sleep(1);
  }
}
