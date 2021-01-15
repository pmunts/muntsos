-- Raspberry Pi Sense Hat Climate Sensors Test

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

WITH SenseHAT.Sensors;

WITH Humidity;
WITH Pressure;
WITH Temperature;

USE TYPE Humidity.Relative;
USE TYPE Pressure.Pascals;
USE TYPE Temperature.Celsius;

PROCEDURE test_raspberrypi_sensehat_climate IS

BEGIN
  Put_Line("Raspberry Pi Sense Hat Climate Sensors Test");
  New_Line;

  LOOP
    Put("HTS221  temperature: ");
    Temperature.Celsius_IO.Put(SenseHAT.Sensors.Humidity.Get, 0, 1, 0);
    Put(" humidity: ");
    Humidity.Relative_IO.Put(SenseHAT.Sensors.Humidity.Get, 0, 1, 0);
    Put("%");
    New_Line;

    Put("LPS25H  temperature: ");
    Temperature.Celsius_IO.Put(SenseHAT.Sensors.Pressure.Get, 0, 1, 0);
    Put(" pressure: ");
    Pressure.Pascals_IO.Put(SenseHAT.Sensors.Pressure.Get/100.0, 0, 1, 0);
    Put(" hPA");
    New_Line;

    Put("LSM9DS1 temperature: ");
    Temperature.Celsius_IO.Put(SenseHAT.Sensors.Motion.Get, 0, 1, 0);
    New_Line;
    New_Line;

    DELAY 2.0;
  END LOOP;
END test_raspberrypi_sensehat_climate;
