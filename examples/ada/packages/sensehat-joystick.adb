-- Raspberry Pi Sense Hat joystick services

-- Copyright (C)2016-2024, Philip Munts dba Munts Technologies.
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

WITH I2C;

USE TYPE I2C.Byte;

PACKAGE BODY SenseHAT.Joystick IS

  -- Joystick status register address

  I2C_KEYS       : CONSTANT I2C.Byte := 16#F2#;

  -- Joystick register bit masks

  JOYSTICK_DOWN  : CONSTANT I2C.Byte := 1;
  JOYSTICK_RIGHT : CONSTANT I2C.Byte := 2;
  JOYSTICK_UP    : CONSTANT I2C.Byte := 4;
  JOYSTICK_PRESS : CONSTANT I2C.Byte := 8;
  JOYSTICK_LEFT  : CONSTANT I2C.Byte := 16;

  -- Joystick position method

  FUNCTION Position(self : DeviceSubclass) RETURN Standard.Joystick.Positions IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C_KEYS;
    SenseHAT.bus.Transaction(Address_AVR, cmd, cmd'Length, resp, resp'Length);

    -- Map joystick bit patterns to positions

    CASE resp(0) AND 16#1F# AND NOT JOYSTICK_PRESS IS
      WHEN 0                               => RETURN Standard.Joystick.Center;
      WHEN JOYSTICK_UP                     => RETURN Standard.Joystick.North;
      WHEN JOYSTICK_UP OR JOYSTICK_RIGHT   => RETURN Standard.Joystick.Northeast;
      WHEN JOYSTICK_RIGHT                  => RETURN Standard.Joystick.East;
      WHEN JOYSTICK_DOWN OR JOYSTICK_RIGHT => RETURN Standard.Joystick.Southeast;
      WHEN JOYSTICK_DOWN                   => RETURN Standard.Joystick.South;
      WHEN JOYSTICK_DOWN OR JOYSTICK_LEFT  => RETURN Standard.Joystick.Southwest;
      WHEN JOYSTICK_LEFT                   => RETURN Standard.Joystick.West;
      WHEN JOYSTICK_UP OR JOYSTICK_LEFT    => RETURN Standard.Joystick.Northwest;
      WHEN OTHERS => RAISE Standard.Joystick.Joystick_Error WITH
        "Invalid value from I2C_KEYS register: " & I2C.Byte'Image(resp(0));
    END CASE;
  END;

  -- Joystick pressed method

  FUNCTION Pressed(self : DeviceSubclass) RETURN Boolean IS

    cmd  : I2C.Command(0 .. 0);
    resp : I2C.Response(0 .. 0);

  BEGIN
    cmd(0) := I2C_KEYS;
    SenseHAT.bus.Transaction(Address_AVR, cmd, cmd'Length, resp, resp'Length);

    RETURN ((resp(0) AND JOYSTICK_PRESS) /= 0);
  END Pressed;

END SenseHAT.Joystick;
