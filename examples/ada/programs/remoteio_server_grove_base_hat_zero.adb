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
WITH Ada.Strings.Fixed;

WITH GPIO.UserLED;
WITH RemoteIO.ADC;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.Grove_Base_Hat_Zero;
WITH RemoteIO.I2C;
WITH RemoteIO.PWM;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;
WITH SystemInfo;

-- Board dependent packages

WITH Grove_Base_Hat_Zero;

PROCEDURE remoteio_server_grove_base_hat_zero IS

  title  : CONSTANT String := "MuntsOS Remote I/O Server for Grove Base Hat Zero";
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
    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);
  END IF;

  -- Analog inputs

  FOR i IN Grove_Base_Hat_Zero.Sample_Inputs'Range LOOP
    adc.Register(i, Grove_Base_Hat_Zero.Sample_Inputs(i));
  END LOOP;

  -- GPIO pins

  gpio.Register(Grove_Base_Hat_Zero.D5,  Grove_Base_Hat_Zero.D5);
  gpio.Register(Grove_Base_Hat_Zero.D6,  Grove_Base_Hat_Zero.D6);
  gpio.Register(Grove_Base_Hat_Zero.D16, Grove_Base_Hat_Zero.D16);
  gpio.Register(Grove_Base_Hat_Zero.D17, Grove_Base_Hat_Zero.D17);

  -- Extra GPIO pins on the SWD header -- These conflict with SPI0!
  -- You must disable SPI0 in /boot/config.txt:
  --
  -- dtparam=spi=off

  IF NOT Ada.Directories.Exists("/dev/spidev0.0") AND
     NOT Ada.Directories.Exists("/dev/spidev0.1") THEN
    gpio.Register(Grove_Base_Hat_Zero.D9,  Grove_Base_Hat_Zero.D9);
    gpio.Register(Grove_Base_Hat_Zero.D10, Grove_Base_Hat_Zero.D10);
    gpio.Register(Grove_Base_Hat_Zero.D11, Grove_Base_Hat_Zero.D11);
  END IF;

  -- I2C buses

  i2c.Register(Grove_Base_Hat_Zero.I2C1, Grove_Base_Hat_Zero.Bus);

  -- PWM Outputs -- These conflict with D12 and D13!

  -- One of the following device tree overlays must be enabled in
  -- /boot/config.txt:
  --
  -- dtoverlay=pwm,pin=12,func=4
  -- OR
  -- dtoverlay=pwm,pin=13,func=4
  -- OR
  -- dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4

  IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0") THEN
    -- Export BCM2835 PWM outputs
    system("echo 0 >/sys/class/pwm/pwmchip0/export" & ASCII.NUL);
    system("echo 1 >/sys/class/pwm/pwmchip0/export" & ASCII.NUL);

    DELAY 1.0;

    -- Register BCM2835 PWM outputs

    IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm0") THEN
      pwm.Register(Grove_Base_Hat_Zero.PWM12, Grove_Base_Hat_Zero.PWM12);
    END IF;

    IF Ada.Directories.Exists("/sys/class/pwm/pwmchip0/pwm1") THEN
      pwm.Register(Grove_Base_Hat_Zero.PWM13, Grove_Base_Hat_Zero.PWM13);
    END IF;
  ELSE
    -- Register D12 and D13 as GPIO pins instead
    gpio.Register(Grove_Base_Hat_Zero.D12, Grove_Base_Hat_Zero.D12);
    gpio.Register(Grove_Base_Hat_Zero.D13, Grove_Base_Hat_Zero.D13);
  END IF;

END remoteio_server_grove_base_hat_zero;
