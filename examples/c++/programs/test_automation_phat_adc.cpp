// Raspberry Pi Automation PHAT Analog Input Test

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

#include <pimoroni-phat-automation.h>

// Analog input calibration factors, determined experimentally. These values
// probably reflect the tolerances of the input scaling resistors.  They are
// specific to *MY* Automation PHAT!  You will need to measure your own...

#define CAL1	1.01015228426
#define CAL2	1.00861632032
#define CAL3	1.01323828921

int main(void)
{
  puts("\nRaspberry Pi Automation PHAT Analog Input Test\n");

  Devices::ADS1015::Device dev =
    new Devices::ADS1015::Device_Class(I2CBUS, ADDR_ADS1015);

  Interfaces::ADC::Voltage Input1 = new Devices::ADS1015::Input_Class(dev,
    Devices::ADS1015::AIN0, Devices::ADS1015::FSR4096, ADCGAIN/CAL1);
  Interfaces::ADC::Voltage Input2 = new Devices::ADS1015::Input_Class(dev,
    Devices::ADS1015::AIN1, Devices::ADS1015::FSR4096, ADCGAIN/CAL2);
  Interfaces::ADC::Voltage Input3 = new Devices::ADS1015::Input_Class(dev,
    Devices::ADS1015::AIN2, Devices::ADS1015::FSR4096, ADCGAIN/CAL3);

  puts("Press CONTROL-C to exit.\n");

  for (;;)
  {
    printf("%1.2f V   %1.2f V   %1.2f V\n", double(*Input1), double(*Input2),
      double(*Input3));
    sleep(1);
  }
}
