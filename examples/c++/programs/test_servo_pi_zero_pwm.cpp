// AB Electronics Servo Pi Zero PWM Output Test

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

#include <abelectronics-servo-pi-zero.h>

int main(void)
{
  puts("\nAB Electronics Servo Pi Zero PWM Output Test\n");

  // Configure all PCA9685 channels as PWM outputs

  Interfaces::PWM::Output outputs[Devices::PCA9685::MaxChannels];

  for (unsigned c = 0; c < Devices::PCA9685::MaxChannels; c++)
    outputs[c] = new Devices::PCA9685::PWM_Output_Class(PCA9685DEV, c,
      Interfaces::PWM::DUTYCYCLE_MIN);

  // Sweep the PWM outputs

  puts("Press CONTROL-C to exit.\n");

  for (;;)
  {
    double d;

    for (d = 0.0 ; d <= 100.0; d += 0.01)
    {
      for (unsigned c = 0; c < Devices::PCA9685::MaxChannels; c++)
        *outputs[c] = d;

      usleep(10000);
    }

    for (d = 100.0 ; d >= 0.0; d -= 0.01)
    {
      for (unsigned c = 0; c < Devices::PCA9685::MaxChannels; c++)
        *outputs[c] = d;

      usleep(10000);
    }
  }
}
