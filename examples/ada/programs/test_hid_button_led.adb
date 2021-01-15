-- Linux Simple I/O Library HID button and LED test

-- Copyright (C)2016-2021, Philip Munts, President, Munts AM Corp.
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
WITH Ada.Exceptions;

WITH HID.Munts;
WITH HID.libsimpleio;
WITH Messaging;
WITH Message64;

USE TYPE Messaging.Byte;

PROCEDURE test_hid_button_led IS

  dev         : Message64.Messenger;
  ButtonState : Message64.Message := (OTHERS => 0);
  LEDCommand  : Message64.Message := (OTHERS => 0);

BEGIN
  New_Line;
  Put_Line("HID Button and LED Test");
  New_Line;

  -- Open the raw HID device

  dev := HID.libsimpleio.Create(HID.Munts.VID, HID.Munts.PID);

  -- Process incoming keypress reports

  LOOP
    BEGIN
      dev.Receive(ButtonState);

      CASE ButtonState(0) IS
        WHEN 0 =>
          Put_Line("RELEASE");
          LEDCommand(0) := 0;
          dev.Send(LEDCommand);

        WHEN 1 =>
          Put_Line("PRESS");
          LEDCommand(0) := 1;
          dev.Send(LEDCommand);

        WHEN OTHERS =>
          Put_Line("ERROR: Unexpected keypress status value");
      END CASE;
    EXCEPTION
      WHEN E : HID.HID_Error =>
        IF Ada.Exceptions.Exception_Message(E) /= "libLinux.Poll() timed out" THEN
          RAISE;
        END IF;

      WHEN OTHERS =>
        RAISE;
    END;
  END LOOP;
EXCEPTION
  WHEN E : OTHERS =>
    Put_Line(Ada.Exceptions.Exception_Message(E));
END test_hid_button_led;
