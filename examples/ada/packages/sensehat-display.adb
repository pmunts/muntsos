-- Raspberry Pi Sense Hat LED matrix display services

-- Copyright (C)2016-2018, Philip Munts, President, Munts AM Corp.
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

PACKAGE BODY SenseHAT.Display IS

  -- The following constants may be adjusted to equalize the perceived
  -- brightness of the individual LED colors.  The minimum allowed value
  -- is 4, since each abstract pixel color has 256 brightness levels but
  -- each physical LED color pellet has 64 brightness levels.
  -- There is a tradeoff, though: Increasing the normalization constant
  -- reduces the number of possible color gradations.

  RED_NORMALIZE   : CONSTANT := 4;
  GREEN_NORMALIZE : CONSTANT := 4;
  BLUE_NORMALIZE  : CONSTANT := 4;

  -- Write a single pixel

  PROCEDURE Put
   (self  : DisplaySubclass;
    row   : Natural;
    col   : Natural;
    value : TrueColor.Pixel) IS

    cmd : I2C.Command(0 .. 1);

  BEGIN
    cmd(0) := I2C.Byte(row)*24 + I2C.Byte(col);
    cmd(1) := I2C.Byte(value.red)/RED_NORMALIZE;
    SenseHAT.bus.Write(Address_AVR, cmd, cmd'Length);

    cmd(0) := I2C.Byte(row)*24 + I2C.Byte(col) + 8;
    cmd(1) := I2C.Byte(value.green)/GREEN_NORMALIZE;
    SenseHAT.bus.Write(Address_AVR, cmd, cmd'Length);

    cmd(0) := I2C.Byte(row)*24 + I2C.Byte(col) + 16;
    cmd(1) := I2C.Byte(value.blue)/BLUE_NORMALIZE;
    SenseHAT.bus.Write(Address_AVR, cmd, cmd'Length);
  END Put;

  -- Write a pixel buffer to the display

  PROCEDURE Put (self : DisplaySubclass; buf : TrueColor.Screen) IS

    cmd : I2C.Command(0 .. 192);

  BEGIN
    IF buf NOT IN SenseHAT.Display.Screen THEN
      RAISE Constraint_Error WITH "buf is not subtype SenseHAT.Display.Screen";
    END IF;

    cmd(0) := 0;

    -- Transform screen buffer to command buffer

    FOR row IN buf'Range(1) LOOP
      FOR col IN buf'Range(2) LOOP
        cmd(row*24 + col + 1)  := I2C.Byte(Natural(buf(row, col).red)/RED_NORMALIZE);
        cmd(row*24 + col + 9)  := I2C.Byte(Natural(buf(row, col).green)/GREEN_NORMALIZE);
        cmd(row*24 + col + 17) := I2C.Byte(Natural(buf(row, col).blue)/BLUE_NORMALIZE);
      END LOOP;
    END LOOP;

    -- Block write the LED data

    SenseHAT.bus.Write(Address_AVR, cmd, cmd'Length);
  END Put;

  -- Clear the display

  PROCEDURE Clear(self : DisplaySubclass) IS

    cmd : I2C.Command(0 .. 192);

  BEGIN
    cmd := (OTHERS => 0);

    -- Block write the LED data

    SenseHAT.bus.Write(Address_AVR, cmd, cmd'Length);
  END Clear;

END SenseHAT.Display;
