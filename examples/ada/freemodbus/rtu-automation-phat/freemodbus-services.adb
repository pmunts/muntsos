-- Callback service implementations for the FreeMODBUS library
-- as customized for the Pimoroni Automation pHAT

-- Copyright (C)2019-2020, Philip Munts, President, Munts AM Corp.
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
WITH Pimoroni_Automation_pHAT;

PACKAGE BODY FreeMODBUS.Services IS

  SUBTYPE Register_Pair IS wordarray(0 .. 1);

  FUNCTION To_Register_Pair IS
    NEW Ada.Unchecked_Conversion(Short_Float, Register_Pair);

  BitMasks : CONSTANT ARRAY (word RANGE 0 .. 7) OF Byte :=
   (1, 2, 4, 8, 16, 32, 64, 128);

  -- Discrete inputs

  FUNCTION eMBRegDiscreteCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word) RETURN int IS

  BEGIN
    IF Natural(addr) NOT IN Pimoroni_Automation_pHAT.Digital_Inputs'Range THEN
      RETURN MB_ENOREG;
    END IF;

    IF Natural(addr + count - 1) NOT IN Pimoroni_Automation_pHAT.Digital_Inputs'Range THEN
      RETURN MB_ENOREG;
    END IF;

    FOR i IN word RANGE 0 .. (count-1)/8 LOOP
      buf(i) := 0;
    END LOOP;

    FOR i IN word RANGE 0 .. count - 1 LOOP
      IF Pimoroni_Automation_pHAT.Digital_Inputs(Natural(addr + i)).Get THEN
        buf(i/8) := buf(i/8) OR BitMasks(i MOD 8);
      END IF;
    END LOOP;

    RETURN MB_ENOERR;
  END eMBRegDiscreteCB;

 -- Coils

  FUNCTION eMBRegCoilsCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word;
    mode  : int) RETURN int IS

  BEGIN
    IF Natural(addr) NOT IN Pimoroni_Automation_pHAT.Digital_Outputs'Range THEN
      RETURN MB_ENOREG;
    END IF;

    IF Natural(addr + count - 1) NOT IN Pimoroni_Automation_pHAT.Digital_Outputs'Range THEN
      RETURN MB_ENOREG;
    END IF;

    CASE mode IS
      WHEN MB_REG_READ =>
        FOR i IN word RANGE 0 .. (count-1)/8 LOOP
          buf(i) := 0;
        END LOOP;

        FOR i IN word RANGE 0 .. count - 1 LOOP
          IF Pimoroni_Automation_pHAT.Digital_Outputs(Natural(addr + i)).Get THEN
            buf(i/8) := buf(i/8) OR BitMasks(i MOD 8);
          END IF;
        END LOOP;

      WHEN MB_REG_WRITE =>
        FOR i IN word RANGE 0 .. count - 1 LOOP
          Pimoroni_Automation_pHAT.Digital_Outputs(Natural(addr + i)).Put((buf(i/8) AND BitMasks(i MOD 8)) /= 0);
        END LOOP;

      WHEN OTHERS =>
        RETURN MB_EINVAL;
    END CASE;

    RETURN MB_ENOERR;
  END eMBRegCoilsCB;

  -- Input registers

  -- Must be read as exactly 1 to 3 even numbered registered pairs

  -- Register pair 0:1 is the 32-bit single precision voltage sampled from ADC1
  -- Register pair 2:3 is the 32-bit single precision voltage sampled from ADC2
  -- Register pair 4:5 is the 32-bit single precision voltage sampled from ADC3

  FUNCTION eMBRegInputCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word) RETURN int IS

    t : word;

  BEGIN
    IF addr NOT IN 0 | 2 | 4 THEN
      RETURN MB_ENOREG;
    END IF;

    IF addr + count - 1 NOT IN 1 | 3 | 5 THEN
      RETURN MB_ENOREG;
    END IF;

    IF count NOT IN 2 | 4 | 6 THEN
      RETURN MB_ENOREG;
    END IF;

    FOR i IN word RANGE 0 .. count/2 - 1 LOOP
      buf(i*2 .. i*2+1) :=
        To_Register_Pair(Short_Float(Pimoroni_Automation_pHAT.Voltage_Inputs(Natural(i + addr/2 + 1)).Get));

      -- Swap words in the register pair such that the result, as seen by a
      -- little-endian libmodbus client, will be in network byte order.
      t          := buf(i*2);
      buf(i*2)   := buf(i*2+1);
      buf(i*2+1) := t;
    END LOOP;

    RETURN MB_ENOERR;
  END eMBRegInputCB;

  -- Holding registers

  FUNCTION eMBRegHoldingCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word;
    mode  : int) RETURN int IS

  BEGIN
    RETURN MB_ENOREG;
  END eMBRegHoldingCB;

END FreeMODBUS.Services;
