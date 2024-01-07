// LabView LINX Remote I/O Protocol Server Main Module

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

#include <errno.h>
#include <netdb.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>

#include <libsimpleio/liblinux.h>
#include <libsimpleio/libipv4.h>

#include <linx-server/common.h>
#include <linx-server/gpio-libsimpleio-sysfs.h>

#include <platform.h>

// Device identification constants

extern const uint8_t LINX_DEVICE_FAMILY	= 255;
extern const uint8_t LINX_DEVICE_ID	= 2;
extern const char LINX_DEVICE_NAME[]	= BOARDNAME " MuntsOS GPIO Server";

// More constants

#define PROGRAMNAME	"GPIO Server LINX"
#define SERVICENAME	"gpio-linx"

int main(void)
{
  struct servent *service;
  int32_t error;
  int fd;

  openlog(PROGRAMNAME, LOG_NDELAY|LOG_PID, LOG_DAEMON);

  // Look up service definition

  service = getservbyname(SERVICENAME, "tcp");
  if (service == nullptr)
  {
    syslog(LOG_ERR, "ERROR: getservbyname() failed, unknown service");
    exit(1);
  }

  // Register common LINX remote I/O command handlers

  common_init();

  // Register GPIO pins, initially configured as inputs

  gpio_init();

  // Add detected platform GPIO pins

  GPIO_Platform_Init();

  for (unsigned pin = 0; pin < MAX_PLATFORM_PINS; pin++)
    if (GPIO_Platform_Pin_Valid(pin))
      gpio_add_channel(pin,  new GPIO_libsimpleio_sysfs(pin));

  // Become a nobody

  LINUX_drop_privileges("gpio", &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: LINUX_drop_privileges() failed, %s", strerror(error));
    exit(1);
  }

  // Detach from controlling terminal

  LINUX_detach(&error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: LINUX_detach() failed, %s", strerror(error));
    exit(1);
  }

  // Start TCP server

  TCP4_server(INADDR_ANY, ntohs(service->s_port), &fd, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: TCP4_server() failed, %s", strerror(error));
    exit(1);
  }

  // Process commands

  executive(fd, &error);
}
