-- Mikroelektronika Pi 3 Click Shield Analog Inputs

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
WITH MCP3204;
WITH SPI.libsimpleio;
WITH Voltage;

PACKAGE Pi3ClickShield IS

  -- SPI slave device

  spidev : CONSTANT SPI.Device := SPI.libsimpleio.Create("/dev/spidev1.0",
    0, 8, 1_000_000);

  -- Analog inputs

  Sample_Inputs : CONSTANT ARRAY (0 .. 1) OF Analog.Input :=
   (MCP3204.Create(spidev, 0),
    MCP3204.Create(spidev, 1));

  Voltage_Inputs: CONSTANT ARRAY (0 .. 1) OF Voltage.Input :=
   (ADC.Create(Sample_Inputs(0), 4.096),
    ADC.Create(Sample_Inputs(1), 4.096));

END Pi3ClickShield;
