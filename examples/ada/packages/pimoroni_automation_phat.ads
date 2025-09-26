-- Pimoroni Automation pHAT services

-- Copyright (C)2017-2025, Philip Munts dba Munts Technologies.
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

-- NOTE: The ADS1015 is a true differential 12-bit A/D converter producing
-- two's complement samples.
--
-- In differential input mode, sample values range from -2048 to +2047.
-- In single ended input mode, sample values range from 0 to +2047.

-- Here we operate the ADS1015 in single ended input mode, effectively
-- reducing its resolution to 11 bits.

-- NOTE: The Pimoroni Automation pHAT analog inputs are scaled by an 820K
-- series resistor and a 120K shunt resistor, producing an effective input
-- gain of 0.128.

WITH ADC;
WITH ADS1015;
WITH Analog;
WITH Device;
WITH GPIO.libsimpleio;
WITH I2C.libsimpleio;
WITH RaspberryPi;
WITH Voltage;

PACKAGE Pimoroni_Automation_pHAT IS

  -- I2C bus controller object

  Bus : CONSTANT I2C.Bus := I2C.libsimpleio.Create(RaspberryPi.I2C1);

  -- I2C addresses of devices on the Automation pHAT

  Address_ADS1015 : CONSTANT I2C.Address := 16#48#;

  -- Analog inputs

  Sample_Inputs : CONSTANT ARRAY (1 .. 3) OF Analog.Input :=
   (ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN0, ADS1015.FSR4096),
    ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN1, ADS1015.FSR4096),
    ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN2, ADS1015.FSR4096));

  Voltage_Inputs : CONSTANT ARRAY (1 .. 3) OF Voltage.Input :=
   (ADC.Create(Sample_Inputs(1), 4.096, 0.128),
    ADC.Create(Sample_Inputs(2), 4.096, 0.128),
    ADC.Create(Sample_Inputs(3), 4.096, 0.128));

  -- Digital inputs

  INPUT1 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO26, GPIO.Input);
  INPUT2 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO20, GPIO.Input);
  INPUT3 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO21, GPIO.Input);

  Digital_Inputs : CONSTANT ARRAY (1 .. 3) OF GPIO.Pin := (INPUT1, INPUT2, INPUT3);

  -- Current sinking digital outputs

  OUTPUT1 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO5,  GPIO.Output, False);
  OUTPUT2 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO12, GPIO.Output, False);
  OUTPUT3 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO6,  GPIO.Output, False);

  -- Relays

  RELAY1 : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO16, GPIO.Output, False);

  Digital_Outputs : CONSTANT ARRAY (1 .. 4) OF GPIO.Pin := (OUTPUT1, OUTPUT2, OUTPUT3, RELAY1);

  -- SPI device on expansion header

  SPI0 : CONSTANT Device.Designator := RaspberryPi.SPI0_0;
END Pimoroni_Automation_pHAT;
