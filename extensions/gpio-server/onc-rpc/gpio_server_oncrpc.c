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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>

#include <libsimpleio/liblinux.h>

#include <platform.h>

#include "gpio_server_oncrpc.h"

#define PROGRAMNAME	"GPIO Server ONC/RPC"
#define RESPONSEDELAY	0

#define MAX_GPIO_PINS	2048

extern void GPIO_configure(int32_t pin, int32_t direction, int32_t state, int32_t edge, int32_t polarity, int32_t *error);
extern void GPIO_open(int32_t pin, int32_t *fd, int32_t *error);
extern void GPIO_read(int32_t fd, int32_t *state, int32_t *error);
extern void GPIO_write(int32_t fd, int32_t state, int32_t *error);
extern void LINUX_close(int32_t fd, int32_t *error);

static int fdtable[MAX_GPIO_PINS];

void gpio_server_oncrpc_initialize(void)
{
  int error;

  openlog(PROGRAMNAME, LOG_NDELAY|LOG_PID, LOG_DAEMON);

  GPIO_Platform_Init();

// Drop superuser privileges

  LINUX_drop_privileges("gpio", &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: LINUX_drop_privileges() failed, %s", strerror(error));
    exit(1);
  }

// Switch to background execution

  if (daemon(0, 0))
  {
    syslog(LOG_ERR, "ERROR: daemon() failed, %s", strerror(errno));
    exit(1);
  }

// Initialize the file descriptor table

  memset(fdtable, 0, sizeof(fdtable));
}

// Open GPIO pin file handle

bool_t gpio_open_1_svc(int pin, int direction, int state, int *result, struct svc_req *req)
{
  int error;

  // Validate the GPIO pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_open_1_svc(): Pin %d is invalid", pin);
    *result = -EINVAL;
    return 1;
  }

  // Configure the GPIO pin

  GPIO_configure(pin, direction, (direction ? state : 0), 0, 1, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_open_1_svc(): GPIO_configure() for pin %d failed, %s", pin, strerror(error));
    *result = -error;
    return 1;
  }

  // See if the GPIO pin has already been opened

  if (fdtable[pin])
  {
    *result = 0;
    return 1;
  }

  // Open GPIO pin file handle

  GPIO_open(pin, &fdtable[pin], &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_open_1_svc(): GPIO_open() for pin %d failed, %s\n", pin, strerror(error));
    *result = -error;
    fdtable[pin] = 0;
    return 1;
  }

  *result = 0;
  return 1;
}

// Close GPIO pin file handle

bool_t gpio_close_1_svc(int pin, int *result, struct svc_req *req)
{
  int error;

  // Validate the GPIO pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS))
  {
    syslog(LOG_ERR, "ERROR: gpio_close_1_svc(): Pin %d is invalid", pin);
    *result = -EINVAL;
    return 1;
  }

  // See if the GPIO pin has been opened

  if (!fdtable[pin])
  {
    syslog(LOG_ERR, "ERROR: gpio_close_1_svc(): Pin %d has not been opened", pin);
    *result = -EBADF;
    return 1;
  }

  LINUX_close(fdtable[pin], &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_close_1_svc(): GPIO_close for pin %d failed, %s\n", pin, strerror(error));
    *result = -error;
    return 1;
  }

  fdtable[pin] = 0;
  *result = 0;
  return 1;
}

// Read GPIO pin

bool_t gpio_read_1_svc(int pin, int *result, struct svc_req *req)
{
  int error;
  int state;

  // Validate the GPIO pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_read_1_svc(): Pin %d is invalid", pin);
    *result = -EINVAL;
    return 1;
  }

  // See if the GPIO pin has been opened

  if (!fdtable[pin])
  {
    syslog(LOG_ERR, "ERROR: gpio_read_1_svc(): Pin %d has not been opened", pin);
    *result = -EBADF;
    return 1;
  }

  GPIO_read(fdtable[pin], &state, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_read_1_svc(): GPIO_read for pin %d failed, %s\n", pin, strerror(error));
    *result = -error;
    return 1;
  }

  *result = state;
  return 1;
}

// Write GPIO pin

bool_t gpio_write_1_svc(int pin, int state, int *result, struct svc_req *req)
{
  int error;

  // Validate the GPIO pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_write_1_svc(): Pin %d is invalid", pin);
    *result = -EINVAL;
    return 1;
  }

  // See if the GPIO pin has been opened

  if (!fdtable[pin])
  {
    syslog(LOG_ERR, "ERROR: gpio_write_1_svc(): Pin %d has not been opened", pin);
    *result = -EBADF;
    return 1;
  }

  GPIO_write(fdtable[pin], state, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_write_1_svc(): GPIO_write for pin %d failed, %s\n", pin, strerror(error));
    *result = -error;
    return 1;
  }

  *result = 0;
  return 1;
}

// Free the response structure

int gpio_server_oncrpc_1_freeresult(SVCXPRT *transp, xdrproc_t xdr_result,
  caddr_t result)
{
  xdr_free(xdr_result, result);
  return 1;
}
