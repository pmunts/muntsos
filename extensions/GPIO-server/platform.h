// Identify the GPIO platform

// Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

#ifndef _GPIO_PLATFORM_H_
#define _GPIO_PLATFORM_H_

#include <stdbool.h>
#include <stdint.h>

#include <libsimpleio/cplusplus.h>

_BEGIN_STD_C

#define MAX_PLATFORM_PINS 128

enum Platforms
{
  BeagleBoneWhite,
  BeagleBoneBlack,		// Commandeers pins for eMMC
  BeagleBoneGreenWireless,	// Commandeers pins for eMMC and WL18xx
  PocketBeagle,
  RaspberryPi26,		// Original Model A and B w/26 pin expansion header
  RaspberryPi40,		// All subsequent models  w/40 pin expansioh header
  MAX_PLATFORMS
};

// Detect the platform ID

extern void GPIO_Platform_Init(void);

// Return the detected platform ID

extern unsigned GPIO_Platform(void);

// Return an array of bytes which indicates which GPIO pins are available
// GPIO0 is first byte MSB and GPIO127 is fourth byte LSB

extern const uint8_t * const GPIO_Platform_Pins(void);

// Test whether a particular pin is valid

extern bool GPIO_Platform_Pin_Valid(unsigned pin);

_END_STD_C

#endif
