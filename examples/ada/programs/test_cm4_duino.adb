-- Waveshare CM4-Duino (https://www.waveshare.com/wiki/CM4-Duino) Constructor Test

-- Copyright (C)2024-2025, Philip Munts dba Munts Technologies.
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

PRAGMA Warnings(Off, "variable ""*"" is assigned but never read");

WITH Ada.Text_IO; USE  Ada.Text_IO;
WITH Ada.Exceptions;

WITH Arduino.CM4_Duino;
WITH GPIO;
WITH I2C;
WITH PWM;
WITH SPI;

PROCEDURE test_cm4_duino IS

  P : GPIO.Pin;
  B : I2C.Bus;
  O : PWM.Output;
  D : SPI.Device;

BEGIN
  New_Line;
  Put_Line("CM4-Duino Constructor Test");
  New_Line;

  FOR x IN Arduino.CM4_Duino.GPIOs LOOP
    BEGIN
      P := Arduino.CM4_Duino.Create(x, GPIO.Output);
      Put(x'Image); Put_Line(" Succeeded");
    EXCEPTION
      WHEN e : OTHERS =>
        Put(x'Image);
        Put(" Failed: ");
        Put_Line(Ada.Exceptions.Exception_Message(e));
    END;
  END LOOP;

  FOR x IN Arduino.CM4_Duino.Buttons LOOP
    BEGIN
      P := Arduino.CM4_Duino.Create(x, GPIO.Input);
      Put(x'Image); Put_Line(" Succeeded");
    EXCEPTION
      WHEN e : OTHERS =>
        Put(x'Image);
        Put(" Failed: ");
        Put_Line(Ada.Exceptions.Exception_Message(e));
    END;
  END LOOP;

  FOR x IN Arduino.CM4_Duino.LEDs LOOP
    BEGIN
      P := Arduino.CM4_Duino.Create(x, GPIO.Output);
      Put(x'Image); Put_Line(" Succeeded");
    EXCEPTION
      WHEN e : OTHERS =>
        Put(x'Image);
        Put(" Failed: ");
        Put_Line(Ada.Exceptions.Exception_Message(e));
    END;
  END LOOP;

  FOR x IN Arduino.CM4_Duino.I2CBuses LOOP
    BEGIN
      B := Arduino.CM4_Duino.Create(x);
      Put(x'Image); Put_Line(" Succeeded");
    EXCEPTION
      WHEN e : OTHERS =>
        Put(x'Image);
        Put(" Failed: ");
        Put_Line(Ada.Exceptions.Exception_Message(e));
    END;
  END LOOP;

  FOR x IN Arduino.CM4_Duino.PWMOutputs LOOP
    BEGIN
      O := Arduino.CM4_Duino.Create(x, 1000);
      Put(x'Image);
      Put_Line(" Succeeded");
    EXCEPTION
      WHEN e : OTHERS =>
        Put(x'Image);
        Put(" Failed: ");
        Put_Line(Ada.Exceptions.Exception_Message(e));
    END;
  END LOOP;

  FOR x IN Arduino.CM4_Duino.SPIDevices LOOP
    BEGIN
      D := Arduino.CM4_Duino.Create(x, 0, 8, 1000000);
      Put(x'Image);
      Put_Line(" Succeeded");
    EXCEPTION
      WHEN e : OTHERS =>
        Put(x'Image);
        Put(" Failed: ");
        Put_Line(Ada.Exceptions.Exception_Message(e));
    END;
  END LOOP;
END test_cm4_duino;
