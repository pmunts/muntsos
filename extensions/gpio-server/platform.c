// Identify the GPIO platform

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

#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

#include <platform.h>

static unsigned platform = 0xDEADBEEF;

static const uint8_t PinTable[MAX_PLATFORMS][16] =
{
  // BeagleBone (original) without eMMC
  {
    0x0C, 0xF0, 0x0B, 0x30, 0xFF, 0x0F, 0xF0, 0x0F,
    0x7F, 0xFC, 0xC3, 0xC0, 0x00, 0x00, 0x14, 0x00
  },

  // BeagleBone Black/Black Wireless/Green with eMMC
  {
    0x0C, 0xF0, 0x0B, 0x30, 0x00, 0x0F, 0xF0, 0x0C,
    0x7F, 0xFC, 0xC3, 0xC0, 0x00, 0x00, 0x14, 0x00
  },

  // BeagleBone Green Wireless with eMMC and WL1835
  {
    0x0C, 0xF0, 0x03, 0x00, 0x00, 0x00, 0xF0, 0x00,
    0x3F, 0xFC, 0xC3, 0xC0, 0x00, 0x00, 0x14, 0x00
  },

  // PocketBeagle
  {
    0x00, 0x00, 0x09, 0x30, 0x00, 0x0F, 0x28, 0x78,
    0xC0, 0x00, 0x03, 0xC0, 0x00, 0x03, 0xFC, 0x00
  },

  // Old Raspberry Pi with 26-pin header
  {
    0x08, 0x00, 0x63, 0xD0, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  },

  // New Raspberry Pi with 40-pin header
  {
    0x0E, 0x0C, 0xFF, 0xF0, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
  }
};

static const uint8_t bitmasks[8] =
{
  0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01
};

// Detect the plaform ID

void GPIO_Platform_Init(void)
{
  char *bn = getenv("BOARDNAME");

  // BeagleBone (original) without eMMC

  if (!strcmp(bn, "BeagleBone"))
  {
    syslog(LOG_INFO, "Detected BeagleBone without eMMC");
    platform = BeagleBoneWhite;
    return;
  }

  // BeagleBone Black/Black Wireless/Green with eMMC

  if (!strcmp(bn, "BeagleBoneBlack") ||
      !strcmp(bn, "BeagleBoneBlackWireless") ||
      !strcmp(bn, "BeagleBoneGreen"))
  {
    syslog(LOG_INFO, "Detected BeagleBone Black with eMMC");
    platform = BeagleBoneBlack;
    return;
  }

  // BeagleBone Green Wireless with eMMC and WL1835

  if (!strcmp(bn, "BeagleBoneGreenWireless"))
  {
    syslog(LOG_INFO, "Detected BeagleBone Green Wireless with eMMC and WL1835");
    platform = BeagleBoneGreenWireless;
    return;
  }

  // PocketBeagle

  if (!strcmp(bn, "PocketBeagle"))
  {
    syslog(LOG_INFO, "Detected PocketBeagle");
    platform = PocketBeagle;
    return;
  }

  // Raspberry Pi

  if (strstr(bn, "RaspberryPi"))
  {
    FILE *f;
    char buf[256];

    // Read /proc/cpuinfo to determine whether this is an old Raspberry Pi
    // with a 26-pin expansion header or a new Raspberry Pi with a 40-pin
    // expansion header.  All 40-pin models have a revision number > 15.

    f = popen("awk '/^Revision/ { print $3 }' /proc/cpuinfo", "r");
    if (f == NULL)
    {
      syslog(LOG_ERR, "ERROR: popen() failed, %s\n", strerror(errno));
      exit(1);
    }

    memset(buf, 0, sizeof(buf));
    fgets(buf, sizeof(buf), f);
    fclose(f);

    if (strtoul(buf, NULL, 16) <= 0x0F)
    {
      syslog(LOG_INFO, "Detected Raspberry Pi with 26-pin expansion header");
      platform = RaspberryPi26;
    }
    else
    {
      syslog(LOG_INFO, "Detected Raspberry Pi with 40-pin expansion header");
      platform = RaspberryPi40;
    }

    return;
  }

  syslog(LOG_ERR, "ERROR: Cannot identify the hardware platform.");
  exit(1);
}

// Return the detected platform ID

unsigned GPIO_Platform(void)
{
  return platform;
}

// Return an array of bytes which indicates which GPIO pins are available
// GPIO0 is first byte MSB and GPIO127 is fourth byte LSB

const uint8_t * const GPIO_Platform_Pins(void)
{
  return PinTable[platform];
}

// Test whether a particular pin is valid

bool GPIO_Platform_Pin_Valid(unsigned pin)
{
  if (pin >= MAX_PLATFORM_PINS) return true;

  return (PinTable[platform][pin / 8] & bitmasks[pin % 8]);
}
