-- MuntsOS Remote I/O Server for Raspberry Pi Zero &
-- AB Electronics ADC DAC Pi Zero

-- https://www.abelectronics.co.uk/p/74/adc-dac-pi-zero-raspberry-pi-adc-and-dac-expansion-board

-- Copyright (C)2018-2019, Philip Munts, President, Munts AM Corp.
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

WITH ABElectronics_ADC_DAC_Pi_Zero;
WITH GPIO.UserLED;
WITH MCP3202;
WITH MCP4822;
WITH RemoteIO.ADC;
WITH RemoteIO.ADC_DAC_Pi_Zero;
WITH RemoteIO.DAC;
WITH RemoteIO.Executive;
WITH RemoteIO.GPIO;
WITH RemoteIO.Server.Dev;
WITH RemoteIO.Server.Foundation;
WITH RemoteIO.Server.Serial;
WITH RemoteIO.Server.UDP;

PROCEDURE remoteio_server_adc_dac_pi_zero IS

  title  : CONSTANT String := "MuntsOS Remote I/O Server for ADC DAC Pi Zero";
  caps   : CONSTANT String := "ADC DAC GPIO";
  exec   : RemoteIO.Executive.Executor;
  srvh   : RemoteIO.Server.Instance;
  srvs   : RemoteIO.Server.Instance;
  srvu   : RemoteIO.Server.Instance;
  adc    : RemoteIO.ADC.Dispatcher;
  dac    : RemoteIO.DAC.Dispatcher;
  gpio   : RemoteIO.GPIO.Dispatcher;

BEGIN
  RemoteIO.Server.Foundation.Initialize(title, caps);
  exec := RemoteIO.Server.Foundation.Executor;

  -- Initialize server subsystem tasks

  srvh := RemoteIO.Server.Dev.Create(exec, "Raw HID", "/dev/hidg0");
  srvs := RemoteIO.Server.Serial.Create(exec, "Serial Port", "/dev/ttyGS0");
  srvu := RemoteIO.Server.UDP.Create(exec, "UDP");

  -- Create I/O subsystem objects

  adc  := RemoteIO.ADC.Create(exec);
  dac  := RemoteIO.DAC.Create(exec);
  gpio := RemoteIO.GPIO.Create(exec);

  -- Register user LED on GPIO channel 0, if possible

  IF Standard.GPIO.UserLED.Available THEN
    gpio.Register(0, Standard.GPIO.UserLED.Create, RemoteIO.GPIO.OutputOnly);
  END IF;

  -- Register I/O resources

  adc.Register(RemoteIO.ADC_DAC_Pi_Zero.AIN1,
    ABElectronics_ADC_DAC_Pi_Zero.Sample_Inputs(0));

  adc.Register(RemoteIO.ADC_DAC_Pi_Zero.AIN2,
    ABElectronics_ADC_DAC_Pi_Zero.Sample_Inputs(1));

  dac.Register(RemoteIO.ADC_DAC_Pi_Zero.AOUT1,
    ABElectronics_ADC_DAC_Pi_Zero.Sample_Outputs(0));

  dac.Register(RemoteIO.ADC_DAC_Pi_Zero.AOUT2,
    ABElectronics_ADC_DAC_Pi_Zero.Sample_Outputs(1));
END remoteio_server_adc_dac_pi_zero;
