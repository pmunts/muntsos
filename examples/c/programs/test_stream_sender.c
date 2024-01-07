// Stream Framing Test Sender (client)

// Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>

#include <libsimpleio/libstream.h>
#include <libsimpleio/libipv4.h>

int main(void)
{
  int error;
  int fd;
  char msgbuf[256];
  uint8_t framebuf[256];
  int32_t count;

  puts("Stream Framing Protocol Test Sender\n");

  // Open connection to the server

  puts("Connectiong to server...");
  fflush(stdout);

  TCP4_connect(INADDR_LOOPBACK, 12345, &fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: TCP4_connect() failed, %s\n", strerror(error));
    exit(1);
  }

  puts("Connected to server...\n");
  fflush(stdout);

  // Main loop

  for (;;)
  {
    // Get a message from the operator

    memset(msgbuf, 0, sizeof(msgbuf));
    fgets(msgbuf, sizeof(msgbuf), stdin);

    // Remove trailing whitespace

    while ((strlen(msgbuf) > 0) && isspace(msgbuf[strlen(msgbuf)-1]))
      msgbuf[strlen(msgbuf)-1] = 0;

    // Encode message to frame

    STREAM_encode_frame(msgbuf, strlen(msgbuf), framebuf, sizeof(framebuf), &count, &error);
    if (error)
    {
      fprintf(stderr, "ERROR: STREAM_encode_frame() failed, %s\n", strerror(errno));
      break;
    }

    // Send the frame to the server

    STREAM_send_frame(fd, framebuf, count, &count, &error);
    if (error)
    {
      fprintf(stderr, "ERROR: STREAM_send_frame() failed, %s\n", strerror(errno));
      break;
    }

    if (!strcasecmp(msgbuf, "quit"))
      break;
  }

  TCP4_close(fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: TCP4_close() failed, %s\n", strerror(errno));
    exit(1);
  }

  exit(0);
}
