-- Raspberry Pi Sense Hat Motion Sensors Test

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

WITH Accelerometer;
WITH Magnetometer;
WITH SenseHAT.Display;
WITH SenseHAT.Sensors;
WITH TrueColor;

USE TYPE Accelerometer.Gravities;
USE TYPE Magnetometer.Gauss;

USE Accelerometer.Gravities_IO;
USE Magnetometer.Gauss_IO;

PROCEDURE test_raspberrypi_sensehat_motion IS

  avec : Accelerometer.Vector;
  arow : Natural := 0;
  acol : Natural := 0;
  mvec : Magnetometer.Vector;
  mrow : Natural := 0;
  mcol : Natural := 0;

  FUNCTION Clip(n : Integer) RETURN Natural IS

  BEGIN
    IF n < 0 THEN
      RETURN 0;
    ELSIF n > 7 THEN
      RETURN 7;
    ELSE
      RETURN n;
    END IF;
  END Clip;

BEGIN
  New_Line;
  Put_Line("Raspberry Pi Sense Hat Motion Sensors Test");
  New_Line;
  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  SenseHAT.Display.Display.Clear;

  LOOP
    SenseHAT.Display.Display.Put(arow, acol, TrueColor.Black);
    --SenseHAT.Display.Display.Put(mrow, mcol, TrueColor.Black);

    avec := SenseHAT.Sensors.Motion.Get;
    mvec := SenseHAT.Sensors.Motion.Get;

    Put(ASCII.CR);
    Put("Acceleration:");
    Put(avec.x, 3, 1, 0);
    Put(avec.y, 3, 1, 0);
    Put(avec.z, 3, 1, 0);
    Put("  Magnetic field:");
    Put(mvec.x, 8, 1, 0);
    Put(mvec.y, 8, 1, 0);
    --Put(mvec.z, 8, 1, 0);

    arow := Clip(Integer(4.0 - 6.0*avec.y));
    acol := Clip(Integer(4.0 - 6.0*avec.x));
    SenseHAT.Display.Display.Put(arow, acol, TrueColor.Green);

    mrow := Clip(Integer(4.0 - 4.0/0.65*mvec.y));
    mcol := Clip(Integer(4.0 - 4.0/0.65*mvec.x));
    --SenseHAT.Display.Display.Put(mrow, mcol, TrueColor.Blue);

    DELAY 0.1;
  END LOOP;
END test_raspberrypi_sensehat_motion;
