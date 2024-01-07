/******************************************************************************/
/*                                                                            */
/*   This program calculates TCP network throughput.  This is the receiver.   */
/*                                                                            */
/******************************************************************************/

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
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "tcp.h"

int main(void)
{
  int s;
  struct pollfd events;
  int status;
  unsigned char buf[1024];
  int len;
  unsigned long int totalbytes = 0;
  time_t t0, t1;

  puts("\nTCP Blast Receiver ready\n");
  fflush(stdout);

  s = tcp_answer(1234);

  if (s < 0)
  {
    fprintf(stderr, "ERROR: tcp_answer() failed, %s\n", strerror(errno));
    exit(1);
  }

  puts("Client connected.");
  fflush(stdout);

  t0 = time(NULL);

  for (;;)
  {
    memset(&events, 0, sizeof(events));
    events.fd = s;
    events.events = POLLIN;

    status = poll(&events, 1, 5000);

    if (status == 0)
    {
      fprintf(stderr, "ERROR: poll() timed out.\n");
      break;
    }

    if (status < 0)
    {
      fprintf(stderr, "ERROR: poll() failed, %s\n", strerror(errno));
      break;
    }

    if (events.revents & POLLERR)
    {
      fprintf(stderr, "ERROR: POLLERR set, %s\n", strerror(errno));
      break;
    }

    if (events.revents & POLLIN)
    {
      len = read(s, buf, sizeof(buf));
      if (len <= 0) break;

      totalbytes += len;
    }
  }

  t1 = time(NULL);

  printf("Bytes:        %ld bytes\n", totalbytes);
  printf("Elapsed time: %ld sec\n", t1 - t0);
  printf("Throughput:   %1.1f Mbps\n", 8.0*totalbytes/(t1 - t0)/1000000);
  puts("*******************************");
  fflush(stdout);
  exit(0);
}
