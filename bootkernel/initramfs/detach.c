// Background process spawner utility

// Copyright (C)2024, Philip Munts dba Munts Technologies.
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void main(int argc, char *argv[])
{
  int i;
  char *newargs[argc + 1];

  // Validate parameters

  if (argc < 2)
  {
    fprintf(stderr, "\nUsage: %s <program> [<arguments>]\n\n", argv[0]);
    exit(1);
  }

  // Build new argument list

  memset(newargs, 0, sizeof(newargs));

  for (i = 1; i < argc; i++)
    newargs[i-1] = argv[i];

  // Switch to background execution

  if (daemon(0, 0))
  {
    fprintf(stderr, "ERROR: daemon() failed, %s\n", strerror(errno));
    exit(1);
  }

  // exec the specified program

  execvp(newargs[0], newargs);
  fprintf(stderr, "ERROR: execvp() failed, %s\n", strerror(errno));
  exit(1);
}
