// MuntsOS GPIO Thin Server Toggle Speed Test

// Copyright (C)2013-2018, Philip Munts, President, Munts AM Corp.
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
#include <string.h>
#include <time.h>
#include <unistd.h>

#include "gpio_server_oncrpc.h"

#define SERVERNAME	argv[1]
#define LED		atoi(argv[2])
#define ITERATIONS	atoi(argv[3])

static void ShowUsage(void)
{
  fprintf(stderr, "Usage: Toggle_Speed <servername> <pin number> <iterations>\n");
  exit(1);
}

int main(int argc, char *argv[])
{
  CLIENT *clnt;
  int result;
  struct timeval start, stop;
  int i;
  double deltat, rate, cycletime;

  puts("\nMuntsOS GPIO Thin Server Toggle Speed Test\n");

  if (argc != 4) ShowUsage();

  // Create ONC/RPC client handle

  clnt = clnt_create(SERVERNAME, GPIO_SERVER_ONCRPC, GPIO_SERVER_ONCRPC_VERS, "udp");
  if (clnt == NULL)
  {
    clnt_pcreateerror("ERROR: clnt_create() failed");
    exit(1);
  }

  // Configure GPIO pins

  result = *gpio_open_1(LED, GPIO_DIRECTION_OUTPUT, 0, clnt);
  if (result < 0)
  {
    fprintf(stderr, "ERROR: %s\n", strerror(-result));
    exit(1);
  }

  // Perform GPIO toggle speed test

  printf("Performing %d GPIO writes...\n\n", ITERATIONS);

  gettimeofday(&start, NULL);

  for (i = 0; i < ITERATIONS/2; i++)
  {
    result = *gpio_write_1(LED, 0, clnt);
    if (result < 0)
    {
      fprintf(stderr, "ERROR: %s\n", strerror(-result));
      exit(1);
    }

    result = *gpio_write_1(LED, 1, clnt);
    if (result < 0)
    {
      fprintf(stderr, "ERROR: %s\n", strerror(-result));
      exit(1);
    }
  }

  gettimeofday(&stop, NULL);

  // Display results

  deltat = (stop.tv_sec*1E6 + stop.tv_usec - start.tv_sec*1E6 - start.tv_usec)/1E6;
  rate = ITERATIONS/deltat;
  cycletime = deltat/ITERATIONS;

  printf("Performed %d GPIO writes in %1.1f seconds\n", ITERATIONS, deltat);
  printf("  %1.1f iterations per second\n", rate);
  printf("  %1.1f microseconds per iteration\n", cycletime*1E6);
  exit(0);
}
