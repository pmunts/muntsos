// ONC-RPC server for the Dream Cheeky USB missile launcher

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
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>

#include <libusb-1.0/libusb.h>

#include "missile.h"

#define PROGRAM			"missile_server"

static libusb_context		*ctx;
static libusb_device_handle	*dev;

void missile_initialize(void)
{
  int status;

// Switch to background execution

  if (daemon(0, 0))
  {
    syslog(LOG_ERR, "ERROR: daemon() failed, %s\n", strerror(errno));
    exit(1);
  }

// Initialize syslog

  openlog(PROGRAM, LOG_NDELAY|LOG_PID, LOG_LOCAL0);

// Initialize libusb

  status = libusb_init(&ctx);
  if (status)
  {
    syslog(LOG_ERR, "ERROR: libusb_init() failed, %s\n",
      libusb_error_name(status));
    exit(1);
  }

// Open the missile launcher device

  dev = libusb_open_device_with_vid_pid(ctx, 0x2123, 0x1010);
  if (dev == NULL)
  {
    syslog(LOG_ERR, "ERROR: No matching USB missile launcher found\n");
    exit(1);
  }

// Detach the kernel HID driver, if necessary

  status = libusb_kernel_driver_active(dev, 0);
  switch (status)
  {
    case 0:
      // No kernel driver attached
      break;

    case 1:
      // Kernel driver is attached
      status = libusb_detach_kernel_driver(dev, 0);
      if (status)
      {
        syslog(LOG_ERR, "ERROR: libusb_kernel_driver_active() failed, %s\n",
          libusb_error_name(status));
        exit(1);
      }

      break;

    default:
      syslog(LOG_ERR, "ERROR: libusb_kernel_driver_active() failed, %s\n",
        libusb_error_name(status));
      exit(1);
  }

// Claim the missile launcher interface

  status = libusb_claim_interface(dev, 0);
  if (status)
  {
    syslog(LOG_ERR, "ERROR: libusb_claim_interface() failed, %s\n",
      libusb_error_name(status));
    exit(1);
  }

  syslog(LOG_INFO, "Dream Cheeky USB missile launcher ONC-RPC server ready");
}

 // RPC service function to perform a missile launcher operation

int *missile_command_1_svc(unsigned command, struct svc_req *req)
{
  uint8_t cmdbuf[] = { 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
  static int status;

  switch (command)
  {
    case CMD_NOP:
      status = 0;
      break;

    case CMD_UP:
    case CMD_DOWN:
    case CMD_CCW:
    case CMD_CW:
    case CMD_STOP:
    case CMD_FIRE:
      cmdbuf[1] = command;

      status = libusb_control_transfer(dev, 0x21, 0x09, 0x00, 0x00,
        cmdbuf, 14, 1000);
      if (status == 14)
        status = 0;
      else if (status < 0)
      {
        syslog(LOG_ERR, "1ERROR: libusb_control_transfer() failed, %s\n",
          libusb_error_name(status));
        break;
      }
      break;

    default:
      status = -EINVAL;
  }

  return &status;
}
