-- MuntsOS GPIO Thin Server Toggle Speed Test Using HTTP

-- Copyright (C)2017-2024, Philip Munts dba Munts Technologies.
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

WITH Ada.Command_Line;
WITH Ada.Real_Time; USE Ada.Real_Time;
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO;
WITH GPIO.HTTP;

PROCEDURE Toggle_Speed IS

  PinNumber  : Natural;
  Iterations : Positive;

  p : GPIO.Pin;
  starttime : Time;
  stoptime  : Time;
  deltat    : Duration;
  rate      : Duration;
  cycletime : Duration;

  PACKAGE duration_io IS NEW Fixed_IO(Duration);
  USE duration_io;

BEGIN
  New_Line;
  Put_Line("MuntsOS GPIO Thin Server Toggle Speed Test Using HTTP");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 3 THEN
    Put_Line("Usage: toggle_speed <servername> <pin number> <iterations>");
    RETURN;
  END IF;

  PinNumber  := Natural'Value(Ada.Command_Line.Argument(2));
  Iterations := Positive'Value(Ada.Command_Line.Argument(3));

  -- Configure GPIO pins

  p := GPIO.HTTP.Create(Ada.Command_Line.Argument(1) & ASCII.NUL,
    PinNumber, GPIO.Output);

  -- Perform GPIO toggle speed test

  Put_Line("Performing" & Positive'Image(Iterations) & " GPIO writes...");
  New_Line;

  starttime := Clock;

  FOR i IN 1 .. Iterations/2 LOOP
    p.Put(True);
    p.Put(False);
  END LOOP;

  stoptime := Clock;

  -- Display results

  deltat    := To_Duration(stoptime - starttime);
  rate      := Duration(Iterations) / deltat;
  cycletime := deltat / Duration(iterations);

  Put("Performed" & Positive'Image(Iterations) & " GPIO writes in ");
  Put(deltat, 0, 1);
  Put_Line(" seconds");

  Put("  ");
  Put(rate, 0, 1);
  Put_Line(" iterations per second");

  Put("  ");
  Put(cycletime*1E6, 0, 1);
  Put_Line(" microseconds per iteration");
  New_Line;
END Toggle_Speed;
