// UDP Responder Test

// Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

#include <arpa/inet.h>
#include <netinet/in.h>

#include <libsimpleio/libipv4.h>

int main(int argc, char *argv[])
{
  int32_t fd;
  int32_t error;
  int32_t addr;
  int32_t port;
  int32_t count;
  char buf[256];
  char sender[256];

  printf("\nUDP Responder Test\n\n");
  fflush(stdout);

  UDP4_open(INADDR_LOOPBACK, 12345, &fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: UDP4_open() failed, %s\n", strerror(errno));
    exit(1);
  }

  for (;;)
  {
    UDP4_receive(fd, &addr, &port, buf, sizeof(buf), 0, &count, &error);
    if (error)
    {
      fprintf(stderr, "ERROR: UDP4_receive() failed, %s\n", strerror(errno));
      continue;
    }

    IPV4_ntoa(addr, sender, sizeof(sender), &error);
    if (error)
    {
      fprintf(stderr, "ERROR: IPV4_ntoa() failed, %s\n", strerror(errno));
      continue;
    }

    buf[count] = 0;
    printf("Received %d bytes from %s:%d -- %s\n", count, sender, port, buf);
    fflush(stdout);

    UDP4_send(fd, addr, port, "THERE", 5, 0, &count, &error);
    if (error)
    {
      fprintf(stderr, "ERROR: UDP4_send() failed, %s\n", strerror(errno));
      continue;
    }
  }

  UDP4_close(fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: UDP4_close() failed, %s\n", strerror(errno));
    exit(1);
  }
}
