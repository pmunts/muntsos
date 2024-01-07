-- RasPiO Analog Zero (built with an MCP3208) hat services

-- Copyright (C)2017-2024, Philip Munts dba Munts Technologies.
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
WITH MCP3208;
WITH SPI.libsimpleio;
WITH Voltage;

PACKAGE RasPiO_Analog_Zero_MCP3208 IS

  -- SPI slave device

  spidev : CONSTANT SPI.Device := SPI.libsimpleio.Create("/dev/spidev0.0",
    0, 8, 1000000);

  -- Analog inputs

  Sample_Inputs  : CONSTANT ARRAY (MCP3208.Channel) OF Analog.Input :=
   (MCP3208.Create(spidev, 0),
    MCP3208.Create(spidev, 1),
    MCP3208.Create(spidev, 2),
    MCP3208.Create(spidev, 3),
    MCP3208.Create(spidev, 4),
    MCP3208.Create(spidev, 5),
    MCP3208.Create(spidev, 6),
    MCP3208.Create(spidev, 7));

  Voltage_Inputs : CONSTANT ARRAY (MCP3208.Channel) OF Voltage.Input :=
   (ADC.Create(Sample_Inputs(0), 3.3),
    ADC.Create(Sample_Inputs(1), 3.3),
    ADC.Create(Sample_Inputs(2), 3.3),
    ADC.Create(Sample_Inputs(3), 3.3),
    ADC.Create(Sample_Inputs(4), 3.3),
    ADC.Create(Sample_Inputs(5), 3.3),
    ADC.Create(Sample_Inputs(6), 3.3),
    ADC.Create(Sample_Inputs(7), 3.3));

END RasPiO_Analog_Zero_MCP3208;
