/* Force umount utility for an embedded Linux system    */
/* Busybox umount -f hangs so we use this program instead. */

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

#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <syslog.h>
#include <sys/mount.h>

#define PROGNAME	argv[0]
#define MOUNTPOINT	argv[1]

int main(int argc, char *argv[])
{
  openlog("force-umount", LOG_NDELAY|LOG_PID, LOG_LOCAL0);

  if (argc != 2)
  {
    syslog(LOG_ERR, "Usage: %s<mountpoint>", PROGNAME);
    exit(1);
  }

  if (umount2(MOUNTPOINT, MNT_FORCE))
  {
    syslog(LOG_ERR, "ERROR: umount2() for %s failed, %s", MOUNTPOINT, strerror(errno));
    exit(1);
  }

  syslog(LOG_INFO, "%s was unmounted successfully", MOUNTPOINT);
  exit(0);
}
