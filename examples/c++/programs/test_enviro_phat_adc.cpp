// Raspberry Pi Enviro PHAT Analog Input Test

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

#include <pimoroni-phat-enviro.h>

int main(void)
{
  puts("\nRaspberry Pi Enviro PHAT Analog Input Test\n");

  Devices::ADS1015::Device dev =
    new Devices::ADS1015::Device_Class(I2CBUS, ADDR_ADS1015);

  Interfaces::ADC::Voltage Inputs[Devices::ADS1015::MaxChannels];

  for (unsigned c = 0; c < Devices::ADS1015::MaxChannels; c++)
    Inputs[c] = new Devices::ADS1015::Input_Class(dev, c,
      Devices::ADS1015::FSR6144, ADCGAIN);

  puts("Press CONTROL-C to exit.\n");

  for (;;)
  {
    for (unsigned c = 0; c < Devices::ADS1015::MaxChannels; c++)
      printf("%1.2f V  ", double(*Inputs[c]));
    putchar('\n');
    sleep(1);
  }
}
