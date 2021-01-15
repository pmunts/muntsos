PROGRAM blinky(input, output);

USES
  SysUtils,
  GPIO,
  GPIO_libsimpleio,
  RaspberryPi;

VAR
  LED : GPIO.Pin;

BEGIN
  Writeln;
  Writeln('MuntsOS Free Pascal LED Test');
  Writeln;

  { Configure a GPIO output to drive an LED }

  LED := GPIO_libsimpleio.PinSubclass.Create(GPIO26, Output, False);

  { Flash the LED forever (until killed) }

  Writeln('Press CONTROL-C to exit.');
  Writeln;

  REPEAT
    LED.state := NOT LED.state;
    sleep(500);
  UNTIL False;
END.
