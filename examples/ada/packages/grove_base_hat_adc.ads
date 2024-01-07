-- Grove Base Hat ADC Services

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
WITH I2C;
WITH Voltage;

PACKAGE Grove_Base_Hat_ADC IS

  Resolution : CONSTANT := 12;

  Reference  : CONSTANT := 3.3;

  TYPE ChannelNumber IS RANGE 0 .. 7;

  -- Define a subclass of Analog.InputInterface

  TYPE InputSubclass IS NEW Analog.InputInterface WITH PRIVATE;

  -- Analog sampled data input constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address;
    chan : ChannelNumber) RETURN Analog.Input;

  -- Analog voltage data input constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address;
    chan : ChannelNumber) RETURN Voltage.Input;

  -- Analog input method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample;

  -- Retrieve resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive;

PRIVATE

  TYPE InputSubclass IS NEW Analog.InputInterface WITH RECORD
    bus  : I2C.Bus;
    addr : I2C.Address;
    chan : ChannelNumber;
  END RECORD;

END Grove_Base_Hat_ADC;
