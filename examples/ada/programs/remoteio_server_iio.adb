-- MuntsOS Remote I/O Server for Linux IIO ADC and DAC

-- Copyright (C)2018-2024, Philip Munts dba Munts Technologies.
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

WITH Ada.Directories;
WITH Ada.Strings.Fixed;

WITH Device;
WITH GPIO.UserLED;
WITH RemoteIO.ADC;
WITH RemoteIO.DAC;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;
WITH RemoteIO.Server.ZeroMQ;

PROCEDURE remoteio_server_iio IS

  -- Trim leading and trailing whitespace from a string

  FUNCTION Trim
   (Source : IN String;
    Side   : IN Ada.Strings.Trim_End := Ada.Strings.Both) RETURN String RENAMES
   Ada.Strings.Fixed.Trim;

  -- Test whether a particular IIO device exists

  FUNCTION Exists(chip : Natural) RETURN Boolean IS

  BEGIN
    RETURN Ada.Directories.Exists("/sys/bus/iio/devices/iio:device" &
      Trim(Natural'Image(chip)));
  END Exists;

  -- Test whether a particular IIO channel exists

  FUNCTION Exists
   (desg : Device.Designator;
    kind : String) RETURN Boolean IS

  BEGIN
    RETURN Ada.Directories.Exists("/sys/bus/iio/devices/iio:device" &
      Trim(Natural'Image(desg.chip)) & "/" & kind & Trim(Natural'Image(desg.chan)) &
      "_raw");
  END Exists;

  title  : CONSTANT String :=
    "MuntsOS Remote I/O Server for Linux IIO ADC and DAC";
  caps   : CONSTANT String := "ADC DAC GPIO";
  exec   : RemoteIO.Executive.Executor;
  srvh   : RemoteIO.Server.Instance;
  srvs   : RemoteIO.Server.Instance;
  srvu   : RemoteIO.Server.Instance;
  srvz   : RemoteIO.Server.Instance;
  adc    : RemoteIO.ADC.Dispatcher;
  dac    : RemoteIO.DAC.Dispatcher;
  gpio   : RemoteIO.GPIO.Dispatcher;
  numadc : Natural := 0;
  numdac : Natural := 0;

BEGIN
  RemoteIO.Server.Foundation.Initialize(title, caps);
  exec := RemoteIO.Server.Foundation.Executor;

  -- Initialize server subsystem tasks

  srvh := RemoteIO.Server.Dev.Create(exec, "Raw HID", "/dev/hidg0");
  srvs := RemoteIO.Server.Serial.Create(exec, "Serial Port", "/dev/ttyGS0");
  srvu := RemoteIO.Server.UDP.Create(exec, "UDP");
  srvz := RemoteIO.Server.ZeroMQ.Create(exec, "ZeroMQ");

  -- Create I/O subsystem objects

  adc  := RemoteIO.ADC.Create(exec);
  dac  := RemoteIO.DAC.Create(exec);
  gpio := RemoteIO.GPIO.Create(exec);

  -- Register user LED on GPIO channel 0, if possible

  IF Standard.GPIO.UserLED.Available THEN
    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);
  END IF;

  -- Register I/O resources

  FOR chip IN Natural RANGE 0 .. 9 LOOP
    FOR channel IN Natural RANGE 0 .. 63 LOOP
      IF Exists((chip, channel), "in_voltage") THEN
        adc.Register(numadc, (chip, channel));
        numadc := numadc + 1;
      END IF;

      IF Exists((chip, channel), "out_voltage") THEN
        dac.Register(numdac, (chip, channel));
        numdac := numdac + 1;
      END IF;
    END LOOP;
  END LOOP;
END remoteio_server_iio;
