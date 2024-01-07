-- Callback service implementations for the FreeMODBUS library
-- as customized for the AB Electronics ADC DAC Pi Zero.

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


WITH Ada.Unchecked_Conversion;
WITH GNAT.Byte_Swapping;

WITH ABElectronics_ADC_DAC_Pi_Zero;
WITH Voltage;

PACKAGE BODY FreeMODBUS.Services IS

  Inputs : CONSTANT ARRAY (word RANGE 0 .. 1) OF Voltage.Input :=
    (ABElectronics_ADC_DAC_Pi_Zero.Voltage_Inputs(0),
     ABElectronics_ADC_DAC_Pi_Zero.Voltage_Inputs(1));

  Outputs : CONSTANT ARRAY (word RANGE 0 .. 1) OF Voltage.Output :=
    (ABElectronics_ADC_DAC_Pi_Zero.Voltage_Outputs(0),
     ABElectronics_ADC_DAC_Pi_Zero.Voltage_Outputs(1));

  SUBTYPE Register_Pair IS wordarray(0 .. 1);

  FUNCTION To_Register_Pair IS
    NEW Ada.Unchecked_Conversion(Short_Float, Register_Pair);

  FUNCTION To_Short_Float IS
    NEW Ada.Unchecked_Conversion(Register_Pair, Short_Float);

  HoldingRegisterStash : wordarray(0 .. 3);

  -- Discrete inputs

  FUNCTION eMBRegDiscreteCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word) RETURN int IS

  BEGIN
    RETURN MB_ENOREG;
  END eMBRegDiscreteCB;

 -- Coils

  FUNCTION eMBRegCoilsCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word;
    mode  : int) RETURN int IS

  BEGIN
    RETURN MB_ENOREG;
  END eMBRegCoilsCB;

  -- Input registers

  -- Must be read as exactly 1 even numbered register pair

  -- Register pair 0:1 is the 32-bit single precision voltage sampled from IN1
  -- Register pair 2:3 is the 32-bit single precision voltage sampled from IN2

  FUNCTION eMBRegInputCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word) RETURN int IS

  BEGIN
    IF addr NOT IN 0 | 2  THEN
      RETURN MB_ENOREG;
    END IF;

    IF addr + count - 1 NOT IN 1 | 3 THEN
      RETURN MB_ENOREG;
    END IF;

    IF count NOT IN 2 THEN
      RETURN MB_ENOREG;
    END IF;

    BEGIN
      buf(0 .. 1) := To_Register_Pair(Short_Float(Inputs(addr/2).Get));
    EXCEPTION
      WHEN OTHERS =>
        RETURN MB_EIO;
    END;

    -- Rearrange bytes to network byte order
    GNAT.Byte_Swapping.Swap4(buf(0)'Address);
    GNAT.Byte_Swapping.Swap2(buf(0)'Address);
    GNAT.Byte_Swapping.Swap2(buf(1)'Address);

    RETURN MB_ENOERR;
  END eMBRegInputCB;

  -- Holding registers

  FUNCTION eMBRegHoldingCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word;
    mode  : int) RETURN int IS

  BEGIN
    IF addr NOT IN 0 | 2  THEN
      RETURN MB_ENOREG;
    END IF;

    IF addr + count - 1 NOT IN 1 | 3 THEN
      RETURN MB_ENOREG;
    END IF;

    IF count NOT IN 2 THEN
      RETURN MB_ENOREG;
    END IF;

    CASE mode IS
      WHEN MB_REG_READ =>
        buf(0 .. 1) := HoldingRegisterStash(addr .. addr+1);
        -- Rearrange bytes to network byte order
        GNAT.Byte_Swapping.Swap4(buf(0)'Address);
        GNAT.Byte_Swapping.Swap2(buf(0)'Address);
        GNAT.Byte_Swapping.Swap2(buf(1)'Address);

      WHEN MB_REG_WRITE =>
        -- Rearrange bytes from network byte order
        GNAT.Byte_Swapping.Swap2(buf(0)'Address);
        GNAT.Byte_Swapping.Swap2(buf(1)'Address);
        GNAT.Byte_Swapping.Swap4(buf(0)'Address);

        BEGIN
          Outputs(addr/2).Put(Voltage.Volts(To_Short_Float(buf(0 .. 1))));
          HoldingRegisterStash(addr .. addr+1) := buf(0 .. 1);
        EXCEPTION
          WHEN OTHERS =>
            RETURN MB_EIO;
        END;

      WHEN OTHERS =>
        RETURN MB_EINVAL;
    END CASE;

    RETURN MB_ENOERR;
  END eMBRegHoldingCB;

END FreeMODBUS.Services;
