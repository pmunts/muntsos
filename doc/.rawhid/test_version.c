#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hidapi/hidapi.h>

int main(void)
{
  hid_device *handle;
  int len;
  uint8_t outbuf[65];
  uint8_t inbuf[65];

  // Initialize HID API library

  if (hid_init())
  {
    fprintf(stderr, "ERROR: hid_init() failed\n");
    exit(0);
  }

  // Open raw HID device

  handle = hid_open(0x16D0, 0x0AFA, NULL);

  if (handle == NULL)
  {
    fprintf(stderr, "ERROR: hid_open() failed\n");
    exit(1);
  }

  // Send version string request

  memset(outbuf, 0, sizeof(outbuf));

  // Byte 0 is the Report ID so the actual request begins at byte 1

  outbuf[1] = 2;

  len = hid_write(handle, outbuf, sizeof(outbuf));

  if (len != sizeof(outbuf))
  {
    fprintf(stderr, "ERROR: hid_write() failed\n");
    exit(1);
  }

  // Receive version string response

  memset(inbuf, 0, sizeof(inbuf));

  len = hid_read_timeout(handle, inbuf, sizeof(inbuf), 1000);

  if (len == 64)       // No Report ID byte
    printf("\nRemote I/O Device Info: %s\n\n", inbuf+3);
  else if (len == 65)  // Skip Report ID byte
    printf("\nRemote I/O Device Info: %s\n\n", inbuf+4);
  else
  {
    fprintf(stderr, "ERROR: hid_read_timeout() failed\n\n");
    exit(1);
  }

  // Close the raw HID device

  hid_close(handle);
}
