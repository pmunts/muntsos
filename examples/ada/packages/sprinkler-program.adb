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

WITH Ada.Calendar;
WITH Ada.Containers.Vectors;
WITH Ada.Strings.Fixed;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH Sprinkler.Valves;

PACKAGE BODY Sprinkler.Program IS

  -- Data declarations

  TYPE Step IS RECORD
    zone         : ZoneNumber;
    valve        : Sprinkler.Valve;
    start_second : Duration;
    stop_second  : Duration;
  END RECORD;

  PACKAGE StepVectors IS NEW Ada.Containers.Vectors(Positive, Step);

  Steps : StepVectors.Vector;

  -- Add a watering program step.

  PROCEDURE Add
   (zone       : ZoneNumber;
    start_hour : Hour;
    stop_hour  : Hour) IS

    valve : CONSTANT Sprinkler.Valve := Sprinkler.Valves.Lookup(zone);

  BEGIN
    IF start_hour > stop_hour THEN
      RAISE Error WITH "Start hour is after stop hour";
    END IF;

    Put_Line(" Zone " &
      Ada.Strings.Fixed.Trim(ZoneNumber'Image(zone), Ada.Strings.Both) &
      " start hour " &
      Ada.Strings.Fixed.Trim(Hour'Image(start_hour), Ada.Strings.Both) &
      " stop hour " &
      Ada.Strings.Fixed.Trim(Hour'Image(stop_hour), Ada.Strings.Both));

    Steps.Append(Step'(zone, valve, Duration(start_hour)*3600.0,
      Duration(stop_hour)*3600.0));
  END Add;

  -- Load a watering program from a text file with the following semantics:
  -- Any line containing only white space is ignored.
  -- Any line beginning with # is ignored.
  -- A configuraton line consists of three numeric fields separated by
  -- whitespace:  watering zone number (Positive), start hour (Fixed Point) and
  -- stop hour (Fixed Point).

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
        start : Hour;
        stop  : Hour;
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
        Hour_IO.Get(inbuf(last + 1 .. inbuf'Last), start, last);
        Hour_IO.Get(inbuf(last + 1 .. inbuf'Last), stop, last);

        Add(zone, start, stop);
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

  -- Execute the watering program.

  PROCEDURE Execute IS

    T        : CONSTANT Duration := Ada.Calendar.Seconds(Ada.Calendar.Clock);
    Watering : Boolean;

  BEGIN
    FOR S OF Steps LOOP
      Watering := (T >= S.start_second AND T <= S.stop_second);

      IF Watering AND NOT S.valve.Get THEN
        Ada.Text_IO.Put_Line("Turning zone" & ZoneNumber'Image(S.zone) & " ON");
        S.valve.Put(True);
      ELSIF NOT Watering AND S.valve.Get THEN
        Ada.Text_IO.Put_Line("Turning zone" & ZoneNumber'Image(S.zone) & " OFF");
        S.Valve.Put(False);
      END IF;
    END LOOP;
  END Execute;

END Sprinkler.Program;
