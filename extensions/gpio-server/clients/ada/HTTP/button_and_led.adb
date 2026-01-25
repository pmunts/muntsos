-- MuntsOS GPIO Thin Server Button and LED Test Using HTTP

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
WITH Ada.Text_IO; USE Ada.Text_IO;

WITH GPIO;
WITH GPIO.HTTP;

PROCEDURE button_and_led IS

  Button    : GPIO.Pin;
  LED       : GPIO.Pin;
  ButtonNew : Boolean;
  ButtonOld : Boolean;

BEGIN
  New_Line;
  Put_Line("MuntsOS GPIO Thin Server Button and LED Test Using HTTP");
  New_Line;

  IF Ada.Command_Line.Argument_Count /= 1 THEN
    Put_Line("Usage: button_and_led <servername>");
    RETURN;
  END IF;

  -- Configure GPIO pins

  Button := GPIO.HTTP.Create(Ada.Command_Line.Argument(1) & ASCII.NUL,
    6, GPIO.Input);

  LED := GPIO.HTTP.Create(Ada.Command_Line.Argument(1) & ASCII.NUL,
    26, GPIO.Output);

  -- Force initial state change

  ButtonOld := NOT Button.Get;

  LOOP
    -- Read button input

    ButtonNew := Button.Get;

    -- See if the button state has changed

    IF ButtonNew /= ButtonOld THEN
      IF ButtonNew THEN
        Put_Line("PRESSED");
      ELSE
        Put_Line("RELEASED");
      END IF;

      LED.Put(ButtonNew);
      ButtonOld := ButtonNew;
    END IF;

    DELAY 0.1;
  END LOOP;

END button_and_led;
