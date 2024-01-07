-- Definitions for the Raspberry Pi Arduino Shield Add-on
-- https://www.itead.cc/wiki/RPI_Arduino_Sheild_Add-on_V2.0 [sic]

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

WITH Device;
WITH RaspberryPi;

PACKAGE Arduino.RaspberryPiShieldAddon IS

  -- Map Arduino GPIO names to Raspberry Pi GPIO names

  GPIO : CONSTANT ARRAY (Arduino.Pins) OF Device.Designator :=
   (D0  => RaspberryPi.GPIO15,  -- UART0 RxD
    D1  => RaspberryPi.GPIO14,  -- UART0 TxD
    D2  => RaspberryPi.GPIO17,
    D3  => RaspberryPi.GPIO18,  -- PWM0 channel 0
    D4  => RaspberryPi.GPIO7,   -- SPI0 CE1
    D5  => RaspberryPi.GPIO27,
    D6  => RaspberryPi.GPIO22,
    D7  => RaspberryPi.GPIO23,
    D8  => RaspberryPi.GPIO24,
    D9  => RaspberryPi.GPIO25,
    D10 => RaspberryPi.GPIO8,   -- SPI0 CE0
    D11 => RaspberryPi.GPIO10,  -- SPI0 MOSI
    D12 => RaspberryPi.GPIO9,   -- SPI0 MISO
    D13 => RaspberryPi.GPIO11,  -- SPI0 SCLK
    A0  => RaspberryPi.GPIO4,
    A1  => RaspberryPi.GPIO5,
    A2  => RaspberryPi.GPIO6,
    A3  => RaspberryPi.GPIO12,
    A4  => RaspberryPi.GPIO2,   -- I2C1 SDA
    A5  => RaspberryPi.GPIO3);  -- I2C1 SCL

END Arduino.RaspberryPiShieldAddon;
