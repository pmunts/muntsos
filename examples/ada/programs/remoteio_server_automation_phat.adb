-- MuntsOS Remote I/O Server for Raspberry Pi & Pimoroni Automation pHAT

-- Copyright (C)2018-2021, Philip Munts, President, Munts AM Corp.
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

WITH Analog;
WITH GPIO.UserLED;
WITH Pimoroni_Automation_pHAT;
WITH RemoteIO.ADC;
WITH RemoteIO.Automation_pHAT;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.SPI;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;

PROCEDURE remoteio_server_Automation_pHAT IS

  title  : CONSTANT String := "MuntsOS Remote I/O Server for Automation pHAT";
  caps   : CONSTANT String := "ADC GPIO SPI";
  exec   : RemoteIO.Executive.Executor;
  srvh   : RemoteIO.Server.Instance;
  srvs   : RemoteIO.Server.Instance;
  srvu   : RemoteIO.Server.Instance;
  adc    : RemoteIO.ADC.Dispatcher;
  gpio   : RemoteIO.GPIO.Dispatcher;
  spi    : RemoteIO.SPI.Dispatcher;

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
  spi  := RemoteIO.SPI.Create(exec);

  -- Register user LED on GPIO channel 0, if possible

  IF Standard.GPIO.UserLED.Available THEN
    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);
  END IF;

  -- Register I/O resources

  adc.Register(RemoteIO.Automation_pHAT.ADC1,
    Analog.Input(Pimoroni_Automation_pHAT.Sample_Inputs(1)));

  adc.Register(RemoteIO.Automation_pHAT.ADC2,
    Analog.Input(Pimoroni_Automation_pHAT.Sample_Inputs(2)));

  adc.Register(RemoteIO.Automation_pHAT.ADC3,
    Analog.Input(Pimoroni_Automation_pHAT.Sample_Inputs(3)));

  gpio.Register(RemoteIO.Automation_pHAT.INPUT1,
    Pimoroni_Automation_pHAT.INPUT1,  RemoteIO.GPIO.InputOnly);

  gpio.Register(RemoteIO.Automation_pHAT.INPUT2,
    Pimoroni_Automation_pHAT.INPUT2,  RemoteIO.GPIO.InputOnly);

  gpio.Register(RemoteIO.Automation_pHAT.INPUT3,
    Pimoroni_Automation_pHAT.INPUT3,  RemoteIO.GPIO.InputOnly);

  gpio.Register(RemoteIO.Automation_pHAT.OUTPUT1,
    Pimoroni_Automation_pHAT.OUTPUT1, RemoteIO.GPIO.OutputOnly);

  gpio.Register(RemoteIO.Automation_pHAT.OUTPUT2,
    Pimoroni_Automation_pHAT.OUTPUT2, RemoteIO.GPIO.OutputOnly);

  gpio.Register(RemoteIO.Automation_pHAT.OUTPUT3,
    Pimoroni_Automation_pHAT.OUTPUT3, RemoteIO.GPIO.OutputOnly);

  gpio.Register(RemoteIO.Automation_pHAT.RELAY1,
    Pimoroni_Automation_pHAT.RELAY1, RemoteIO.GPIO.OutputOnly);

  spi.Register(RemoteIO.Automation_pHAT.SPI0, Pimoroni_Automation_pHAT.SPI0);
END remoteio_server_Automation_pHAT;

