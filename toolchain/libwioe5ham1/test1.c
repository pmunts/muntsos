#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "libwioe5ham1.h"

static void msleep(unsigned milliseconds)
{
  usleep(milliseconds*1000);
}

int main(void)
{
  int handle;
  uint8_t msg[243];
  int len;
  int src;
  int dst;
  int rss;
  int snr;
  int error;

  wioe5ham1_init("/dev/ttyAMA0", 115200, 915.0, 7, 500, 12, 15, 22, "XXXXXXXX", 1, &handle, &error);

  if (error)
  {
    fprintf(stderr, "ERROR: wioe5ham1_init() failed, %s\n", strerror(error));
    exit(1);
  }

  wioe5ham1_send(handle, "This is a test.", 15, 2, &error);

  if (error)
  {
    fprintf(stderr, "ERROR: wioe5ham1_send_string() failed, %s\n", strerror(error));
    exit(1);
  }

  msleep(300);

  wioe5ham1_receive(handle, msg, &len, &src, &dst, &rss, &snr, &error);

  if (error)
  {
    fprintf(stderr, "ERROR: wioe5ham1_receive() failed, %s\n", strerror(error));
    exit(1);
  }

  if (len > 0)
  {
    printf("Received %d bytes => \"%s\", From node %d to node %d, %d dBm %d dB\n", len, msg, src, dst, rss, snr);
  }
}
