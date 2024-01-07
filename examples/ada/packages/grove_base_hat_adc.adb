-- Raspberry Pi with Grove Base Hat Zero (SKU 103030276) ADC Services

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

WITH ADC;
WITH Analog;
WITH I2C;

USE TYPE Analog.Sample;
USE TYPE I2C.Byte;

PACKAGE BODY Grove_Base_Hat_ADC IS

  -- Analog sampled data input constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address;
    chan : ChannelNumber) RETURN Analog.Input IS

  BEGIN
    RETURN NEW InputSubclass'(bus, addr, chan);
  END Create;

  -- Analog voltage data input constructor

  FUNCTION Create
   (bus  : I2C.Bus;
    addr : I2C.Address;
    chan : ChannelNumber) RETURN Voltage.Input IS

  BEGIN
    RETURN ADC.Create(Create(bus, addr, chan), Reference);
  END Create;

  -- Analog input method

  FUNCTION Get(Self : IN OUT InputSubclass) RETURN Analog.Sample IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 1);

  BEGIN
    cmd(0) := 16#10# + I2C.Byte(Self.chan);
    Self.Bus.Transaction(Self.addr, cmd, cmd'Length, resp, resp'Length);
    RETURN Analog.Sample(resp(0)) + Analog.Sample(resp(1))*256;
  END Get;

  -- Retrieve resolution

  FUNCTION GetResolution(Self : IN OUT InputSubclass) RETURN Positive IS

  BEGIN
    RETURN Resolution;
  END GetResolution;

END Grove_Base_Hat_ADC;
