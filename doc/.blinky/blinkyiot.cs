using System.Device.Gpio;

using static System.Console;
using static System.Threading.Thread;

WriteLine("\nSystem.Device.Gpio LED Test\n");

var dev = new GpioController();

const int LED = 26;

dev.OpenPin(LED, PinMode.Output);

for (;;)
{
    dev.Write(LED, true);
    Thread.Sleep(500);
    dev.Write(LED, false);
    Thread.Sleep(500);
}
