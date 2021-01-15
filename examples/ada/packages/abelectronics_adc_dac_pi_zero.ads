-- AB Electronics ADC DAC Pi Zero hat services

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
WITH DAC;
WITH MCP3202;
WITH MCP4822;
WITH SPI.libsimpleio;
WITH Voltage;

PACKAGE ABElectronics_ADC_DAC_Pi_Zero IS

  -- SPI slave devices

  devadc  : CONSTANT SPI.Device :=
    SPI.libsimpleio.Create("/dev/spidev0.0", 0, 8, 1000000);

  devdac  : CONSTANT SPI.Device :=
    SPI.libsimpleio.Create("/dev/spidev0.1", 0, 8, 1000000);

  -- Analog inputs

  Sample_Inputs   : CONSTANT ARRAY (MCP3202.Channel) OF Analog.Input :=
   (MCP3202.Create(devadc, 0),
    MCP3202.Create(devadc, 1));

  Voltage_Inputs  : CONSTANT ARRAY (MCP3202.Channel) OF Voltage.Input :=
   (ADC.Create(Sample_Inputs(0), 3.3),
    ADC.Create(Sample_Inputs(1), 3.3));

  -- Analog outputs

  Sample_Outputs  : CONSTANT ARRAY (MCP4822.Channel) OF Analog.Output :=
   (MCP4822.Create(devdac, 0),
    MCP4822.Create(devdac, 1));

  Voltage_Outputs : CONSTANT ARRAY (MCP4822.Channel) OF Voltage.Output :=
   (DAC.Create(Sample_Outputs(0), 2.048),
    DAC.Create(Sample_Outputs(1), 2.048));

END ABElectronics_ADC_DAC_Pi_Zero;
