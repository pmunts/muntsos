import com.munts.interfaces.GPIO.*;
import com.munts.libsimpleio.objects.GPIO.*;
import com.munts.libsimpleio.platforms.RaspberryPi;

public class blinky
{
  public static void main(String args[])
    throws InterruptedException
  {
    System.out.println("\nMuntsOS Java LED Test\n");

    // Configure a GPIO output to drive an LED

    Builder b = new Builder(RaspberryPi.GPIO26);
    b.SetDirection(Direction.Output);
    Pin LED = b.Create();

    // Flash the LED forever (until killed)

    System.out.println("Press CONTROL-C to exit.\n");

    for (;;)
    {
      LED.write(!LED.read());
      Thread.sleep(500);
    }
  }
}
