using System;

namespace blinky
{
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("\nMuntsOS C# LED Test\n");

      // Configure a GPIO output to drive an LED

      IO.Objects.libsimpleio.Device.Designator desg_LED =
        new IO.Objects.libsimpleio.Device.Designator(0, 26);

      IO.Interfaces.GPIO.Pin LED =
        new IO.Objects.libsimpleio.GPIO.Pin(desg_LED,
          IO.Interfaces.GPIO.Direction.Output);

      // Flash the LED forever (until killed)

      Console.WriteLine("Press CONTROL-C to exit.\n");

      for (;;)
      {
        LED.state = !LED.state;
        System.Threading.Thread.Sleep(500);
      }
    }
  }
}
