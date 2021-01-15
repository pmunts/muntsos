#include <cstdio>
#include <unistd.h>

#include <raspberrypi.h>

int main(void)
{
  puts("\nMuntsOS C++ LED Test\n");

  // Configure a GPIO output to drive an LED

  Interfaces::GPIO::Pin LED =
    new libsimpleio::GPIO::Pin_Class(RaspberryPi::GPIO26,
      Interfaces::GPIO::OUTPUT, false);

  // Flash the LED forever (until killed)

  puts("Press CONTROL-C to exit.\n");

  for (;;)
  {
    *LED = ! *LED;
    usleep(500000); // microseconds = 0.5 seconds
  }
}
