/******************************************************************************/
/*                                                                            */
/* This program calculates TCP network throughput.  This is the transmitter.  */
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

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "tcp.h"

#define BUFSIZE		1024
#define ITERATIONS	atoi(argv[2])*1024

int main(int argc, char *argv[])
{
  int s;
  char buf[BUFSIZE];
  int i;
  time_t t0, t1;

  if (argc != 3)
  {
    puts("Usage: blaster <hostname> <megabytes>");
    exit(1);
  }

  s = tcp_call(resolve(argv[1]), 1234);
  if (s < 0)
  {
    printf("ERROR: tcp_call() failed, %s\n", strerror(errno));
    exit(1);
  }

  t0 = time(NULL);

  for (i = 0; i < ITERATIONS; i++)
    write(s, buf, sizeof(buf));

  t1 = time(NULL);

  printf("\nBytes:        %d\n", BUFSIZE*ITERATIONS);
  printf("Elapsed time: %ld sec\n", t1 - t0);
  printf("Throughput:   %1.1f Mbps\n", 8.0*BUFSIZE*ITERATIONS/(t1-t0)/1000000);
  exit(0);
}
