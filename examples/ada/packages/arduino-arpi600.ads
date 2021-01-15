-- Definitions for the WaveShare ARPI600 Arduino adapter for Raspberry Pi
-- https://www.waveshare.com/wiki/ARPI600

-- Copyright (C)2018, Philip Munts, President, Munts AM Corp.
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

WITH ADC;
WITH Analog;
WITH Device;
WITH RaspberryPi;
WITH TLC1543;
WITH Voltage;

PACKAGE Arduino.ARPI600 IS

  -- Map Arduino GPIO names to Raspberry Pi GPIO names

  GPIO : CONSTANT ARRAY (Arduino.Pins) OF Device.Designator :=
   (D0  => RaspberryPi.GPIO15,  -- UART0 RxD
    D1  => RaspberryPi.GPIO14,  -- UART0 TxD
    D2  => RaspberryPi.GPIO17,
    D3  => RaspberryPi.GPIO18,  -- PWM0 channel 0
    D4  => RaspberryPi.GPIO27,
    D5  => RaspberryPi.GPIO22,
    D6  => RaspberryPi.GPIO23,
    D7  => RaspberryPi.GPIO24,
    D8  => RaspberryPi.GPIO25,
    D9  => RaspberryPi.GPIO4,
    D10 => RaspberryPi.GPIO8,   -- SPI0 CE0
    D11 => RaspberryPi.GPIO10,  -- SPI0 MOSI
    D12 => RaspberryPi.GPIO9,   -- SPI0 MISO
    D13 => RaspberryPi.GPIO11,  -- SPI0 SCLK
    A0  => RaspberryPi.GPIO7,   -- TLC1543 input 5, SPI0 CE1
    A1  => RaspberryPi.GPIO5,   -- TLC1543 input 4
    A2  => RaspberryPi.GPIO6,   -- TLC1543 input 3
    A3  => RaspberryPi.GPIO13,  -- TLC1543 input 2
    A4  => RaspberryPi.GPIO19,  -- TLC1543 input 1, I2C1 SDA, PWM1
    A5  => RaspberryPi.GPIO26); -- TLC1543 input 0, I2C1 SCL

  -- TLC1543 A/D converter control pins

  TLC1543_CLK  : CONSTANT Device.Designator := RaspberryPi.GPIO16;
  TLC1543_ADDR : CONSTANT Device.Designator := RaspberryPi.GPIO20;
  TLC1543_DATA : CONSTANT Device.Designator := RaspberryPi.GPIO21;

  -- TLC1543 A/D converter device

  devadc : CONSTANT TLC1543.Device :=
    TLC1543.Create(TLC1543_CLK, TLC1543_ADDR, TLC1543_DATA);

  -- TLC1543 A/D converter analog inputs

  Sample_Inputs : CONSTANT ARRAY (TLC1543.Channel) OF Analog.Input :=
   (devadc.Create(0),   -- Arduino A0
    devadc.Create(1),   -- Arduino A1
    devadc.Create(2),   -- Arduino A2
    devadc.Create(3),   -- Arduino A3
    devadc.Create(4),   -- Arduino A4
    devadc.Create(5),   -- Arduino A5
    devadc.Create(6),   -- Sensor Header row A pin 1
    devadc.Create(7),   -- Sensor Header row A pin 2
    devadc.Create(8),   -- Sensor Header row A pin 3
    devadc.Create(9),   -- Sensor Header row A pin 4
    devadc.Create(10)); -- Sensor Header row A pin 5

  -- The following are only useful if the ADC reference jumper is set to 3.3V

  Voltage_Inputs : CONSTANT ARRAY (TLC1543.Channel) OF Voltage.Input :=
   (ADC.Create(Arduino.ARPI600.Sample_Inputs(0),  3.3),  -- Arduino A0
    ADC.Create(Arduino.ARPI600.Sample_Inputs(1),  3.3),  -- Arduino A1
    ADC.Create(Arduino.ARPI600.Sample_Inputs(2),  3.3),  -- Arduino A2
    ADC.Create(Arduino.ARPI600.Sample_Inputs(3),  3.3),  -- Arduino A3
    ADC.Create(Arduino.ARPI600.Sample_Inputs(4),  3.3),  -- Arduino A4
    ADC.Create(Arduino.ARPI600.Sample_Inputs(5),  3.3),  -- Arduino A5
    ADC.Create(Arduino.ARPI600.Sample_Inputs(6),  3.3),  -- Sensor Header row A pin 1
    ADC.Create(Arduino.ARPI600.Sample_Inputs(7),  3.3),  -- Sensor Header row A pin 2
    ADC.Create(Arduino.ARPI600.Sample_Inputs(8),  3.3),  -- Sensor Header row A pin 3
    ADC.Create(Arduino.ARPI600.Sample_Inputs(9),  3.3),  -- Sensor Header row A pin 4
    ADC.Create(Arduino.ARPI600.Sample_Inputs(10), 3.3)); -- Sensor Header row A pin 5

END Arduino.ARPI600;
