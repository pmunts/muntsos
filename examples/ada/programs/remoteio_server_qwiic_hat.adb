-- MuntsOS Remote I/O Server for Raspberry Pi & Qwiic HAT

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

WITH GPIO.UserLED;
WITH Qwiic_HAT;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.I2C;
WITH RemoteIO.Qwiic_HAT;
WITH RemoteIO.SPI;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;
WITH RemoteIO.Server.ZeroMQ;

PROCEDURE remoteio_server_qwiic_hat IS

  title  : CONSTANT String := "MuntsOS Remote I/O Server for Qwiic HAT";
  caps   : CONSTANT String := "GPIO I2C SPI";
  exec   : RemoteIO.Executive.Executor;
  srvh   : RemoteIO.Server.Instance;
  srvs   : RemoteIO.Server.Instance;
  srvu   : RemoteIO.Server.Instance;
  srvz   : RemoteIO.Server.Instance;
  gpio   : RemoteIO.GPIO.Dispatcher;
  i2c    : RemoteIO.I2C.Dispatcher;
  spi    : RemoteIO.SPI.Dispatcher;

BEGIN
  RemoteIO.Server.Foundation.Initialize(title, caps);
  exec := RemoteIO.Server.Foundation.Executor;

  -- Initialize server subsystem tasks

  srvh := RemoteIO.Server.Dev.Create(exec, "Raw HID", "/dev/hidg0");
  srvs := RemoteIO.Server.Serial.Create(exec, "Serial Port", "/dev/ttyGS0");
  srvu := RemoteIO.Server.UDP.Create(exec, "UDP");
  srvz := RemoteIO.Server.ZeroMQ.Create(exec, "ZeroMQ");

  -- Create I/O subsystem objects

  gpio := RemoteIO.GPIO.Create(exec);
  i2c  := RemoteIO.I2C.Create(exec);
  spi  := RemoteIO.SPI.Create(exec);

  -- Register user LED on GPIO channel 0, if possible

  IF Standard.GPIO.UserLED.Available THEN
    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);
  END IF;

  -- Register I/O resources

  gpio.Register(RemoteIO.Qwiic_HAT.GPIO6,  Qwiic_HAT.D6);
  gpio.Register(RemoteIO.Qwiic_HAT.GPIO7,  Qwiic_HAT.D7);
  gpio.Register(RemoteIO.Qwiic_HAT.GPIO12, Qwiic_HAT.D12);
  gpio.Register(RemoteIO.Qwiic_HAT.GPIO16, Qwiic_HAT.D16);
  gpio.Register(RemoteIO.Qwiic_HAT.GPIO20, Qwiic_HAT.D20);
  gpio.Register(RemoteIO.Qwiic_HAT.GPIO21, Qwiic_HAT.D21);

  i2c.Register(RemoteIO.Qwiic_HAT.I2C1, Qwiic_HAT.I2C1);

  spi.Register(RemoteIO.Qwiic_HAT.SPI1, Qwiic_HAT.SPI1);

END remoteio_server_qwiic_hat;
