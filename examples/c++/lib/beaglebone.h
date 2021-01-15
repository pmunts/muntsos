// BeagleBone device definitions

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

#ifndef __BEAGLEBONE_H
#define __BEAGLEBONE_H

#include <gpio-libsimpleio.h>

namespace BeagleBone
{
  const libsimpleio::GPIO::Designator GPIO2   = { 0,  2 };  // P9.22  UART2 RXD
  const libsimpleio::GPIO::Designator GPIO3   = { 0,  3 };  // P9.21  UART2 TXD
  const libsimpleio::GPIO::Designator GPIO4   = { 0,  4 };  // P9.18
  const libsimpleio::GPIO::Designator GPIO5   = { 0,  5 };  // P9.17
  const libsimpleio::GPIO::Designator GPIO7   = { 0,  7 };  // P9.42  SPI1 SS1
  const libsimpleio::GPIO::Designator GPIO8   = { 0,  8 };  // P8.35
  const libsimpleio::GPIO::Designator GPIO9   = { 0,  9 };  // P8.33
  const libsimpleio::GPIO::Designator GPIO10  = { 0, 10 };  // P8.31
  const libsimpleio::GPIO::Designator GPIO11  = { 0, 11 };  // P8.32
  const libsimpleio::GPIO::Designator GPIO12  = { 0, 12 };  // P9.20  I2C2 SDA
  const libsimpleio::GPIO::Designator GPIO13  = { 0, 13 };  // P9.19  I2C2 SCL
  const libsimpleio::GPIO::Designator GPIO14  = { 0, 14 };  // P9.26  UART1 RXD
  const libsimpleio::GPIO::Designator GPIO15  = { 0, 15 };  // P9.24  UART1 TXD
  const libsimpleio::GPIO::Designator GPIO20  = { 0, 20 };  // P9.41
  const libsimpleio::GPIO::Designator GPIO22  = { 0, 22 };  // P8.19
  const libsimpleio::GPIO::Designator GPIO23  = { 0, 23 };  // P8.13
  const libsimpleio::GPIO::Designator GPIO26  = { 0, 26 };  // P8.14
  const libsimpleio::GPIO::Designator GPIO27  = { 0, 27 };  // P8.17
  const libsimpleio::GPIO::Designator GPIO30  = { 0, 30 };  // P9.11  UART4 RXD
  const libsimpleio::GPIO::Designator GPIO31  = { 0, 31 };  // P9.13  UART4 TXD
  const libsimpleio::GPIO::Designator GPIO32  = { 1,  0 };  // P8.25  MMC1 DAT0
  const libsimpleio::GPIO::Designator GPIO33  = { 1,  1 };  // P8.24  MMC1 DAT1
  const libsimpleio::GPIO::Designator GPIO34  = { 1,  2 };  // P8.5   MMC1 DAT2
  const libsimpleio::GPIO::Designator GPIO35  = { 1,  3 };  // P8.6   MMC1 DAT3
  const libsimpleio::GPIO::Designator GPIO36  = { 1,  4 };  // P8.23  MMC1 DAT4
  const libsimpleio::GPIO::Designator GPIO37  = { 1,  5 };  // P8.22  MMC1 DAT5
  const libsimpleio::GPIO::Designator GPIO38  = { 1,  6 };  // P8.3   MMC1 DAT6
  const libsimpleio::GPIO::Designator GPIO39  = { 1,  7 };  // P8.4   MMC1 DAT7
  const libsimpleio::GPIO::Designator GPIO44  = { 1, 12 };  // P8.12
  const libsimpleio::GPIO::Designator GPIO45  = { 1, 13 };  // P8.11
  const libsimpleio::GPIO::Designator GPIO46  = { 1, 14 };  // P8.16
  const libsimpleio::GPIO::Designator GPIO47  = { 1, 15 };  // P8.15
  const libsimpleio::GPIO::Designator GPIO48  = { 1, 16 };  // P9.15
  const libsimpleio::GPIO::Designator GPIO49  = { 1, 17 };  // P9.23
  const libsimpleio::GPIO::Designator GPIO50  = { 1, 18 };  // P9.14
  const libsimpleio::GPIO::Designator GPIO51  = { 1, 19 };  // P9.16
  const libsimpleio::GPIO::Designator GPIO60  = { 1, 28 };  // P9.12
  const libsimpleio::GPIO::Designator GPIO61  = { 1, 29 };  // P8.26
  const libsimpleio::GPIO::Designator GPIO62  = { 1, 30 };  // P8.21  MMC1 CLK
  const libsimpleio::GPIO::Designator GPIO63  = { 1, 31 };  // P8.20  MMC1 CMD
  const libsimpleio::GPIO::Designator GPIO65  = { 2,  1 };  // P8.18
  const libsimpleio::GPIO::Designator GPIO66  = { 2,  2 };  // P8.7
  const libsimpleio::GPIO::Designator GPIO67  = { 2,  3 };  // P8.8
  const libsimpleio::GPIO::Designator GPIO68  = { 2,  4 };  // P8.10
  const libsimpleio::GPIO::Designator GPIO69  = { 2,  5 };  // P8.9
  const libsimpleio::GPIO::Designator GPIO70  = { 2,  6 };  // P8.45
  const libsimpleio::GPIO::Designator GPIO71  = { 2,  7 };  // P8.46
  const libsimpleio::GPIO::Designator GPIO72  = { 2,  8 };  // P8.43
  const libsimpleio::GPIO::Designator GPIO73  = { 2,  9 };  // P8.44
  const libsimpleio::GPIO::Designator GPIO74  = { 2, 10 };  // P8.41
  const libsimpleio::GPIO::Designator GPIO75  = { 2, 11 };  // P8.42
  const libsimpleio::GPIO::Designator GPIO76  = { 2, 12 };  // P8.39
  const libsimpleio::GPIO::Designator GPIO77  = { 2, 13 };  // P8.40
  const libsimpleio::GPIO::Designator GPIO78  = { 2, 14 };  // P8.37  UART5 TXD
  const libsimpleio::GPIO::Designator GPIO79  = { 2, 15 };  // P8.38  UART5 RXD
  const libsimpleio::GPIO::Designator GPIO80  = { 2, 16 };  // P8.36
  const libsimpleio::GPIO::Designator GPIO81  = { 2, 17 };  // P8.34
  const libsimpleio::GPIO::Designator GPIO86  = { 2, 22 };  // P8.27
  const libsimpleio::GPIO::Designator GPIO87  = { 2, 23 };  // P8.29
  const libsimpleio::GPIO::Designator GPIO88  = { 2, 24 };  // P8.28
  const libsimpleio::GPIO::Designator GPIO89  = { 2, 25 };  // P8.30
  const libsimpleio::GPIO::Designator GPIO110 = { 3, 14 };  // P9.31  SPI1 SCLK
  const libsimpleio::GPIO::Designator GPIO111 = { 3, 15 };  // P9.29  SPI1 MISO
  const libsimpleio::GPIO::Designator GPIO112 = { 3, 16 };  // P9.30  SPI1 MOSI
  const libsimpleio::GPIO::Designator GPIO113 = { 3, 17 };  // P9.28  SPI1 SS0
  const libsimpleio::GPIO::Designator GPIO115 = { 3, 19 };  // P9.27
  const libsimpleio::GPIO::Designator GPIO117 = { 3, 21 };  // P9.25
}

#endif
