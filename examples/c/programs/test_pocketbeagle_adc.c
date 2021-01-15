// PocketBeagle Analog Input Test

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

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <libsimpleio/libadc.h>

#define MAX_CHANNELS	8

int main(void)
{
  char devname[256];
  int32_t error;
  int i;
  int32_t fds[MAX_CHANNELS];
  int32_t sample;

  printf("\nPocketBeagle Analog Input Test\n\n");
  fflush(stdout);

  ADC_get_name(0, devname, sizeof(devname), &error);
  if (error)
  {
    fprintf(stderr, "ERROR: ADC_get_name() failed, %s\n", strerror(errno));
    exit(1);
  }

  printf("Device name: %s\n\n", devname);

  for (i = 0; i < MAX_CHANNELS; i++)
  {
    ADC_open(0, i, &fds[i], &error);
    if (error)
    {
      fprintf(stderr, "ERROR: ADC_open() failed, %s\n", strerror(errno));
      exit(1);
    }
  }

  for (;;)
  {
    for (i = 0; i < MAX_CHANNELS; i++)
    {
      ADC_read(fds[i], &sample, &error);
      if (error)
      {
        fprintf(stderr, "ERROR: ADC_open() failed, %s\n", strerror(errno));
        exit(1);
      }

      printf("%-6d", sample);
    }

    putchar('\n');
    sleep(2);
  }
}
