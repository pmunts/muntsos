// Minimal mDNS server for MuntsOS

// Copyright (C)2015-2018, Philip Munts, President, Munts AM Corp.
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
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <arpa/inet.h>

#include "mdns.h"
#include "mdnsd.h"

#define PROGNAME	argv[0]
#define NETIF		argv[1]
#define HOSTNAME	argv[2]
#define IPADDR		argv[3]

extern int pthread_yield(void);

static char *ExtractSingleHostName(char *s)
{
  static char buf[256];
  char *d = buf;

  memset(buf, 0, sizeof(buf));

  while (*s && isspace(*s))
    s++;

  while (*s && !isspace(*s))
    *d++ = *s++;

  if (buf[0] == 0)
    return NULL;

  return strtok(buf, ".");
}

int main(int argc, char *argv[])
{
  if (argc != 4)
  {
    fprintf(stderr, "\nUsage: %s <netif> <hostname> <ipaddress>\n", PROGNAME);
    exit(1);
  }

  // Switch program to background process

  daemon(0, 0);

  openlog("mdnsd", LOG_NDELAY|LOG_PID, LOG_LOCAL0);

  // Kickoff the MDNS server background threads

  struct mdnsd *server = mdnsd_start(inet_addr(IPADDR));
  if (server == NULL)
  {
    syslog(LOG_ERR, "ERROR: mdnsd_start() failed");
    exit(1);
  }

  // Save PID

  char pidfilename[256];
  memset(pidfilename, 0, sizeof(pidfilename));
  snprintf(pidfilename, sizeof(pidfilename), "/var/run/mdnsd.%s.pid", NETIF);

  FILE *pidfile = fopen(pidfilename, "w");
  if (pidfile == NULL)
  {
    syslog(LOG_ERR, "ERROR: fopen() for %s failed, %s", pidfilename, strerror(errno));
    exit(1);
  }

  fprintf(pidfile, "%d\n", getpid());
  fclose(pidfile);

  // Post our host name and IP address

  char hn[256];
  memset(hn, 0, sizeof(hn));
  snprintf(hn, sizeof(hn), "%s.local",  HOSTNAME);

  syslog(LOG_INFO, "Registering %s as %s\n", hn, IPADDR);

  mdnsd_set_hostname(server, hn, inet_addr(IPADDR));

  // Read the initial host name from /etc/hostname, and if present and different,
  // register it, too, in case the DHCP server assigned a new hostname.

  if (!access("/etc/hostname", R_OK))
  {
    FILE *hnfile = fopen("/etc/hostname", "r");
    char buf[256];
    char *p;

    memset(buf, 0, sizeof(buf));
    fgets(buf, sizeof(buf), hnfile);
    fclose(hnfile);

    p = ExtractSingleHostName(buf);

    if (p && strcmp(p, HOSTNAME))
    {
      memset(hn, 0, sizeof(hn));
      snprintf(hn, sizeof(hn), "%s.local", p);

      syslog(LOG_INFO, "Registering %s as %s", hn, IPADDR);

      mdnsd_set_hostname(server, hn, inet_addr(IPADDR));
    }
  }

  // All the real work is done in background threads

  for (;;) sleep(1000);
}
