// Stream Framing Test Receiver (server)

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
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>

#include <libsimpleio/libstream.h>
#include <libsimpleio/libipv4.h>

int main(void)
{
  int fd;
  uint8_t msgbuf[256];
  uint8_t framebuf[256];
  int32_t framesize = 0;
  int32_t msgsize;
  int error;
  int i;

  puts("Stream Framing Protocol Test Receiver\n");

  // Wait for connection from client

  puts("Waiting for client...");
  fflush(stdout);

  TCP4_accept(INADDR_LOOPBACK, 12345, &fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: TCP4_accept() failed, %s\n", strerror(error));
    exit(1);
  }

  puts("Client has connected...\n");
  fflush(stdout);

  // Main loop

  for (;;)
  {
    // Receive a frame

    STREAM_receive_frame(fd, framebuf, sizeof(framebuf), &framesize, &error);
    if (error == ECONNRESET) break;
    if (error == EPIPE) break;
    if (error == EAGAIN) continue;
    if (error)
    {
      fprintf(stderr, "ERROR: STREAM_receive_frame() failed, %s\n", strerror(error));
      exit(1);
    }

    // Decode the frame

    STREAM_decode_frame(framebuf, framesize, msgbuf, sizeof(msgbuf), &msgsize, &error);
    if (error)
    {
      fprintf(stderr, "ERROR: STREAM_decode_frame() failed, %s\n", strerror(error));
      framesize = 0;
      continue;
    }

    // Display results

    if (msgsize == 0)
    {
      puts("Received: <empty frame>");
      framesize = 0;
      continue;
    }

    printf("Received:");
    for (i = 0; i < msgsize; i++)
      printf(" %02X", msgbuf[i]);
    putchar('\n');

    // Exit if commanded by client

    if (!(memcmp(msgbuf, "quit", 4)))
      break;

    framesize = 0;
  }

  // Close the TCP connection

  TCP4_close(fd, &error);
  if (error)
  {
    fprintf(stderr, "ERROR: TCP4_close() failed, %s\n", strerror(error));
    exit(1);
  }

  exit(0);
}
