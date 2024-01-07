-- Raspberry Pi with Grove Base Hat Zero (SKU 103030276) I/O Resources

-- Copyright (C)2020-2024, Philip Munts dba Munts Technologies.
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
WITH Device;
WITH Grove_Base_Hat_ADC;
WITH I2C.libsimpleio;
WITH RaspberryPi;
WITH Voltage;

PACKAGE Grove_Base_Hat_Zero IS

  -- I2C bus controller object

  Bus : CONSTANT I2C.Bus := I2C.libsimpleio.Create(RaspberryPi.I2C1);

  -- Analog Inputs

  Sample_Inputs  : CONSTANT ARRAY (0 .. 5) OF Analog.Input :=
    (Grove_Base_Hat_ADC.Create(Bus, 16#04#, 0),         -- Socket A0 pin 1
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 1),         -- Socket A0 pin 2
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 2),         -- Socket A2 pin 1
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 3),         -- Socket A2 pin 2
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 4),         -- Socket A4 pin 1
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 5));        -- Socket A0 pin 2

  Voltage_Inputs : CONSTANT ARRAY (0 .. 5) OF Voltage.Input :=
    (Grove_Base_Hat_ADC.Create(Bus, 16#04#, 0),         -- Socket A0 pin 1
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 1),         -- Socket A0 pin 2
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 2),         -- Socket A2 pin 1
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 3),         -- Socket A2 pin 2
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 4),         -- Socket A4 pin 1
     Grove_Base_Hat_ADC.Create(Bus, 16#04#, 5));        -- Socket A0 pin 2

  -- GPIO Pins

  D5  : Device.Designator RENAMES RaspberryPi.GPIO5;    -- Socket D5 pin 1
  D6  : Device.Designator RENAMES RaspberryPi.GPIO6;    -- Socket D5 pin 2
  D12 : Device.Designator RENAMES RaspberryPi.GPIO12;   -- Socket PWM pin 1
  D13 : Device.Designator RENAMES RaspberryPi.GPIO13;   -- Socket PWM pin 2
  D16 : Device.Designator RENAMES RaspberryPi.GPIO16;   -- Socket D16 pin 1
  D17 : Device.Designator RENAMES RaspberryPi.GPIO17;   -- Socket D16 pin 2

  -- Extra GPIO pins on the SWD header -- These conflict with SPI0!
  -- You must disable SPI0 in /boot/config.txt:
  --
  -- dtparam=spi=off

  D9  : Device.Designator RENAMES RaspberryPi.GPIO9;    -- SWD header pin 3
  D10 : Device.Designator RENAMES RaspberryPi.GPIO10;   -- SWD header pin 4
  D11 : Device.Designator RENAMES RaspberryPi.GPIO11;   -- SWD header pin 2

  -- PWM Outputs -- These conflict with D12 and D13!

  -- One of the following device tree overlays must be enabled in
  -- /boot/config.txt:
  --
  -- dtoverlay=pwm,pin=12,func=4
  -- OR
  -- dtoverlay=pwm,pin=13,func=4
  -- OR
  -- dtoverlay=pwm-2chan,pin=12,func=4,pin2=13,func2=4

  PWM12 : Device.Designator RENAMES RaspberryPi.PWM0; -- Socket PWM pin 1
  PWM13 : Device.Designator RENAMES RaspberryPi.PWM1; -- Socket PWM pin 2

END Grove_Base_Hat_zero;
