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

#include <ctype.h>
#include <errno.h>
#include <netdb.h>
#include <regex.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <sys/param.h>

#include <libsimpleio/libgpio.h>
#include <libsimpleio/liblinux.h>

#include <mongoose.h>
#include <platform.h>

#define PROGRAMNAME	"GPIO Server HTTP"
#define SERVICENAME	"gpio-http"
#define MAX_URI_LENGTH	25
#define REGEX_URI_TEMPLATE "^/GPIO/((get/[0-9]+)|((put|ddr)/[0-9]+,[0-1]))$"
#define DELIMITERS	"/\r\n"
#define WWWPROLOGUE	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n"

static regex_t uri_template;

// Signal handler for SIGTERM

static volatile sig_atomic_t exitflag = 0;

static void SIGTERMhandler(int sig)
{
  exitflag = 1;
  signal(sig, SIGTERMhandler);
}

static int request_handler(struct mg_connection *conn)
{
  char URIbuf[MAX_URI_LENGTH+1];
  char *sys;
  char *cmd;
  char *parms;

  mg_printf(conn, WWWPROLOGUE);

  // Validate the method

  if (strcasecmp(conn->request_method, "GET"))
  {
    mg_printf(conn, "ERROR: Invalid method\r\n");
    mg_printf(conn, "errno=%d\r\n", EINVAL);
    return MG_TRUE;
  }

  // Validate the URI

  if (strlen(conn->uri) > MAX_URI_LENGTH)
  {
    mg_printf(conn, "ERROR: Invalid URI\r\n");
    mg_printf(conn, "errno=%d\r\n", EINVAL);
    return MG_TRUE;
  }

  if (regexec(&uri_template, conn->uri, 0, NULL, 0))
  {
    mg_printf(conn, "ERROR: Invalid URI\r\n");
    mg_printf(conn, "errno=%d\r\n", EINVAL);
    return MG_TRUE;
  }

  // Parse the URI

  memset(URIbuf, 0, sizeof(URIbuf));
  strncpy(URIbuf, conn->uri, MAX_URI_LENGTH);

  sys = strtok(URIbuf+1, DELIMITERS);
  cmd = strtok(NULL, DELIMITERS);
  parms = strtok(NULL, DELIMITERS);

  // Process the URI

  if (!strcasecmp(sys, "GPIO"))
  {
    if (!strcasecmp(cmd, "get"))
    {
      int pin = atoi(parms);
      int fd;
      int error;
      int state;

      if (!GPIO_Platform_Pin_Valid(pin))
      {
        mg_printf(conn, "ERROR: Invalid GPIO pin number\r\n");
        mg_printf(conn, "errno=%d\r\n", EINVAL);
        return MG_TRUE;
      }

      GPIO_open(pin, &fd, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_open() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      GPIO_read(fd, &state, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_read() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      GPIO_close(fd, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_close() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      mg_printf(conn, "GPIO%d=%d\r\n", pin, state);
      return MG_TRUE;
    }
    else if (!strcasecmp(cmd, "put"))
    {
      int pin = atoi(strtok(parms, ",\r\n"));
      int fd;
      int error;
      int state = atoi(strtok(NULL, ",\r\n"));

      if (!GPIO_Platform_Pin_Valid(pin))
      {
        mg_printf(conn, "ERROR: Invalid GPIO pin number\r\n");
        mg_printf(conn, "errno=%d\r\n", EINVAL);
        return MG_TRUE;
      }

      GPIO_open(pin, &fd, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_open() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      GPIO_write(fd, state, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_write() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      GPIO_close(fd, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_close() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      mg_printf(conn, "GPIO%d=%d\r\n", pin, state);
      return MG_TRUE;
    }
    else if (!strcasecmp(cmd, "ddr"))
    {
      int pin = atoi(strtok(parms, ",\r\n"));
      int direction = atoi(strtok(NULL, ",\r\n"));
      int error;

      // Validate the GPIO pin number

      if (!GPIO_Platform_Pin_Valid(pin))
      {
        mg_printf(conn, "ERROR: Invalid GPIO pin number\r\n");
        mg_printf(conn, "errno=%d\r\n", EINVAL);
        return MG_TRUE;
      }

      // Set GPIO data direction

      GPIO_configure(pin, direction, 0, GPIO_EDGE_NONE,
        GPIO_POLARITY_ACTIVEHIGH, &error);
      if (error)
      {
        mg_printf(conn, "ERROR: GPIO_configure() failed\r\n");
        mg_printf(conn, "errno=%d\r\n", error);
        return MG_TRUE;
      }

      mg_printf(conn, "DDR%d=%d\r\n", pin, direction);
      return MG_TRUE;
    }
    else
    {
      mg_printf(conn, "ERROR: Invalid command\r\n");
      mg_printf(conn, "errno=%d\r\n", EINVAL);
      return MG_TRUE;
    }
  }
  else
  {
    mg_printf(conn, "ERROR: Invalid subsystem\r\n");
    mg_printf(conn, "errno=%d\r\n", EINVAL);
    return MG_TRUE;
  }
}

// Mongoose event handler

static int event_handler(struct mg_connection *conn, enum mg_event ev)
{
  static volatile bool DoneFlag = false;

  switch (ev)
  {
    case MG_AUTH :
      return MG_TRUE;	// Authorize all requests

    case MG_REQUEST :
      if (request_handler(conn))
      {
        DoneFlag = true;
        return MG_TRUE;
      }
      else
      {
        DoneFlag = false;
        return MG_FALSE;
      }

    case MG_POLL :
      if (DoneFlag)
      {
        DoneFlag = false;
        return MG_TRUE;
      }
      else
        return MG_FALSE;

    default :
      return MG_FALSE;
  }
}

int main(void)
{
  struct servent *service;
  int error;
  char portstr[8];

  openlog(PROGRAMNAME, LOG_NDELAY|LOG_PID, LOG_DAEMON);

  // Look up service definition

  service = getservbyname(SERVICENAME, "tcp");
  if (service == NULL)
  {
    syslog(LOG_ERR, "ERROR: getservbyname() failed, unknown service");
    exit(1);
  }

  // Detect the hardware platform

  GPIO_Platform_Init();

  // Become nobody

  LINUX_drop_privileges("gpio", &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: LINUX_drop_privileges() failed, %s", strerror(errno));
    exit(1);
  }

  // Install signal handler for SIGTERM

  if (signal(SIGTERM, SIGTERMhandler) == SIG_ERR)
  {
    syslog(LOG_ERR, "ERROR: signal() for SIGTERM failed, %s\n", strerror(errno));
    exit(1);
  }

  // Compile the URI validation regular expression template

  if (regcomp(&uri_template, REGEX_URI_TEMPLATE, REG_EXTENDED|REG_ICASE))
  {
    syslog(LOG_ERR, "ERROR: regcomp() failed");
    exit(1);
  }

  // Switch to background

  if (daemon(0, 0))
  {
    syslog(LOG_ERR, "ERROR: daemon() failed, %s\n", strerror(errno));
    exit(1);
  }

  // Create mongoose web server

  memset(portstr, 0, sizeof(portstr));
  snprintf(portstr, sizeof(portstr), "%d", ntohs(service->s_port));

  struct mg_server *server = mg_create_server(NULL, event_handler);
  mg_set_option(server, "document_root", ".");
  mg_set_option(server, "listening_port", portstr);

  // Proceess incoming requests

  while (!exitflag)
  {
    mg_poll_server(server, 1000);
  }

  // Graceful exit

  syslog(LOG_INFO, "Terminating.");

  // Destroy mongoose web server

  mg_destroy_server(&server);

  exit(0);
}
