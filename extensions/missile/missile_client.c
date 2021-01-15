// ONC-RPC client for the Dream Cheeky USB missile launcher

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

#include "missile.h"

#define MISSILE_SERVER		argv[1]
#define MISSILE_OPERATION	argv[2]
#define MISSILE_TRANSPORT	"udp"

static void ShowUsage(void)
{
  fprintf(stderr, "Usage: missile_client <server> "
    "<nop|up|down|cw|ccw|fire|stop>\n");
  exit(1);
}

int main(int argc, char **argv)
{
  unsigned int cmd;
  CLIENT *clnt;
  int *result;

// Validate number of command line arguments

  if (argc != 3) ShowUsage();

// Decode command

  if (!strcasecmp(MISSILE_OPERATION, "nop"))
    cmd = CMD_NOP;
  else if (!strcasecmp(MISSILE_OPERATION, "down"))
    cmd = CMD_DOWN;
  else if (!strcasecmp(MISSILE_OPERATION, "up"))
    cmd = CMD_UP;
  else if (!strcasecmp(MISSILE_OPERATION, "cw"))
    cmd = CMD_CW;
  else if (!strcasecmp(MISSILE_OPERATION, "ccw"))
    cmd = CMD_CCW;
  else if (!strcasecmp(MISSILE_OPERATION, "fire"))
    cmd = CMD_FIRE;
  else if (!strcasecmp(MISSILE_OPERATION, "stop"))
    cmd = CMD_STOP;
  else
    ShowUsage();

// Create client handle

   clnt = clnt_create(MISSILE_SERVER, MISSILE, MISSILE_VERS, MISSILE_TRANSPORT);
   if (clnt == NULL)
   {
     clnt_pcreateerror("ERROR: clnt_create() failed");
     exit(1);
   }

// Issue RPC call

  result = missile_command_1(cmd, clnt);
  if (result == NULL)
  {
    clnt_perror(clnt, "ERROR: missle_command() failed");
    exit(1);
  }

  if (*result)
  {
    fprintf(stderr, "ERROR: missile_command() failed, result=%d\n", *result);
    exit(1);
  }

  exit(0);
}
