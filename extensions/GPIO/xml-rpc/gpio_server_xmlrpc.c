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

#include <errno.h>
#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>
#include <sys/param.h>
#include <xmlrpc.h>
#include <xmlrpc-c/server.h>
#include <xmlrpc-c/server_abyss.h>
#include <xmlrpc-c/util.h>

#include <libsimpleio/libgpio.h>
#include <libsimpleio/liblinux.h>

#include <platform.h>

#define PROGRAMNAME	"GPIO Server XML-RPC"
#define SERVICENAME	"gpio-xmlrpc"

#define MAX_GPIO_PINS	2048

static int fdtable[MAX_GPIO_PINS];

static xmlrpc_value *gpio_open(xmlrpc_env * const env,
  xmlrpc_value * const parameters, void * const serverinfo)
{
  int pin, direction, state, error;

  // Unpack parameters

  xmlrpc_decompose_value(env, parameters, "(iii)", &pin, &direction, &state);
  if (env->fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: gpio_open(): xmlrpc_decompose_value() failed");
    return NULL;
  }

  // Validate pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_open(): Invalid pin number");
    return xmlrpc_build_value(env, "i", -EINVAL);
  }

  // Configure the GPIO pin

  GPIO_configure(pin, direction, (direction ? state : 0), GPIO_EDGE_NONE,
    GPIO_POLARITY_ACTIVEHIGH, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_open(): GPIO_configure() failed, %s", strerror(error));
    return xmlrpc_build_value(env, "i", -error);
  }

  // Open the GPIO pin device

  // See if pin is already open

  if (fdtable[pin])
  {
    return xmlrpc_build_value(env, "i", 0);
  }

  GPIO_open(pin, &fdtable[pin], &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_open(): GPIO_open() failed, %s", strerror(errno));
    return xmlrpc_build_value(env, "i", -error);
  }

  return xmlrpc_build_value(env, "i", 0);
}

static xmlrpc_value *gpio_close(xmlrpc_env * const env,
  xmlrpc_value * const parameters, void * const serverinfo)
{
  int pin, error;

  // Unpack parameters

  xmlrpc_decompose_value(env, parameters, "(i)", &pin);
  if (env->fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: gpio_close(): xmlrpc_decompose_value() failed");
    return NULL;
  }

  // Validate pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_close(): Invalid pin number");
    return xmlrpc_build_value(env, "i", -EINVAL);
  }

  // See if pin is open

  if (!fdtable[pin])
  {
    syslog(LOG_ERR, "ERROR: gpio_close(): Pin is not open");
    return xmlrpc_build_value(env, "i", -EBADF);
  }

  // Close the GPIO pin device

  GPIO_close(fdtable[pin], &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_close(): GPIO_close() failed, %s", strerror(error));
    return xmlrpc_build_value(env, "i", -error);
  }

  fdtable[pin] = 0;
  return xmlrpc_build_value(env, "i", 0);
}

static xmlrpc_value *gpio_read(xmlrpc_env * const env,
  xmlrpc_value * const parameters, void * const serverinfo)
{
  int pin, state, error;

  // Unpack parameters

  xmlrpc_decompose_value(env, parameters, "(i)", &pin);
  if (env->fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: gpio_read(): xmlrpc_decompose_value() failed");
    return NULL;
  }

  // Validate pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_read(): Invalid pin number");
    return xmlrpc_build_value(env, "i", -EINVAL);
  }

  // See if pin is open

  if (!fdtable[pin])
  {
    syslog(LOG_ERR, "ERROR: gpio_read(): Pin is not open");
    return xmlrpc_build_value(env, "i", -EBADF);
  }

  // Read the GPIO pin state

  GPIO_read(fdtable[pin], &state, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_read(): GPIO_read() failed, %s", strerror(errno));
    return xmlrpc_build_value(env, "i", -error);
  }

  return xmlrpc_build_value(env, "i", state);
}

static xmlrpc_value *gpio_write(xmlrpc_env * const env,
  xmlrpc_value * const parameters, void * const serverinfo)
{
  int pin, state, error;

  // Unpack parameters

  xmlrpc_decompose_value(env, parameters, "(ii)", &pin, &state);
  if (env->fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: gpio_write(): xmlrpc_decompose_value() failed");
    return NULL;
  }

  // Validate pin number

  if ((pin < 0) || (pin >= MAX_GPIO_PINS) || !GPIO_Platform_Pin_Valid(pin))
  {
    syslog(LOG_ERR, "ERROR: gpio_write(): Invalid pin number");
    return xmlrpc_build_value(env, "i", -EINVAL);
  }

  // See if pin is open

  if (!fdtable[pin])
  {
    syslog(LOG_ERR, "ERROR: gpio_write(): Pin is not open");
    return xmlrpc_build_value(env, "i", -EBADF);
  }

  // Write the GPIO pin state

  GPIO_write(fdtable[pin], state, &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: gpio_write(): GPIO_write() failed, %s", strerror(errno));
    return xmlrpc_build_value(env, "i", -error);
  }

  return xmlrpc_build_value(env, "i", 0);
}

int main(void)
{
  struct servent *service;
  int error;
  xmlrpc_server_abyss_parms serverparms;
  xmlrpc_registry *registryP;
  xmlrpc_env env;

  openlog(PROGRAMNAME, LOG_NDELAY|LOG_PID, LOG_DAEMON);

  GPIO_Platform_Init();

  // Look up service definition

  service = getservbyname(SERVICENAME, "tcp");
  if (service == NULL)
  {
    syslog(LOG_ERR, "ERROR: getservbyname() failed, unknown service");
    exit(1);
  }

  memset(fdtable, 0, sizeof(fdtable));

  // Become nobody

  LINUX_drop_privileges("gpio", &error);
  if (error)
  {
    syslog(LOG_ERR, "ERROR: LINUX_drop_privileges() failed, %s", strerror(errno));
    exit(1);
  }

  // Switch to background

  if (daemon(0, 0))
  {
    syslog(LOG_ERR, "ERROR: daemon() failed, %s\n", strerror(errno));
    exit(1);
  }

// Initialize the XML-RPC library internal data structures

  xmlrpc_env_init(&env);

// Register the XML-RPC methods

  registryP = xmlrpc_registry_new(&env);
  if (env.fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: xmlrpc_registry_new() failed, error=%d (%s)", env.fault_code, env.fault_string);
    exit(1);
  }

  xmlrpc_registry_add_method_w_doc(&env, registryP, NULL, "gpio.open", gpio_open, NULL, "i:iii", "Configure GPIO pin");
  if (env.fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: xmlrpc_add_method_w_doc() failed, error=%d (%s)", env.fault_code, env.fault_string);
    exit(1);
  }

  xmlrpc_registry_add_method_w_doc(&env, registryP, NULL, "gpio.close", gpio_close, NULL, "i:i", "Close GPIO pin");
  if (env.fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: xmlrpc_add_method_w_doc() failed, error=%d (%s)", env.fault_code, env.fault_string);
    exit(1);
  }

  xmlrpc_registry_add_method_w_doc(&env, registryP, NULL, "gpio.read", gpio_read, NULL, "i:i", "Read GPIO pin");
  if (env.fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: xmlrpc_add_method_w_doc() failed, error=%d (%s)", env.fault_code, env.fault_string);
    exit(1);
  }

  xmlrpc_registry_add_method_w_doc(&env, registryP, NULL, "gpio.write", gpio_write, NULL, "i:ii", "Write GPIO pin");
  if (env.fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: xmlrpc_add_method_w_doc() failed, error=%d (%s)", env.fault_code, env.fault_string);
    exit(1);
  }

// Configure the server

  serverparms.config_file_name = NULL;
  serverparms.registryP = registryP;
  serverparms.port_number = ntohs(service->s_port);

// Start the server

  xmlrpc_server_abyss(&env, &serverparms, XMLRPC_APSIZE(port_number));
  if (env.fault_occurred)
  {
    syslog(LOG_ERR, "ERROR: xmlrpc_server_abyss() failed, error=%d (%s)", env.fault_code, env.fault_string);
    exit(1);
  }

  exit(0);
}
