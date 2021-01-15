// Raw HID Device Test Program

// Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include <libsimpleio/libhidraw.h>

int main(int argc, char *argv[])
{
  int fd;
  int error;
  char buf[256];
  int bustype, vendor, product;

  printf("\nRaw HID Device Test\n\n");
  fflush(stdout);

  if (argc != 2)
  {
    fprintf(stderr, "Usage: test_hidraw <device node>\n\n");
    exit(1);
  }

  HIDRAW_open1(argv[1], &fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: HIDRAW_open() failed, %s\n", strerror(error));
    exit(1);
  }

  HIDRAW_get_name(fd, buf, sizeof(buf), &error);
  if (error)
  {
    fprintf(stderr, "ERROR: HIDRAW_get_name() failed, %s\n", strerror(error));
    exit(1);
  }

  printf("HID raw device name string is: %s\n", buf);

  HIDRAW_get_info(fd, &bustype, &vendor, &product, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: HIDRAW_get_info() failed, %s\n", strerror(error));
    exit(1);
  }

  printf("Bus:%02X Vendor:%04X Product:%04X\n", bustype, vendor, product);

  HIDRAW_close(fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: HIDRAW_open() failed, %s\n", strerror(error));
    exit(1);
  }

  exit(0);
}
