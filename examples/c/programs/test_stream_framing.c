// Stream Framing Test

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

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libsimpleio/libstream.h>

int main(void)
{
  uint8_t msgbuf[256];
  uint8_t framebuf[256];
  int32_t count;
  int error;
  int i;

  // Encode an empty frame

  memset(framebuf, 0, sizeof(framebuf));

  STREAM_encode_frame(msgbuf, 0, framebuf, sizeof(framebuf), &count, &error);

  printf("Encoded frame:  ");
  for (i = 0; i< count; i++)
    printf(" %02X", framebuf[i]);
  putchar('\n');

  // Verify the checksum

  if ((framebuf[count-4] != 0x1D) || (framebuf[count-3] != 0x0F))
  {
    printf("ERROR: checksum is incorrect!");
  }

  // Decode the frame

  memset(msgbuf, 0, sizeof(msgbuf));

  STREAM_decode_frame(framebuf, count, msgbuf, sizeof(msgbuf), &count, &error);

  printf("Decoded message:");
  for (i = 0; i< count; i++)
    printf(" %02X", msgbuf[i]);
  putchar('\n');

  // Encode "123456789"

  memset(framebuf, 0, sizeof(framebuf));

  STREAM_encode_frame("123456789", 9, framebuf, sizeof(framebuf), &count, &error);

  printf("Encoded frame:  ");
  for (i = 0; i< count; i++)
    printf(" %02X", framebuf[i]);
  putchar('\n');

  // Verify the checksum

  if ((framebuf[count-4] != 0xE5) || (framebuf[count-3] != 0xCC))
  {
    printf("ERROR: checksum is incorrect!");
  }

  // Decode the frame

  memset(msgbuf, 0, sizeof(msgbuf));

  STREAM_decode_frame(framebuf, count, msgbuf, sizeof(msgbuf), &count, &error);

  printf("Decoded message:");
  for (i = 0; i< count; i++)
    printf(" %02X", msgbuf[i]);
  putchar('\n');

  exit(0);
}
