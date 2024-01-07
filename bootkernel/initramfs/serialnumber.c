// Display this computer's serial number.

// Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/mman.h>

/* Strip leading and trailing whitespace from a string */

void deblank(char *s)
{
  char *p1, *p2;

  if (strlen(s) == 0) return;

  p1 = s;
  p2 = malloc(strlen(s) + 1);

/* Skip leading whitespace */

  while (isspace(*p1)) p1++;

  strcpy(p2, p1);

/* Now strip trailing whitespace */

  while ((strlen(p2) > 0) && (isspace(p2[strlen(p2)-1])))
    p2[strlen(p2)-1] = 0;

/* Copy resultant back */

  strcpy(s, p2);

  free(p2);
}

int main(void)
{
  // First, try to read /boot/serialnumber.txt.  This allows us to override a
  // hardware serial number, if we need to for some odd reason.

  if (!access("/boot/serialnumber.txt", R_OK))
  {
    int fd = open("/boot/serialnumber.txt", O_RDONLY);

    if (fd < 0)
    {
      fprintf(stderr, "ERROR: open() failed, %s\n", strerror(errno));
      exit(1);
    }

    char buf[256];
    memset(buf, 0, sizeof(buf));
    ssize_t len = read(fd, buf, sizeof(buf) - 1);

    if (len < 0)
    {
      fprintf(stderr, "ERROR: read() failed, %s\n", strerror(errno));
      exit(1);
    }

    deblank(buf);
    printf("%s\n", buf);
    close(fd);
    exit(0);
  }

#ifdef BEAGLEBONE
  // Read from AM335x Control Module MAC ID registers

  const uint32_t MAC_ID_REG = 0x44E10630;
  size_t pagesize = sysconf(_SC_PAGE_SIZE);
  off_t pagebase = (MAC_ID_REG / pagesize) * pagesize;
  off_t pageoffset = (MAC_ID_REG % pagebase)/4;

  int fd = open("/dev/mem", O_SYNC);

  if (fd < 0)
  {
    fprintf(stderr, "ERROR: open() failed, %s\n", strerror(errno));
    exit(1);
  }

  uint32_t *mem = mmap(NULL, pagesize, PROT_READ, MAP_PRIVATE, fd, pagebase);

  if (mem == MAP_FAILED)
  {
    fprintf(stderr, "ERROR: mmap() failed, %s\n", strerror(errno));
    exit(1);
  }

  printf("%08X%04X\n", ntohl(mem[pageoffset + 1]), ntohl(mem[pageoffset + 0]) >> 16);
  close(fd);
  exit(0);
#endif

#ifdef RASPBERRYPI
  // Read from /sys/firmware/devicetree/base/serial-number

  int fd = open("/sys/firmware/devicetree/base/serial-number", O_RDONLY);

  if (fd < 0)
  {
    fprintf(stderr, "ERROR: open() failed, %s\n", strerror(errno));
    exit(1);
  }

  char buf[256];
  memset(buf, 0, sizeof(buf));
  ssize_t len = read(fd, buf, sizeof(buf) - 1);

  if (len < 0)
  {
    fprintf(stderr, "ERROR: read() failed, %s\n", strerror(errno));
    exit(1);
  }

  deblank(buf);
  printf("%s\n", buf);
  close(fd);
  exit(0);
#endif

  // Otherwise, just fake something...

  puts("00000000");
  exit(0);
}
