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

WITH Ada.Exceptions;
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Device;
WITH GPIO.libsimpleio;

PACKAGE BODY Sprinkler.Valves.GPIO.libsimpleio IS

  PACKAGE Natural_IO IS NEW Ada.Text_IO.Integer_IO(Natural);

  -- Register a watering zone valve controlled by a GPIO pin

  PROCEDURE Register(zone : ZoneNumber; desg : Device.Designator) IS

  BEGIN
    Put_Line(" Zone" & ZoneNumber'Image(zone) &
      " valve at libsimpleio GPIO pin " &
      Ada.Strings.Fixed.Trim(Natural'Image(desg.chip), Ada.Strings.Both)
      & ":" &
      Ada.Strings.Fixed.Trim(Natural'Image(desg.chan), Ada.Strings.Both));

    Register(zone, Standard.GPIO.libsimpleio.Create(desg, Standard.GPIO.Output));
  END Register;

  -- Load a list of valves from a text file with the following semantics:
  -- Any line containing only white space is ignored.
  -- Any line beginning with # is ignored.
  -- A configuration line consists of three numeric fields separated by
  -- whitespace:  watering zone number (Positive), GPIO chip number (Natural)
  -- and GPIO channel number (Natural).

  PROCEDURE LoadFromFile(filename : String) IS

    F : File_Type;

  BEGIN
    Open(F, In_File, filename);

    LOOP
      <<Continue>>

      DECLARE
        inbuf : String :=
          Ada.Strings.Fixed.Trim(Get_Line(F), Ada.Strings.Both);

        zone  : ZoneNumber;
        chip  : Natural;
        chan  : Natural;
        last  : Positive;

      BEGIN
        -- Ignore blank lines
        IF inbuf'Length = 0 THEN
          GOTO Continue;
        END IF;

        -- Ignore comment lines
        IF inbuf(1) = '#' THEN
          GOTO Continue;
        END IF;

        ZoneNumber_IO.Get(inbuf(1 .. inbuf'Last), zone, last);
        Natural_IO.Get(inbuf(last + 1 .. inbuf'Last), chip, last);
        Natural_IO.Get(inbuf(last + 1 .. inbuf'Last), chan, last);

        Register(zone, Device.Designator'(chip, chan));
      END;
    END LOOP;
  EXCEPTION
    WHEN End_Error =>
      Close(F);
      RETURN;

    WHEN Name_Error =>
      RAISE;

    WHEN OTHERS =>
      Close(F);
      RAISE;
  END LoadFromFile;

END Sprinkler.Valves.GPIO.libsimpleio;
