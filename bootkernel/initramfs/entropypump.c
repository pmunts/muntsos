// Pump some entropy from /dev/hwrng to /dev/urandom.

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

// This program is required because getrandom() blocks until /dev/urandom has
// gotten enough entropy.  The OpenSSH server sshd calls getrandom() at
// startup, and delays system startup for over two minutes if /dev/urandom
// hasn't gotten enough entropy yet.  It is the opinion of the author that
// it is insane for getrandom() to block indefinitely like this...

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <linux/random.h>
#include <sys/ioctl.h>

#define BUFBYTES	65536
#define BUFWORDS	(BUFBYTES/4)
#define BUFBITS		(BUFBYTES*8)

void main(void)
{
  // Open /dev/hwrng

  int hfd = open("/dev/hwrng", O_RDONLY);

  if (hfd < 0)
  {
    fprintf(stderr, "ERROR: open() for /dev/hwrng failed, %s\n", strerror(errno));
    exit(1);
  }

  // Open /dev/urandom

  int ufd = open("/dev/urandom", O_RDWR);

  if (ufd < 0)
  {
    fprintf(stderr, "ERROR: open() for /dev/urandom failed, %s\n", strerror(errno));
    exit(1);
  }

  // Allocate an ioctl operation buffer

  struct rand_pool_info *buf = malloc(sizeof(struct rand_pool_info) + BUFBYTES);

  if (buf == NULL)
  {
    fprintf(stderr, "ERROR: malloc() failed, %s\n", strerror(errno));
    exit(1);
  }

  buf->entropy_count = BUFBITS;
  buf->buf_size = BUFBYTES;

  // Read from /dev/hwrng

  ssize_t len = read(hfd, buf->buf, BUFBYTES);

  if (len < 0)
  {
    fprintf(stderr, "ERROR: read() from /dev/hwrng failed, %s\n", strerror(errno));
    exit(1);
  }

  // Write to /dev/urandom

  if (ioctl(ufd, RNDADDENTROPY, buf) < 0)
  {
    fprintf(stderr, "ERROR: ioctl() failed, %s\n", strerror(errno));
    exit(1);
  }

  close(hfd);
  close(ufd);
  exit(0);
}
