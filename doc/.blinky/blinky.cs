using static System.Console;

WriteLine("\nMuntsOS C# LED Test\n");

// Configure a GPIO output to drive an LED

IO.Objects.SimpleIO.Device.Designator desg_LED =
  new IO.Objects.SimpleIO.Device.Designator(0, 26);

IO.Interfaces.GPIO.Pin LED =
  new IO.Objects.SimpleIO.GPIO.Pin(desg_LED,
    IO.Interfaces.GPIO.Direction.Output);

// Flash the LED forever (until killed)

WriteLine("Press CONTROL-C to exit.\n");

for (;;)
{
  LED.state = !LED.state;
  System.Threading.Thread.Sleep(500);
}
