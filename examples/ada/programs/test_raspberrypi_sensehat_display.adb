-- Test program for the Raspberry Pi Sense Hat

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

WITH Ada.Text_IO; USE Ada.Text_IO;

WITH SenseHAT.Display;
WITH TrueColor;

PROCEDURE test_raspberrypi_sensehat_display IS

  screen : SenseHAT.Display.Screen;

BEGIN
  Put_Line("Raspberry Pi Sense Hat Display Test");
  New_Line;

  SenseHAT.Display.Display.Clear;

  -- Try pixel writes...

  DELAY 1.0;

  Put_Line("Write pixels Red...");

  FOR row IN SenseHAT.Display.Screen'Range(1) LOOP
    FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
      SenseHAT.Display.Display.Put(row, col, TrueColor.Red);
      DELAY 0.05;
    END LOOP;
  END LOOP;

  Put_line("Write pixels Green...");

  FOR row IN SenseHAT.Display.Screen'Range(1) LOOP
    FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
      SenseHAT.Display.Display.Put(row, col, TrueColor.Green);
      DELAY 0.05;
    END LOOP;
  END LOOP;

  DELAY 1.0;

  -- Try display buffer write

  Put_Line("Write whole display...");

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(0, col) := TrueColor.Beige;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(1, col) := TrueColor.Brown;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(2, col) := TrueColor.Blue;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(3, col) := TrueColor.DarkOrange;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(4, col) := TrueColor.FireBrick;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(5, col) := TrueColor.HoneyDew;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(6, col) := TrueColor.OliveDrab;
  END LOOP;

  FOR col IN SenseHAT.Display.Screen'Range(2) LOOP
    screen(7, col) := TrueColor.White;
  END LOOP;

  SenseHAT.Display.Display.Put(screen);
  DELAY 2.0;
  SenseHAT.Display.Display.Clear;
END test_raspberrypi_sensehat_display;
