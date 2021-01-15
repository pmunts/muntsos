-- Toggle a GPIO output

-- Copyright (C)2017-2020, Philip Munts, President, Munts AM Corp.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

WITH Ada.Text_IO; USE Ada.Text_IO;
WITH Ada.Integer_Text_IO; USE Ada.Integer_Text_IO;
WITH Ada.Strings.Unbounded;

WITH ClickBoard.SimpleIO;
WITH ClickBoard.Expand2.SimpleIO;
WITH Device;
WITH GPIO.libsimpleio;
WITH GPIO.RemoteIO;
WITH HID.libsimpleio;
WITH HID.Munts;
WITH I2C.libsimpleio;
WITH I2C.RemoteIO;
WITH MCP2221.GPIO;
WITH MCP2221.I2C;
WITH MCP2221.libsimpleio;
WITH MCP23017.GPIO;
WITH Message64;
WITH Message64.UDP;
WITH PCA8574.GPIO;
WITH PCA9534.GPIO;
WITH RemoteIO.Client;

USE ALL TYPE Ada.Strings.Unbounded.Unbounded_String;

PROCEDURE test_gpio_toggle IS

  -- GPIO pin constructors

  FUNCTION Create_MCP2221(number : Integer) RETURN GPIO.Pin IS

    dev : MCP2221.Device := MCP2221.libsimpleio.Create;

  BEGIN
    RETURN MCP2221.GPIO.Create(dev, MCP2221.PinNumber(number), GPIO.Output);
  END Create_MCP2221;

  FUNCTION Create_remoteio_HID(number : Integer) RETURN GPIO.Pin IS

    remdev : RemoteIO.Client.Device :=
      RemoteIO.Client.Create(HID.libsimpleio.Create(HID.Munts.VID,
      HID.Munts.PID));

  BEGIN
    RETURN GPIO.RemoteIO.Create(remdev, number, GPIO.Output);
  END Create_remoteio_HID;

  FUNCTION Create_remoteio_UDP(number : Integer) RETURN GPIO.Pin IS

    remdev    : RemoteIO.Client.Device;
    messenger : Message64.Messenger;

  BEGIN
    Put("Enter server name:     ");
    Skip_Line;
    messenger := Message64.UDP.Create(Get_Line, 8087);
    New_Line;
    remdev := RemoteIO.Client.Create(messenger);
    RETURN GPIO.RemoteIO.Create(remdev, number, GPIO.Output);
  END Create_remoteio_UDP;

  FUNCTION Create_MCP23017_Expand2Click(number : Integer) RETURN GPIO.Pin IS

    device : MCP23017.Device := ClickBoard.Expand2.SimpleIO.Create(1);

  BEGIN
    RETURN MCP23017.GPIO.Create(device, MCP23017.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_MCP23017_Expand2Click;

  FUNCTION Create_MCP23017_MCP2221(number : Integer) RETURN GPIO.Pin IS

    bus    : I2C.Bus := MCP2221.I2C.Create(MCP2221.libsimpleio.Create);
    device : MCP23017.Device := MCP23017.Create(bus, 16#20#);

  BEGIN
    RETURN MCP23017.GPIO.Create(device, MCP23017.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_MCP23017_MCP2221;

  FUNCTION Create_MCP23017_Remote(number : Integer) RETURN GPIO.Pin IS

    remdev : RemoteIO.Client.Device :=
      RemoteIO.Client.Create(HID.libsimpleio.Create(HID.Munts.VID,
      HID.Munts.PID));
    bus    : I2C.Bus := I2C.RemoteIO.Create(remdev, 0, I2C.SpeedFast);
    device : MCP23017.Device := MCP23017.Create(bus, 16#20#);

  BEGIN
    RETURN MCP23017.GPIO.Create(device, MCP23017.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_MCP23017_Remote;

  FUNCTION Create_PCA8574_Local(number : Integer) RETURN GPIO.Pin IS

    bus    : I2C.Bus := I2C.libsimpleio.Create("/dev/i2c-1");
    device : PCA8574.Device := PCA8574.Create(bus, 16#38#);

  BEGIN
    RETURN PCA8574.GPIO.Create(device, PCA8574.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_PCA8574_Local;

  FUNCTION Create_PCA8574_MCP2221(number : Integer) RETURN GPIO.Pin IS

    bus    : I2C.Bus := MCP2221.I2C.Create(MCP2221.libsimpleio.Create);
    device : PCA8574.Device := PCA8574.Create(bus, 16#38#);

  BEGIN
    RETURN PCA8574.GPIO.Create(device, PCA8574.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_PCA8574_MCP2221;

  FUNCTION Create_PCA8574_Remote(number : Integer) RETURN GPIO.Pin IS

    remdev : RemoteIO.Client.Device :=
      RemoteIO.Client.Create(HID.libsimpleio.Create(HID.Munts.VID,
      HID.Munts.PID));
    bus    : I2C.Bus := I2C.RemoteIO.Create(remdev, 0);
    device : PCA8574.Device := PCA8574.Create(bus, 16#38#);

  BEGIN
    RETURN PCA8574.GPIO.Create(device, PCA8574.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_PCA8574_Remote;

  FUNCTION Create_PCA9534_Local(number : Integer) RETURN GPIO.Pin IS

    bus    : I2C.Bus := I2C.libsimpleio.Create("/dev/i2c-1");
    device : PCA9534.Device := PCA9534.Create(bus, 16#27#);

  BEGIN
    RETURN PCA9534.GPIO.Create(device, PCA9534.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_PCA9534_Local;

  FUNCTION Create_PCA9534_MCP2221(number : Integer) RETURN GPIO.Pin IS

    bus    : I2C.Bus := MCP2221.I2C.Create(MCP2221.libsimpleio.Create);
    device : PCA9534.Device := PCA9534.Create(bus, 16#27#);

  BEGIN
    RETURN PCA9534.GPIO.Create(device, PCA9534.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_PCA9534_MCP2221;

  FUNCTION Create_PCA9534_Remote(number : Integer) RETURN GPIO.Pin IS

    remdev : RemoteIO.Client.Device :=
      RemoteIO.Client.Create(HID.libsimpleio.Create(HID.Munts.VID,
      HID.Munts.PID));
    bus    : I2C.Bus := I2C.RemoteIO.Create(remdev, 0, I2C.SpeedFast);
    device : PCA9534.Device := PCA9534.Create(bus, 16#27#);

  BEGIN
    RETURN PCA9534.GPIO.Create(device, PCA9534.GPIO.PinNumber(number),
      GPIO.Output);
  END Create_PCA9534_Remote;

  -- Constructor table definitions

  TYPE ConstructorAccess IS ACCESS FUNCTION (number : Integer) RETURN GPIO.Pin;

  TYPE ConstructorEntry IS RECORD
    constructor : ConstructorAccess;
    description : Ada.Strings.Unbounded.Unbounded_String;
  END RECORD;

  Constructors : CONSTANT ARRAY (Positive RANGE <>) OF ConstructorEntry :=
    ((NULL,
      To_Unbounded_String("libsimpleio")),

     (Create_MCP2221'Access,
      To_Unbounded_String("MCP2221")),

     (Create_remoteio_HID'Access,
      To_Unbounded_String("Remote I/O HID")),

     (Create_remoteio_UDP'Access,
      To_Unbounded_String("Remote I/O UDP")),

     (Create_MCP23017_Expand2Click'Access,
      To_Unbounded_String("MCP23017 (Expand2 Click in socket 1)")),

     (Create_MCP23017_MCP2221'Access,
      To_Unbounded_String("MCP23017 (via MCP2221)")),

     (Create_MCP23017_Remote'Access,
      To_Unbounded_String("MCP23017 (via Remote I/O)")),

     (Create_PCA8574_Local'Access,
      To_Unbounded_String("PCA8574")),

     (Create_PCA8574_MCP2221'Access,
      To_Unbounded_String("PCA8574  (via MCP2221)")),

     (Create_PCA8574_Remote'Access,
      To_Unbounded_String("PCA8574  (via Remote I/O)")),

     (Create_PCA9534_Local'Access,
      To_Unbounded_String("PCA9534")),

     (Create_PCA9534_MCP2221'Access,
      To_Unbounded_String("PCA9534  (via MCP2221)")),

     (Create_PCA9534_Remote'Access,
      To_Unbounded_String("PCA9534  (via Remote I/O)")));

  kind   : Natural;
  desg   : Device.Designator;
  number : Natural;
  GPIO0  : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("GPIO Toggle Test");
  New_Line;

  -- Select the kind of GPIO pin

  LOOP
    Put_Line("Select one of the following kinds of GPIO pins to toggle:");
    New_Line;

    FOR i IN Constructors'Range LOOP
      Put(i, 2);
      Put(" --- ");
      Put(To_String(Constructors(i).description));
      New_Line;
    END LOOP;

    New_Line;
    Put("Enter kind: ");
    Get(kind);
    New_Line;

    IF kind = 0 THEN
      RETURN;
    END IF;

    EXIT WHEN kind <= Constructors'Last;
  END LOOP;

  -- Create a GPIO pin object

  IF kind = 1 THEN
    Put("Enter GPIO chip number: ");
    Get(desg.chip);

    Put("Enter GPIO line number: ");
    Get(desg.chan);
    New_Line;

    GPIO0 := GPIO.libsimpleio.Create(desg, GPIO.Output);
  ELSE
    Put("Enter GPIO pin number: ");
    Get(number);
    New_Line;

    GPIO0 := Constructors(kind).constructor(number);
  END IF;

  -- Toggle the GPIO output

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    GPIO0.Put(NOT GPIO0.Get);
  END LOOP;
END test_gpio_toggle;
