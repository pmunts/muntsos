-- Waveshare CM4-Duino (https://www.waveshare.com/wiki/CM4-Duino) LED Test

-- Copyright (C)2024, Philip Munts dba Munts Technologies.
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

WITH Ada.Text_IO;
USE Ada.Text_IO;

WITH Arduino.CM4_Duino;
WITH GPIO;

PROCEDURE test_cm4_duino_led IS

  LED : GPIO.Pin;

BEGIN
  New_Line;
  Put_Line("CM4-Duino LED Test");
  New_Line;

  -- Create GPIO output object

  LED := Arduino.CM4_Duino.Create(Arduino.CM4_Duino.LED, GPIO.Output);

  -- Flash the LED

  Put_Line("Press CONTROL-C to exit.");
  New_Line;

  LOOP
    LED.Put(NOT LED.Get);
    DELAY 0.5;
  END LOOP;
END test_cm4_duino_led;
