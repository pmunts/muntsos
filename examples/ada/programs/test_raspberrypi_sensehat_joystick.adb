-- Raspberry Pi Sense Hat Joystick Test

-- Copyright (C)2017-2018, Philip Munts, President, Munts AM Corp.
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

WITH Joystick;
WITH TrueColor;
WITH SenseHAT.Display;
WITH SenseHAT.Joystick;

USE TYPE Joystick.Positions;

PROCEDURE test_raspberrypi_sensehat_joystick IS

  presscounter : Natural;
  screens      : ARRAY (Boolean, Joystick.Positions) OF SenseHAT.Display.Screen;

BEGIN
  Put_Line("Raspberry Pi Sense Hat Joystick Test");
  New_Line;

  SenseHAT.Display.Display.Clear;

  -- Prepare screen buffers

  FOR b IN Boolean LOOP
    FOR p in Joystick.Positions LOOP
      FOR r in SenseHAT.Display.Screen'Range(1) LOOP
        FOR c in SenseHAT.Display.Screen'Range(2) LOOP
          screens(b, p)(r, c) := TrueColor.Black;
        END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;

  screens(False, Joystick.Center)(3, 3) := TrueColor.Green;
  screens(False, Joystick.Center)(3, 4) := TrueColor.Green;
  screens(False, Joystick.Center)(4, 3) := TrueColor.Green;
  screens(False, Joystick.Center)(4, 4) := TrueColor.Green;
  screens(True,  Joystick.Center)(3, 3) := TrueColor.Red;
  screens(True,  Joystick.Center)(3, 4) := TrueColor.Red;
  screens(True,  Joystick.Center)(4, 3) := TrueColor.Red;
  screens(True,  Joystick.Center)(4, 4) := TrueColor.Red;

  screens(False, Joystick.North)(0, 3) := TrueColor.Green;
  screens(False, Joystick.North)(0, 4) := TrueColor.Green;
  screens(False, Joystick.North)(1, 3) := TrueColor.Green;
  screens(False, Joystick.North)(1, 4) := TrueColor.Green;
  screens(True,  Joystick.North)(0, 3) := TrueColor.Red;
  screens(True,  Joystick.North)(0, 4) := TrueColor.Red;
  screens(True,  Joystick.North)(1, 3) := TrueColor.Red;
  screens(True,  Joystick.North)(1, 4) := TrueColor.Red;

  screens(False, Joystick.Northeast)(0, 6) := TrueColor.Green;
  screens(False, Joystick.Northeast)(0, 7) := TrueColor.Green;
  screens(False, Joystick.Northeast)(1, 6) := TrueColor.Green;
  screens(False, Joystick.Northeast)(1, 7) := TrueColor.Green;
  screens(True,  Joystick.Northeast)(0, 6) := TrueColor.Red;
  screens(True,  Joystick.Northeast)(0, 7) := TrueColor.Red;
  screens(True,  Joystick.Northeast)(1, 6) := TrueColor.Red;
  screens(True,  Joystick.Northeast)(1, 7) := TrueColor.Red;

  screens(False, Joystick.East)(3, 6) := TrueColor.Green;
  screens(False, Joystick.East)(4, 6) := TrueColor.Green;
  screens(False, Joystick.East)(3, 7) := TrueColor.Green;
  screens(False, Joystick.East)(4, 7) := TrueColor.Green;
  screens(True,  Joystick.East)(3, 6) := TrueColor.Red;
  screens(True,  Joystick.East)(4, 6) := TrueColor.Red;
  screens(True,  Joystick.East)(3, 7) := TrueColor.Red;
  screens(True,  Joystick.East)(4, 7) := TrueColor.Red;

  screens(False, Joystick.Southeast)(6, 6) := TrueColor.Green;
  screens(False, Joystick.Southeast)(6, 7) := TrueColor.Green;
  screens(False, Joystick.Southeast)(7, 6) := TrueColor.Green;
  screens(False, Joystick.Southeast)(7, 7) := TrueColor.Green;
  screens(True,  Joystick.Southeast)(6, 6) := TrueColor.Red;
  screens(True,  Joystick.Southeast)(6, 7) := TrueColor.Red;
  screens(True,  Joystick.Southeast)(7, 6) := TrueColor.Red;
  screens(True,  Joystick.Southeast)(7, 7) := TrueColor.Red;

  screens(False, Joystick.South)(6, 3) := TrueColor.Green;
  screens(False, Joystick.South)(6, 4) := TrueColor.Green;
  screens(False, Joystick.South)(7, 3) := TrueColor.Green;
  screens(False, Joystick.South)(7, 4) := TrueColor.Green;
  screens(True,  Joystick.South)(6, 3) := TrueColor.Red;
  screens(True,  Joystick.South)(6, 4) := TrueColor.Red;
  screens(True,  Joystick.South)(7, 3) := TrueColor.Red;
  screens(True,  Joystick.South)(7, 4) := TrueColor.Red;

  screens(False, Joystick.Southwest)(6, 0) := TrueColor.Green;
  screens(False, Joystick.Southwest)(6, 1) := TrueColor.Green;
  screens(False, Joystick.Southwest)(7, 0) := TrueColor.Green;
  screens(False, Joystick.Southwest)(7, 1) := TrueColor.Green;
  screens(True,  Joystick.Southwest)(6, 0) := TrueColor.Red;
  screens(True,  Joystick.Southwest)(6, 1) := TrueColor.Red;
  screens(True,  Joystick.Southwest)(7, 0) := TrueColor.Red;
  screens(True,  Joystick.Southwest)(7, 1) := TrueColor.Red;

  screens(False, Joystick.West)(3, 0) := TrueColor.Green;
  screens(False, Joystick.West)(4, 0) := TrueColor.Green;
  screens(False, Joystick.West)(3, 1) := TrueColor.Green;
  screens(False, Joystick.West)(4, 1) := TrueColor.Green;
  screens(True,  Joystick.West)(3, 0) := TrueColor.Red;
  screens(True,  Joystick.West)(4, 0) := TrueColor.Red;
  screens(True,  Joystick.West)(3, 1) := TrueColor.Red;
  screens(True,  Joystick.West)(4, 1) := TrueColor.Red;

  screens(False, Joystick.Northwest)(0, 0) := TrueColor.Green;
  screens(False, Joystick.Northwest)(0, 1) := TrueColor.Green;
  screens(False, Joystick.Northwest)(1, 0) := TrueColor.Green;
  screens(False, Joystick.Northwest)(1, 1) := TrueColor.Green;
  screens(True,  Joystick.Northwest)(0, 0) := TrueColor.Red;
  screens(True,  Joystick.Northwest)(0, 1) := TrueColor.Red;
  screens(True,  Joystick.Northwest)(1, 0) := TrueColor.Red;
  screens(True,  Joystick.Northwest)(1, 1) := TrueColor.Red;

  -- Now exercise the joystick

  Put_Line("Move joystick around...");
  New_Line;
  Put_Line("Press center button for 5 seconds to exit.");
  New_Line;

  presscounter := 0;

  WHILE presscounter < 50 LOOP
    SenseHAT.Display.Display.Put(Screens(SenseHAT.Joystick.Joystick.Pressed,
      SenseHAT.Joystick.Joystick.Position));

    IF SenseHAT.Joystick.Joystick.Pressed AND
      SenseHAT.Joystick.Joystick.Position = Joystick.Center THEN
      presscounter := presscounter + 1;
    ELSE
      presscounter := 0;
    END IF;

    DELAY 0.1;
  END LOOP;

  SenseHAT.Display.Display.Clear;
END test_raspberrypi_sensehat_joystick;
