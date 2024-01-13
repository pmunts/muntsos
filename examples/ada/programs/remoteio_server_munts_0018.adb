-- MuntsOS Remote I/O Server

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
WITH Ada.Environment_Variables;

WITH GPIO.UserLED;
WITH MCP3204;
WITH MUNTS_0018;
WITH RemoteIO.ADC;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.I2C;
WITH RemoteIO.MUNTS_0018;
WITH RemoteIO.PWM;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;
WITH SystemInfo;
WITH libLinux;

-- Board dependent packages

WITH RaspberryPi;

PROCEDURE remoteio_server_munts_0018 IS

  title  : CONSTANT String := "MuntsOS Remote I/O Server for MUNTS-0018 Tutorial I/O Board";
  caps   : CONSTANT String := "ADC GPIO I2C PWM";
  exec   : RemoteIO.Executive.Executor;
  srvh   : RemoteIO.Server.Instance;
  srvs   : RemoteIO.Server.Instance;
  srvu   : RemoteIO.Server.Instance;
  adc    : RemoteIO.ADC.Dispatcher;
  gpio   : RemoteIO.GPIO.Dispatcher;
  i2c    : RemoteIO.I2C.Dispatcher;
  pwm    : RemoteIO.PWM.Dispatcher;

  PROCEDURE system(cmd : String);
    PRAGMA Import(C, system);

BEGIN
  RemoteIO.Server.Foundation.Initialize(title, caps);
  exec := RemoteIO.Server.Foundation.Executor;

  -- Initialize server subsystem tasks

  srvh := RemoteIO.Server.Dev.Create(exec, "Raw HID", "/dev/hidg0");
  srvs := RemoteIO.Server.Serial.Create(exec, "Serial Port", "/dev/ttyGS0");
  srvu := RemoteIO.Server.UDP.Create(exec, "UDP");

  -- Create I/O subsystem objects

  adc  := RemoteIO.ADC.Create(exec);
  gpio := RemoteIO.GPIO.Create(exec);
  i2c  := RemoteIO.I2C.Create(exec);
  pwm  := RemoteIO.PWM.Create(exec);

  -- Register user LED on GPIO channel 0, if possible

  IF Standard.GPIO.UserLED.Available THEN
    gpio.Register(RemoteIO.MUNTS_0018.LED, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);
  END IF;

  -- Register analog inputs

  adc.register(RemoteIO.MUNTS_0018.J10A0, MUNTS_0018.J10A0, MCP3204.Resolution);
  adc.register(RemoteIO.MUNTS_0018.J10A1, MUNTS_0018.J10A1, MCP3204.Resolution);
  adc.register(RemoteIO.MUNTS_0018.J11A0, MUNTS_0018.J11A0, MCP3204.Resolution);
  adc.register(RemoteIO.MUNTS_0018.J11A1, MUNTS_0018.J11A1, MCP3204.Resolution);

  -- Register GPIO pins

  gpio.Register(RemoteIO.MUNTS_0018.D1  , MUNTS_0018.D1, RemoteIO.GPIO.OutputOnly); -- LED
  gpio.Register(RemoteIO.MUNTS_0018.J4D0, MUNTS_0018.J4D0);
  gpio.Register(RemoteIO.MUNTS_0018.J4D1, MUNTS_0018.J4D1);
  gpio.Register(RemoteIO.MUNTS_0018.J5D0, MUNTS_0018.J5D0);
  gpio.Register(RemoteIO.MUNTS_0018.J5D1, MUNTS_0018.J5D1);
  gpio.Register(RemoteIO.MUNTS_0018.J6D0, MUNTS_0018.J6D0);
  gpio.Register(RemoteIO.MUNTS_0018.J6D1, MUNTS_0018.J6D1);
  gpio.Register(RemoteIO.MUNTS_0018.SW1,  MUNTS_0018.SW1, RemoteIO.GPIO.InputOnly); -- Button

  -- Register I2C buses

  i2c.Register(RemoteIO.MUNTS_0018.J9I2C, MUNTS_0018.J9I2C);

  -- Register PWM outputs

  IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
    -- Export BCM2835 PWM outputs
    system("echo 0 >/sys/class/pwm/pwmchip0/export" & ASCII.NUL);
    system("echo 1 >/sys/class/pwm/pwmchip0/export" & ASCII.NUL);
    DELAY 1.0;

    pwm.Register(RemoteIO.MUNTS_0018.J6PWM, MUNTS_0018.J6PWM);
    pwm.Register(RemoteIO.MUNTS_0018.J7PWM, MUNTS_0018.J7PWM);
  ELSE
    gpio.Register(RemoteIO.MUNTS_0018.J6D0, MUNTS_0018.J6D0);
    gpio.Register(RemoteIO.MUNTS_0018.J7D0, MUNTS_0018.J7D0);
  END IF;

END remoteio_server_munts_0018;
