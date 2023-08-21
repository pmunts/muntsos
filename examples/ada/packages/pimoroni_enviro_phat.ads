-- Pimoroni Enviro pHAT services

-- Copyright (C)2017-2023, Philip Munts dba Munts Technologies.
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

-- NOTE: Although the 6.144V full scale range is selected below, the
-- maximum voltage presented to any of the ADS1015 analog inputs must not
-- exceed 5.0V (the ADS1015 supply voltage).

WITH ADC;
WITH ADS1015;
WITH Analog;
WITH BMP280;
WITH GPIO.libsimpleio;
WITH I2C.libsimpleio;
WITH RaspberryPi;
WITH TCS3472;
WITH Voltage;

PACKAGE Pimoroni_Enviro_pHAT IS

  -- I2C bus controller object

  Bus : CONSTANT I2C.Bus := I2C.libsimpleio.Create(RaspberryPi.I2C1);

  -- I2C addresses of devices on the Enviro pHAT

  Address_ADS1015 : CONSTANT I2C.Address := 16#49#;
  Address_BMP280  : CONSTANT I2C.Address := 16#77#;
  Address_TCS3742 : CONSTANT I2C.Address := 16#29#;

  -- Analog inputs

  Sample_Inputs : CONSTANT ARRAY (0 .. 3) OF Analog.Input :=
   (ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN0, ADS1015.FSR6144),
    ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN1, ADS1015.FSR6144),
    ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN2, ADS1015.FSR6144),
    ADS1015.Create(Bus, Address_ADS1015, ADS1015.AIN3, ADS1015.FSR6144));

  Voltage_Inputs : CONSTANT ARRAY (0 .. 3) OF Voltage.Input :=
   (ADC.Create(Sample_Inputs(0), 6.144),
    ADC.Create(Sample_Inputs(1), 6.144),
    ADC.Create(Sample_Inputs(2), 6.144),
    ADC.Create(Sample_Inputs(3), 6.144));

  -- TCS3472 Light/Color sensor

  Light_Color : CONSTANT TCS3472.Device := TCS3472.Create(Bus, Address_TCS3742);

  -- Light/Color sensor illumination LEDs output

  LEDs : CONSTANT GPIO.Pin := GPIO.libsimpleio.Create(RaspberryPi.GPIO4, GPIO.Output, False);

  -- BMP280 Pressure/Temperature sensor

  Baro_Temp : CONSTANT BMP280.Device := BMP280.Create(Bus, Address_BMP280);

END Pimoroni_Enviro_pHAT;
