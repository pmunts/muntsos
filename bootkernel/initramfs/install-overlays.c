// Install the device tree overlays listed in /boot/overlays.txt

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

#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CONFIG_FILENAME	"/boot/overlays.txt"
#define BUFSIZE		256

static void Trim(char *src, char *dst)
{
  while (*src)
  {
    if (*src == 0) return;
    if (*src == '#') return;
    if (*src == '-') *dst++ = '-';
    if (*src == '_') *dst++ = '_';
    if (isalnum((int) *src)) *dst++ = *src;
    src++;
  }
}

int main(void)
{
  FILE *cfgfile;
  char readbuf[256];
  char trimbuf[256];
  char cmdbuf[256];

  // Check whether the config file is available

  if (access(CONFIG_FILENAME, R_OK))
    exit(0);

  // Open the config file

  cfgfile = fopen(CONFIG_FILENAME, "r");
  if (cfgfile == NULL)
  {
    fprintf(stderr, "ERROR: Cannot open %s, %s\n", CONFIG_FILENAME,
      strerror(errno));
    exit(1);
  }

  // Install overlays listed in the config file

  while (fgets(readbuf, sizeof(readbuf), cfgfile) != NULL)
  {
    memset(trimbuf, 0, sizeof(trimbuf));
    Trim(readbuf, trimbuf);
    if (trimbuf[0] == 0) continue;

    if (!access("/sys/devices/platform/bone_capemgr/slots", W_OK))
    {
      // Install overlay using Cape Manager
      snprintf(cmdbuf, sizeof(cmdbuf), "echo %s >/sys/devices/platform/bone_capemgr/slots", trimbuf);
      system(cmdbuf);
    }
    else if (!access("/sys/kernel/config/device-tree/overlays", F_OK))
    {
      // Install overlay using sysfs
      snprintf(cmdbuf, sizeof(cmdbuf), "mkdir /sys/kernel/config/device-tree/overlays/%s", trimbuf);
      system(cmdbuf);
      snprintf(cmdbuf, sizeof(cmdbuf), "cat /boot/overlays/%s.dtbo >/sys/kernel/config/device-tree/overlays/%s/dtbo", trimbuf, trimbuf);
      system(cmdbuf);
    }
  }

  // Close the config file

  fclose(cfgfile);

  // Create device nodes

  system("mdev -s");
  exit(0);
}
