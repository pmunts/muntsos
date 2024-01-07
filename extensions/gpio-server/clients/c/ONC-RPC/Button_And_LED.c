// MuntsOS GPIO Thin Server Button and LED Test

// Copyright (C)2013-2024, Philip Munts dba Munts Technologies.
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
#define BUTTON		19
#define LED		26

static void ShowUsage(void)
{
  fprintf(stderr, "Usage: Button_And_LED <servername>\n");
  exit(1);
}

int main(int argc, char *argv[])
{
  CLIENT *clnt;
  int result;
  int ButtonOld;
  int ButtonNew;

  puts("\nMuntsOS GPIO Thin Server Button and LED Test\n");

  if (argc != 2) ShowUsage();

  // Create ONC/RPC client handle

  clnt = clnt_create(SERVERNAME, GPIO_SERVER_ONCRPC, GPIO_SERVER_ONCRPC_VERS, "udp");
  if (clnt == NULL)
  {
    clnt_pcreateerror("ERROR: clnt_create() failed");
    exit(1);
  }

  // Configure GPIO pins

  result = *gpio_open_1(BUTTON, GPIO_DIRECTION_INPUT, 0, clnt);
  if (result < 0)
  {
    fprintf(stderr, "ERROR: %s\n", strerror(-result));
    exit(1);
  }

  result = *gpio_open_1(LED, GPIO_DIRECTION_OUTPUT, 0, clnt);
  if (result < 0)
  {
    fprintf(stderr, "ERROR: %s\n", strerror(-result));
    exit(1);
  }

  // Force initial state change

  ButtonOld = *gpio_read_1(BUTTON, clnt);
  if (ButtonOld < 0)
  {
    fprintf(stderr, "ERROR: %s\n", strerror(-ButtonOld));
    exit(1);
  }

  ButtonOld = !ButtonOld;

  // Sense button and update LED

  for (;;)
  {
    ButtonNew = *gpio_read_1(BUTTON, clnt);
    if (ButtonNew < 0)
    {
      fprintf(stderr, "ERROR: %s\n", strerror(-ButtonNew));
      exit(1);
    }

    if (ButtonNew != ButtonOld)
    {
      puts(ButtonNew ? "PRESSED" : "RELEASED");

      result = *gpio_write_1(LED, ButtonNew, clnt);
      if (result < 0)
      {
        fprintf(stderr, "ERROR: %s\n", strerror(-result));
        exit(1);
      }

      ButtonOld = ButtonNew;
    }

    usleep(100000);
  }
}
