WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO.libsimpleio;
WITH RaspberryPi;

PROCEDURE blinky IS

  LED : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("MuntsOS Ada LED Test");
  New_Line;

  -- Configure a GPIO output to drive an LED

  LED := GPIO.libsimpleio.Create(RaspberryPi.GPIO26, GPIO.Output);

  -- Flash the LED forever (until killed)

  Put_Line("Press CONTROL-C to exit");
  New_Line;

  LOOP
    LED.Put(NOT LED.Get);
    DELAY 0.5;
  END LOOP;
END blinky;
