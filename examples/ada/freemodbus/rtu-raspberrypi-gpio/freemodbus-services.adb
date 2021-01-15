-- Callback service implementations for the FreeMODBUS library
-- as customized for Raspberry Pi GPIO pins

-- Copyright (C)2020, Philip Munts, President, Munts AM Corp.
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

-- Semantics:
--
-- Discrete inputs 2 to 27 map directly to Raspberry Pi GPIO pins 2 to 27.
-- Reading from a discrete input (re)configures the corresponding GPIO pin as
-- an input.
--
-- Coils 2 to 27 map directly to Raspberry Pi GPIO pins 2 to 27.
-- Writing to a coil (re)configures the corresponding GPIO pin as an output.
-- Reading from a coil configured as an output reads back the corresponding
-- GPIO pin output state.
-- Reading from a coil not configured as an output (re)configures the
-- corresponding GPIO pin as an output with a state of OFF.
--
-- Don't try to use a GPIO pin as both a discrete input and a coil!
--
-- Input registers are not implemented.
--
-- Holding registers are not implemented.

WITH Ada.Exceptions;
WITH GPIO.libsimpleio;
WITH Logging.libsimpleio;

PACKAGE BODY FreeMODBUS.Services IS

  TYPE PinConfigs IS (Input, Output, Unconfigured);

  TYPE PinElement IS RECORD
    config : PinConfigs := Unconfigured;
    object : GPIO.libsimpleio.PinSubclass := GPIO.libsimpleio.Destroyed;
  END RECORD;

  PinTable : ARRAY (word RANGE 2 .. 27) OF PinElement;

  -- Discrete inputs aka Raspberry Pi GPIO input pins

  FUNCTION eMBRegDiscreteCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word) RETURN int IS

  BEGIN
    -- Validate address

    IF addr NOT IN PinTable'Range THEN
      RETURN MB_ENOREG;
    END IF;

    -- Only allow working with one GPIO at a time

    IF count > 1 THEN
      RETURN MB_EINVAL;
    END IF;

    buf(0) := 0;

    -- Configure the GPIO pin as an input, if necessary

    BEGIN
      IF PinTable(addr).config /= Input THEN
        PinTable(addr).object.Initialize((0, Natural(addr)), GPIO.Input);
        PinTable(addr).config := Input;
      END IF;

    EXCEPTION
      WHEN E: OTHERS =>
        Logging.libsimpleio.Error("GPIO Input Initialize failed");
        Logging.libsimpleio.Error(Ada.Exceptions.Exception_Message(E));
        PinTable(addr).object := GPIO.libsimpleio.Destroyed;
        PinTable(addr).config := Unconfigured;
        RETURN MB_EIO;
    END;

    -- Read the GPIO pin state

    BEGIN
      buf(0) := Boolean'Pos(PinTable(addr).object.Get);

    EXCEPTION
      WHEN E : OTHERS =>
        Logging.libsimpleio.Error("GPIO Input Get failed");
        Logging.libsimpleio.Error(Ada.Exceptions.Exception_Message(E));
        RETURN MB_EIO;
    END;

    RETURN MB_ENOERR;
  END eMBRegDiscreteCB;

 -- Coils aka Raspberry Pi GPIO output pins

  FUNCTION eMBRegCoilsCB
   (buf   : IN OUT bytearray;
    addr  : word;
    count : word;
    mode  : int) RETURN int IS

  BEGIN
    -- Validate address

    IF addr NOT IN PinTable'Range THEN
      RETURN MB_ENOREG;
    END IF;

    -- Only allow working with one GPIO at a time

    IF count > 1 THEN
      RETURN MB_EINVAL;
    END IF;

    CASE mode IS
      WHEN MB_REG_READ =>
        buf(0) := 0;

        -- Configure the GPIO pin as an output, if necessary

        BEGIN
          IF PinTable(addr).config /= Output THEN
            PinTable(addr).object.Initialize((0, Natural(addr)), GPIO.Output, False);
            PinTable(addr).config := Output;
            RETURN MB_ENOERR;
          END IF;

        EXCEPTION
          WHEN E : OTHERS =>
            Logging.libsimpleio.Error("GPIO Output Initialize failed");
            Logging.libsimpleio.Error(Ada.Exceptions.Exception_Message(E));
            PinTable(addr).object := GPIO.libsimpleio.Destroyed;
            PinTable(addr).config := Unconfigured;
            RETURN MB_EIO;
        END;

        -- Read the GPIO pin state

        BEGIN
          buf(0) := Boolean'Pos(PinTable(addr).object.Get);

        EXCEPTION
          WHEN E : OTHERS =>
            Logging.libsimpleio.Error("GPIO Output Get failed");
            Logging.libsimpleio.Error(Ada.Exceptions.Exception_Message(E));
            RETURN MB_EIO;
        END;

      WHEN MB_REG_WRITE =>
        -- Configure the GPIO pin as an output, if necessary

        BEGIN
          IF PinTable(addr).config /= Output THEN
            PinTable(addr).object.Initialize((0, Natural(addr)), GPIO.Output, Boolean'Val(buf(0)));
            PinTable(addr).config := Output;
            RETURN MB_ENOERR;
          END IF;

        EXCEPTION
          WHEN E : OTHERS =>
            Logging.libsimpleio.Error("GPIO Output Initialize failed");
            Logging.libsimpleio.Error(Ada.Exceptions.Exception_Message(E));
            PinTable(addr).object := GPIO.libsimpleio.Destroyed;
            PinTable(addr).config := Unconfigured;
            RETURN MB_EIO;
        END;

        -- Write the GPIO pin state

        BEGIN
          PinTable(addr).object.Put(Boolean'Val(buf(0)));

        EXCEPTION
          WHEN E : OTHERS =>
            Logging.libsimpleio.Error("GPIO Output Put failed");
            Logging.libsimpleio.Error(Ada.Exceptions.Exception_Message(E));
            RETURN MB_EIO;
        END;

      WHEN OTHERS =>
        RETURN MB_EINVAL;
    END CASE;

    RETURN MB_ENOERR;
  END eMBRegCoilsCB;

  -- Input registers

  FUNCTION eMBRegInputCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word) RETURN int IS

  BEGIN
    RETURN MB_ENOREG; -- Not implemented
  END eMBRegInputCB;

  -- Holding registers

  FUNCTION eMBRegHoldingCB
   (buf   : IN OUT wordarray;
    addr  : word;
    count : word;
    mode  : int) RETURN int IS

  BEGIN
    RETURN MB_ENOREG; -- Not implemented
  END eMBRegHoldingCB;

END FreeMODBUS.Services;
