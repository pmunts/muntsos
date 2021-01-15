// Raspberry Pi device definitions

// Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

#ifndef __RASPBERRYPI_H
#define __RASPBERRYPI_H

#include <gpio-libsimpleio.h>

namespace RaspberryPi
{
  // The following GPIO pins are available on all Raspberry Pi Models

  const libsimpleio::GPIO::Designator GPIO2  = { 0,  2 };  // I2C1 SDA
  const libsimpleio::GPIO::Designator GPIO3  = { 0,  3 };  // I2C1 SCL
  const libsimpleio::GPIO::Designator GPIO4  = { 0,  4 };
  const libsimpleio::GPIO::Designator GPIO7  = { 0,  7 };  // SPI0 SS1
  const libsimpleio::GPIO::Designator GPIO8  = { 0,  8 };  // SPI0 SS0
  const libsimpleio::GPIO::Designator GPIO9  = { 0,  9 };  // SPI0 MISO
  const libsimpleio::GPIO::Designator GPIO10 = { 0, 10 };  // SPI0 MOSI
  const libsimpleio::GPIO::Designator GPIO11 = { 0, 11 };  // SPI0 SCLK
  const libsimpleio::GPIO::Designator GPIO14 = { 0, 14 };  // UART0 TXD
  const libsimpleio::GPIO::Designator GPIO15 = { 0, 15 };  // UART0 RXD
  const libsimpleio::GPIO::Designator GPIO17 = { 0, 17 };
  const libsimpleio::GPIO::Designator GPIO18 = { 0, 18 };  // PWM0
  const libsimpleio::GPIO::Designator GPIO22 = { 0, 22 };
  const libsimpleio::GPIO::Designator GPIO23 = { 0, 23 };
  const libsimpleio::GPIO::Designator GPIO24 = { 0, 24 };
  const libsimpleio::GPIO::Designator GPIO25 = { 0, 25 };
  const libsimpleio::GPIO::Designator GPIO27 = { 0, 27 };

  // The following GPIO pins are only available on Raspberry Pi Model
  // B+ and later, with 40-pin expansion headers

  const libsimpleio::GPIO::Designator GPIO5  = { 0,  5 };
  const libsimpleio::GPIO::Designator GPIO6  = { 0,  6 };
  const libsimpleio::GPIO::Designator GPIO12 = { 0, 12 };
  const libsimpleio::GPIO::Designator GPIO13 = { 0, 13 };
  const libsimpleio::GPIO::Designator GPIO16 = { 0, 16 };  // SPI1 SS0
  const libsimpleio::GPIO::Designator GPIO19 = { 0, 19 };  // SPI1 MISO, PWM1
  const libsimpleio::GPIO::Designator GPIO20 = { 0, 20 };  // SPI1 MOSI
  const libsimpleio::GPIO::Designator GPIO21 = { 0, 21 };  // SPI1 SCLK
  const libsimpleio::GPIO::Designator GPIO26 = { 0, 26 };

  // TODO: Add compute module pins?
}

#endif
