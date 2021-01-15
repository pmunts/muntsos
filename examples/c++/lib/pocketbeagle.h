// PocketBeagle device definitions

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

#ifndef __POCKETBEAGLE_H
#define __POCKETBEAGLE_H

#include <gpio-libsimpleio.h>

namespace PocketBeagle
{
  const libsimpleio::GPIO::Designator GPIO2   = { 0,  2};  // P1.8   SPI0 SCLK
  const libsimpleio::GPIO::Designator GPIO3   = { 0,  3};  // P1.10  SPI0 MISO
  const libsimpleio::GPIO::Designator GPIO4   = { 0,  4};  // P1.12  SPI0 MOSI
  const libsimpleio::GPIO::Designator GPIO5   = { 0,  5};  // P1.6   SPI0 CS
  const libsimpleio::GPIO::Designator GPIO7   = { 0,  7};  // P2.29  SPI1 SCLK
  const libsimpleio::GPIO::Designator GPIO12  = { 0, 12};  // P1.26  I2C2 SDA
  const libsimpleio::GPIO::Designator GPIO13  = { 0, 13};  // P1.28  I2C2 SCL
  const libsimpleio::GPIO::Designator GPIO14  = { 0, 14};  // P2.11  I2C1 SDA
  const libsimpleio::GPIO::Designator GPIO15  = { 0, 15};  // P2.9   I2C1 SCL
  const libsimpleio::GPIO::Designator GPIO19  = { 0, 19};  // P2.31  SPI1 CS
  const libsimpleio::GPIO::Designator GPIO20  = { 0, 20};  // P1.20
  const libsimpleio::GPIO::Designator GPIO23  = { 0, 23};  // P2.3
  const libsimpleio::GPIO::Designator GPIO26  = { 0, 26};  // P1.34
  const libsimpleio::GPIO::Designator GPIO27  = { 0, 27};  // P2.19
  const libsimpleio::GPIO::Designator GPIO30  = { 0, 30};  // P2.5   RXD4
  const libsimpleio::GPIO::Designator GPIO31  = { 0, 31};  // P2.7   TXD4
  const libsimpleio::GPIO::Designator GPIO40  = { 1,  8};  // P2.27  SPI1 MISO
  const libsimpleio::GPIO::Designator GPIO41  = { 1,  9};  // P2.25  SPI1 MOSI
  const libsimpleio::GPIO::Designator GPIO42  = { 1, 10};  // P1.32  RXD0
  const libsimpleio::GPIO::Designator GPIO43  = { 1, 11};  // P1.30  TXD0
  const libsimpleio::GPIO::Designator GPIO44  = { 1, 12};  // P2.24
  const libsimpleio::GPIO::Designator GPIO45  = { 1, 13};  // P2.33
  const libsimpleio::GPIO::Designator GPIO46  = { 1, 14};  // P2.22
  const libsimpleio::GPIO::Designator GPIO47  = { 1, 15};  // P2.18
  const libsimpleio::GPIO::Designator GPIO50  = { 1, 18};  // P2.1
  const libsimpleio::GPIO::Designator GPIO52  = { 1, 20};  // P2.10
  const libsimpleio::GPIO::Designator GPIO57  = { 1, 25};  // P2.6
  const libsimpleio::GPIO::Designator GPIO58  = { 1, 26};  // P2.4
  const libsimpleio::GPIO::Designator GPIO59  = { 1, 27};  // P2.2
  const libsimpleio::GPIO::Designator GPIO60  = { 1, 28};  // P2.8
  const libsimpleio::GPIO::Designator GPIO64  = { 2,  0};  // P2.20
  const libsimpleio::GPIO::Designator GPIO65  = { 2,  1};  // P2.17
  const libsimpleio::GPIO::Designator GPIO86  = { 2, 22};  // P2.35  AIN5 3.3V
  const libsimpleio::GPIO::Designator GPIO87  = { 2, 23};  // P1.2   AIN6 3.3V
  const libsimpleio::GPIO::Designator GPIO88  = { 2, 24};  // P1.35
  const libsimpleio::GPIO::Designator GPIO89  = { 2, 25};  // P1.4
  const libsimpleio::GPIO::Designator GPIO110 = { 3, 14};  // P1.36
  const libsimpleio::GPIO::Designator GPIO111 = { 3, 15};  // P1.33
  const libsimpleio::GPIO::Designator GPIO112 = { 3, 16};  // P2.32
  const libsimpleio::GPIO::Designator GPIO113 = { 3, 17};  // P2.30
  const libsimpleio::GPIO::Designator GPIO114 = { 3, 18};  // P1.31
  const libsimpleio::GPIO::Designator GPIO115 = { 3, 19};  // P2.34
  const libsimpleio::GPIO::Designator GPIO116 = { 3, 20};  // P2.28
  const libsimpleio::GPIO::Designator GPIO117 = { 3, 21};  // P1.29
}

#endif
